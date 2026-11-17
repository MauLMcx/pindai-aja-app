"""Server MCP lokal `petshop-dev` (stdio).

STATUS: logika inti di core.py SUDAH dites (python -m unittest).
Pembungkus MCP ini memakai API mcp 2.x (MCPServer, sebelumnya FastMCP).
Jalankan langkah uji di SETUP-MCP.md untuk memastikan klien MCP tersambung.

Keamanan: semua path dibatasi ke folder proyek (PETSHOP_ROOT, default = cwd).
"""
from __future__ import annotations

import json
import os
from pathlib import Path
from typing import Any

from mcp.server.mcpserver import MCPServer

import core

ROOT = Path(os.environ.get("PETSHOP_ROOT", os.getcwd())).resolve()
mcp = MCPServer("petshop-dev")


def _safe(p: str) -> Path:
    path = Path(p)
    path = (path if path.is_absolute() else ROOT / path).resolve()
    if path != ROOT and ROOT not in path.parents:
        raise ValueError(f"path di luar folder proyek ditolak: {p}")
    return path


@mcp.tool()
def import_excel(xlsx_path: str, out_dir: str = "tools/out", scales_json: str | None = None) -> dict[str, Any]:
    """Normalisasi Data_Harga_Pakan.xlsx menjadi products_import.csv + import_report.json.

    scales_json opsional, contoh: '{"Multifeed": 1000}' untuk menimpa skala harga per sheet.
    Harga kosong tidak ditebak, baris bermasalah diberi needs_price_review.
    """
    scales = json.loads(scales_json) if scales_json else None
    return core.import_excel(str(_safe(xlsx_path)), str(_safe(out_dir)), scales)


@mcp.tool()
def check_invariants(db_path: str) -> dict[str, Any]:
    """Periksa database SQLite (hanya-baca) terhadap invarian SPEC: total, pembayaran, satuan, barcode ganda, stok minus."""
    return core.check_invariants(str(_safe(db_path)))


@mcp.tool()
def gen_ean13_internal(store_code2: str, seq: int) -> str:
    """Buat barcode EAN-13 internal toko (awalan 2) dengan digit cek yang benar."""
    return core.gen_ean13_internal(store_code2, seq)


@mcp.tool()
def receipt_preview(receipt: dict[str, Any], width: int = 32) -> str:
    """Pratinjau teks struk. width 32 = kertas 58 mm, 48 = kertas 80 mm."""
    return core.receipt_preview(receipt, width)


if __name__ == "__main__":
    mcp.run()  # stdio
