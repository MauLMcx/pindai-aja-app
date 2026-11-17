"""Logika inti petshop-dev.

Sengaja TIDAK bergantung pada paket MCP supaya bisa dites dengan Python biasa.
server.py hanya membungkus fungsi-fungsi di sini menjadi tool MCP.
Aturan mengacu ke SPEC.md (EAN-13 §6.11, struk §11, impor §14, invarian §3/§7).
"""
from __future__ import annotations

import csv
import json
import re
import sqlite3
import textwrap
from pathlib import Path
from typing import Any

# ---------------------------------------------------------------- EAN-13 ---


def ean13_check_digit(d12: str) -> int:
    if not (len(d12) == 12 and d12.isdigit()):
        raise ValueError("harus tepat 12 digit angka")
    total = sum(int(c) * (3 if i % 2 else 1) for i, c in enumerate(d12))
    return (10 - total % 10) % 10


def is_valid_ean13(code: str) -> bool:
    return len(code) == 13 and code.isdigit() and ean13_check_digit(code[:12]) == int(code[12])


def gen_ean13_internal(store_code2: str, seq: int) -> str:
    """Barcode internal toko: '2' + kode toko 2 digit + urut 9 digit + digit cek.

    Awalan 2x (20-29) adalah rentang EAN untuk pemakaian dalam toko.
    """
    if not (len(store_code2) == 2 and store_code2.isdigit()):
        raise ValueError("store_code2 harus 2 digit angka")
    if not (0 <= seq <= 999_999_999):
        raise ValueError("seq harus 0..999999999")
    d12 = "2" + store_code2 + f"{seq:09d}"
    return d12 + str(ean13_check_digit(d12))


# ---------------------------------------------------------- Pratinjau struk ---

PAY_LABEL = {
    "cash": "Tunai", "qris": "QRIS", "ewallet": "E-Wallet",
    "transfer": "Transfer", "card": "Kartu", "credit": "Kasbon",
}


def fmt_num(n: int) -> str:
    sign = "-" if n < 0 else ""
    return sign + f"{abs(int(n)):,}".replace(",", ".")


def _lr(left: str, right: str, width: int) -> str:
    space = width - len(left) - len(right)
    if space < 1:
        left = left[: max(0, width - len(right) - 1)]
        space = width - len(left) - len(right)
    return left + " " * space + right


def receipt_preview(data: dict[str, Any], width: int = 32) -> str:
    """Pratinjau teks struk. width 32 (58 mm) atau 48 (80 mm)."""
    if width not in (32, 42, 48):
        raise ValueError("width yang didukung: 32, 42, 48")
    out: list[str] = []
    sep = "-" * width
    out.append(str(data.get("store_name", "TOKO")).center(width).rstrip())
    for ln in textwrap.wrap(str(data.get("address", "")), width) if data.get("address") else []:
        out.append(ln.center(width).rstrip())
    out.append(sep)
    out.append(_lr("No", str(data.get("receipt_no", "")), width))
    out.append(_lr("Tgl", str(data.get("datetime", "")), width))
    if data.get("cashier"):
        out.append(_lr("Kasir", str(data["cashier"]), width))
    out.append(sep)
    for it in data.get("items", []):
        name_lines = textwrap.wrap(str(it["name"]), width, break_long_words=True) or [""]
        out.extend(name_lines)
        out.append(_lr(f"{it['qty']} x {fmt_num(it['unit_price'])}", fmt_num(it["line_total"]), width))
        if it.get("discount"):
            out.append(_lr("  Diskon", "-" + fmt_num(it["discount"]), width))
    out.append(sep)
    out.append(_lr("Subtotal", fmt_num(data["subtotal"]), width))
    if data.get("discount_total"):
        out.append(_lr("Diskon", "-" + fmt_num(data["discount_total"]), width))
    out.append(_lr("TOTAL", fmt_num(data["total"]), width))
    for p in data.get("payments", []):
        out.append(_lr(PAY_LABEL.get(p["method"], p["method"]), fmt_num(p["amount"]), width))
    if data.get("change"):
        out.append(_lr("Kembali", fmt_num(data["change"]), width))
    out.append(sep)
    for ln in textwrap.wrap(str(data.get("footer", "Terima kasih")), width):
        out.append(ln.center(width).rstrip())
    return "\n".join(out)


# ------------------------------------------------------------ Impor Excel ---

SHEET_CONFIG: dict[str, dict[str, Any]] = {
    "Bintang Petshop": dict(
        supplier="Bintang Petshop", scale=1000,
        cols=dict(category="Kategori", name="Produk", size="Isi / Ukuran",
                  old="Harga lama (dicoret)", price="Harga", note="Catatan")),
    "Multifeed": dict(
        supplier="Multifeed", scale=1000, brand_default="Multifeed",
        cols=dict(name="Kode Produk", price="Harga", note="Catatan")),
    "Bintang J-Pock": dict(
        supplier="Bintang J-Pock", scale=1000,
        cols=dict(brand="Merek", name="Produk", size="Berat", price="Harga beli", note="Catatan")),
    "Bintang 99 Sungai Ulin": dict(
        supplier="Bintang 99 Sungai Ulin", scale=1,
        cols=dict(category="Kategori", name="Produk", old="Harga lama (dicoret)",
                  price="Harga (Rp)", note="Catatan")),
}

CSV_COLUMNS = [
    "supplier", "brand", "name", "variant", "category", "size_text",
    "size_base_value", "size_base_unit", "pack_qty", "buy_price_idr",
    "old_price_idr", "needs_price_review", "review_reasons",
    "source_sheet", "source_row", "notes",
]

_UNCLEAR_RE = re.compile(r"\((?:tulisan\s+)?(?:dicoret,\s*)?kurang jelas\)", re.I)
_STRUCK_NAME_RE = re.compile(r"\(dicoret\)", re.I)
_NOTE_FLAGS = ("coret", "tip-ex", "ditimpa", "dikoreksi", "tanda \"")


def _num(v: Any) -> int | None:
    if v is None or v == "":
        return None
    if isinstance(v, (int, float)):
        return int(round(v))
    digits = re.sub(r"[^\d]", "", str(v))
    return int(digits) if digits else None


def parse_size(text: str | None) -> tuple[int | None, str | None, int | None]:
    """-> (nilai dalam satuan dasar, 'gram'|'ml', isi per dus)."""
    if not text:
        return None, None, None
    t = str(text).lower()
    pack = None
    m = re.search(r"isi\s*(\d+)", t)
    if m:
        pack = int(m.group(1))
    value = unit = None
    m = re.search(r"(\d+(?:[.,]\d+)?)\s*(kg|gr|g|liter|l)\b", t)
    if m:
        num = float(m.group(1).replace(",", "."))
        u = m.group(2)
        if u == "kg":
            value, unit = round(num * 1000), "gram"
        elif u in ("gr", "g"):
            value, unit = round(num), "gram"
        else:
            value, unit = round(num * 1000), "ml"
    return value, unit, pack


def _find_header(ws) -> tuple[int, dict[str, int]] | None:
    for r_idx, row in enumerate(ws.iter_rows(values_only=True), start=1):
        if row and row[0] == "No":
            return r_idx, {str(h).strip(): i for i, h in enumerate(row) if h}
    return None


def import_excel(xlsx_path: str, out_dir: str, scales: dict[str, int] | None = None) -> dict[str, Any]:
    """Normalisasi Data_Harga_Pakan.xlsx -> CSV + laporan (SPEC §14).

    Prinsip: tidak menebak. Harga kosong tetap kosong dan ditandai.
    """
    import openpyxl  # impor lokal agar modul tetap ringan

    wb = openpyxl.load_workbook(xlsx_path, data_only=True)
    rows_out: list[dict[str, Any]] = []
    report: dict[str, Any] = {"sheets": {}, "unknown_sheets": []}

    for ws in wb.worksheets:
        cfg = SHEET_CONFIG.get(ws.title)
        if cfg is None:
            report["unknown_sheets"].append(ws.title)
            continue
        scale = (scales or {}).get(ws.title, cfg["scale"])
        found = _find_header(ws)
        if not found:
            report["sheets"][ws.title] = {"error": "baris header 'No' tidak ditemukan"}
            continue
        header_row, hidx = found
        cmap = {k: hidx.get(v) for k, v in cfg["cols"].items()}
        stat = {"scale": scale, "read": 0, "imported": 0, "flagged": 0, "skipped": []}

        def cell(row, key):
            i = cmap.get(key)
            return row[i] if i is not None and i < len(row) else None

        for r_idx, row in enumerate(ws.iter_rows(min_row=header_row + 1, values_only=True), start=header_row + 1):
            if not row or all(v is None for v in row):
                continue
            raw_name = cell(row, "name")
            if not isinstance(row[0], (int, float)) and row[0] is not None:
                stat["skipped"].append({"row": r_idx, "reason": "catatan kaki"})
                continue
            if raw_name is None or not str(raw_name).strip():
                stat["skipped"].append({"row": r_idx, "reason": "baris kosong di catatan"})
                continue
            stat["read"] += 1
            raw_name = str(raw_name).strip()
            note = (str(cell(row, "note")).strip() if cell(row, "note") else "")
            if _STRUCK_NAME_RE.search(raw_name) or "seluruh baris dicoret" in note.lower():
                stat["skipped"].append({"row": r_idx, "reason": f"baris dicoret: {raw_name}"})
                continue

            reasons: list[str] = []
            if _UNCLEAR_RE.search(raw_name) or "kurang jelas" in raw_name.lower():
                reasons.append("tulisan kurang jelas")
            if "dicoret" in raw_name.lower():
                reasons.append("kode dicoret")
            name = _UNCLEAR_RE.sub("", raw_name).strip()

            variant = ""
            m = re.search(r"\(([^()]+)\)\s*$", name)
            if m:
                variant = m.group(1).strip()
                name = name[: m.start()].strip()

            size_text = cell(row, "size")
            size_text = str(size_text).strip() if size_text else ""
            size_val, size_unit, pack = parse_size(size_text or name)
            if pack is not None:
                reasons.append("harga per dus atau per pcs? konfirmasi")

            price = _num(cell(row, "price"))
            old = _num(cell(row, "old"))
            price_idr = price * scale if price is not None else None
            old_idr = old * scale if old is not None else None
            if price_idr is None:
                reasons.append("harga kosong")
            elif price_idr < 1000:
                reasons.append("harga di bawah Rp1.000, cek skala")
            if any(f in note.lower() for f in _NOTE_FLAGS):
                reasons.append(f"catatan: {note}")

            brand = cell(row, "brand") or cfg.get("brand_default") or ""
            rows_out.append({
                "supplier": cfg["supplier"], "brand": str(brand).strip(), "name": name,
                "variant": variant, "category": cell(row, "category") or "",
                "size_text": size_text, "size_base_value": size_val or "",
                "size_base_unit": size_unit or "", "pack_qty": pack or "",
                "buy_price_idr": price_idr if price_idr is not None else "",
                "old_price_idr": old_idr if old_idr is not None else "",
                "needs_price_review": bool(reasons), "review_reasons": "; ".join(reasons),
                "source_sheet": ws.title, "source_row": r_idx, "notes": note,
            })
            stat["imported"] += 1
            stat["flagged"] += 1 if reasons else 0
        report["sheets"][ws.title] = stat

    out = Path(out_dir)
    out.mkdir(parents=True, exist_ok=True)
    csv_path = out / "products_import.csv"
    with csv_path.open("w", newline="", encoding="utf-8-sig") as f:
        w = csv.DictWriter(f, fieldnames=CSV_COLUMNS)
        w.writeheader()
        w.writerows(rows_out)

    report["total_imported"] = len(rows_out)
    report["total_flagged"] = sum(1 for r in rows_out if r["needs_price_review"])
    report["rows_without_size"] = sum(1 for r in rows_out if r["size_base_value"] == "")
    report["note"] = ("Tidak ada harga jual di file sumber. Kolom size kosong berarti "
                      "satuan/ukuran belum tertulis dan harus dilengkapi pemilik.")
    report["csv"] = str(csv_path)
    rep_path = out / "import_report.json"
    rep_path.write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding="utf-8")
    report["report"] = str(rep_path)
    return report


# ------------------------------------------------------ Pemeriksa invarian ---

_CHECKS: list[tuple[str, str, str]] = [
    ("subtotal_vs_items", "error",
     """SELECT s.id FROM sales s WHERE s.status='completed' AND s.deleted_at IS NULL
        AND s.subtotal <> COALESCE((SELECT SUM(line_total) FROM sale_items i WHERE i.sale_id=s.id AND i.deleted_at IS NULL),0)"""),
    ("total_formula", "error",
     "SELECT id FROM sales WHERE status='completed' AND total <> subtotal - discount_total"),
    ("payments_vs_total", "error",
     """SELECT s.id FROM sales s WHERE s.status='completed' AND s.deleted_at IS NULL
        AND COALESCE((SELECT SUM(amount) FROM payments p WHERE p.sale_id=s.id AND p.deleted_at IS NULL),0) - s.change_amount <> s.total"""),
    ("qty_base_vs_factor", "error",
     """SELECT i.id FROM sale_items i JOIN product_units u ON u.id=i.unit_id
        WHERE i.qty_base <> i.qty * u.factor_to_base"""),
    ("duplicate_barcode", "error",
     """SELECT barcode FROM product_units WHERE barcode IS NOT NULL AND deleted_at IS NULL
        GROUP BY store_id, barcode HAVING COUNT(*) > 1"""),
    ("bad_factor", "error", "SELECT id FROM product_units WHERE factor_to_base <= 0"),
    ("negative_stock", "warning",
     "SELECT product_id FROM stock_movements GROUP BY product_id HAVING SUM(qty_base_delta) < 0"),
]


def check_invariants(db_path: str) -> dict[str, Any]:
    """Periksa DB SQLite (ekspor/DB uji) terhadap invarian SPEC. Hanya-baca."""
    con = sqlite3.connect(f"file:{db_path}?mode=ro", uri=True)
    findings = []
    try:
        for name, severity, sql in _CHECKS:
            try:
                rows = con.execute(sql).fetchall()
            except sqlite3.Error as e:  # tabel/kolom tidak ada
                findings.append({"check": name, "severity": "skipped", "detail": str(e)})
                continue
            findings.append({"check": name, "severity": severity if rows else "ok",
                             "count": len(rows), "sample": [r[0] for r in rows[:5]]})
    finally:
        con.close()
    bad = [f for f in findings if f["severity"] == "error"]
    return {"passed": not bad, "findings": findings,
            "note": "Tabel ledger append-only (tanpa UPDATE/DELETE) harus dijaga lewat trigger/RLS, "
                    "tidak bisa dibuktikan dari data saja."}
