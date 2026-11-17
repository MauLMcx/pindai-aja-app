"""Jalankan: python -m unittest -v   (dari folder ini)

Tes impor memakai file nyata bila ada. Atur lokasinya dengan env PETSHOP_XLSX.
"""
import os
import sqlite3
import tempfile
import unittest
from pathlib import Path

import core

XLSX = os.environ.get("PETSHOP_XLSX", "/mnt/user-data/uploads/Data_Harga_Pakan.xlsx")


class TestEan13(unittest.TestCase):
    def test_known_valid_code(self):
        # 4006381333931 adalah contoh EAN-13 valid yang umum dipakai
        self.assertEqual(core.ean13_check_digit("400638133393"), 1)
        self.assertTrue(core.is_valid_ean13("4006381333931"))
        self.assertFalse(core.is_valid_ean13("4006381333932"))

    def test_internal_generation(self):
        code = core.gen_ean13_internal("07", 1)
        self.assertEqual(len(code), 13)
        self.assertTrue(code.startswith("207"))
        self.assertTrue(core.is_valid_ean13(code))
        self.assertNotEqual(code, core.gen_ean13_internal("07", 2))

    def test_bad_input(self):
        with self.assertRaises(ValueError):
            core.gen_ean13_internal("7", 1)
        with self.assertRaises(ValueError):
            core.gen_ean13_internal("07", 10**9)


class TestParseSize(unittest.TestCase):
    def test_cases(self):
        self.assertEqual(core.parse_size("800 gr"), (800, "gram", None))
        self.assertEqual(core.parse_size("1 kg"), (1000, "gram", None))
        self.assertEqual(core.parse_size("3 liter, isi 10"), (3000, "ml", 10))
        self.assertEqual(core.parse_size("5,5 liter, isi 5"), (5500, "ml", 5))
        self.assertEqual(core.parse_size("isi 6 pcs"), (None, None, 6))
        self.assertEqual(core.parse_size("Animax Hijau 10 kg"), (10000, "gram", None))
        self.assertEqual(core.parse_size(""), (None, None, None))


class TestReceipt(unittest.TestCase):
    DATA = {
        "store_name": "PETSHOP CONTOH", "address": "Jl. Contoh No. 1, Banjarbaru",
        "receipt_no": "A-20261117-0001", "datetime": "17/11/26 10:30", "cashier": "Budi",
        "items": [
            {"name": "Bolt Adult Tuna (ungu) 800 gr", "qty": 2, "unit_price": 48000, "discount": 2000, "line_total": 94000},
            {"name": "Pasir Markotop", "qty": 1, "unit_price": 20000, "line_total": 20000},
        ],
        "subtotal": 116000, "discount_total": 2000, "total": 114000,
        "payments": [{"method": "cash", "amount": 120000}], "change": 6000,
    }

    def test_width_never_exceeded(self):
        for width in (32, 48):
            text = core.receipt_preview(self.DATA, width)
            for line in text.splitlines():
                self.assertLessEqual(len(line), width, line)

    def test_contains_key_lines(self):
        text = core.receipt_preview(self.DATA, 32)
        self.assertIn("TOTAL", text)
        self.assertIn("114.000", text)
        self.assertIn("Kembali", text)

    def test_bad_width(self):
        with self.assertRaises(ValueError):
            core.receipt_preview(self.DATA, 20)


@unittest.skipUnless(Path(XLSX).exists(), "file Excel tidak ditemukan")
class TestImport(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.rep = core.import_excel(XLSX, cls.tmp.name)
        import csv
        with open(cls.rep["csv"], encoding="utf-8-sig") as f:
            cls.rows = list(csv.DictReader(f))

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def find(self, sheet, text):
        return [r for r in self.rows if r["source_sheet"] == sheet and text in r["name"]]

    def test_scale_thousands_vs_full(self):
        self.assertEqual(self.find("Bintang Petshop", "CC Adult")[0]["buy_price_idr"], "430000")
        self.assertEqual(self.find("Bintang J-Pock", "Cat Choize Adult Tuna")[0]["buy_price_idr"], "430000")
        self.assertEqual(self.find("Bintang 99 Sungai Ulin", "AT-2")[0]["buy_price_idr"], "230000")

    def test_empty_price_not_guessed(self):
        r = self.find("Bintang J-Pock", "Furlove All Stage Tuna")[0]
        self.assertEqual(r["buy_price_idr"], "")
        self.assertEqual(r["needs_price_review"], "True")

    def test_struck_row_skipped_replacement_kept(self):
        names = [r["name"] for r in self.rows]
        self.assertNotIn("Meo Ikan (dicoret)", names)
        self.assertIn("Meo Adult Ikan", names)

    def test_variant_split(self):
        r = self.find("Bintang J-Pock", "Bolt Adult Tuna")
        self.assertEqual({x["variant"] for x in r}, {"ungu", "kuning"})

    def test_unclear_flagged_and_cleaned(self):
        r = self.find("Bintang Petshop", "Aice Kelinci")[0]
        self.assertNotIn("kurang jelas", r["name"])
        self.assertEqual(r["needs_price_review"], "True")

    def test_old_price_kept(self):
        r = self.find("Bintang Petshop", "Lezato Adult")[0]
        self.assertEqual((r["old_price_idr"], r["buy_price_idr"]), ("410000", "420000"))

    def test_pack_rows_flagged(self):
        r = self.find("Bintang Petshop", "Tayo")
        self.assertTrue(all(x["needs_price_review"] == "True" for x in r))

    def test_no_footer_rows(self):
        self.assertFalse([r for r in self.rows if r["name"].startswith("Baris berwarna")])


class TestInvariants(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.db = str(Path(self.tmp.name) / "t.db")
        con = sqlite3.connect(self.db)
        con.executescript("""
        CREATE TABLE product_units(id TEXT, store_id TEXT, barcode TEXT, factor_to_base INT, deleted_at TEXT);
        CREATE TABLE sales(id TEXT, status TEXT, subtotal INT, discount_total INT, total INT, change_amount INT, deleted_at TEXT);
        CREATE TABLE sale_items(id TEXT, sale_id TEXT, unit_id TEXT, qty INT, qty_base INT, line_total INT, deleted_at TEXT);
        CREATE TABLE payments(id TEXT, sale_id TEXT, amount INT, deleted_at TEXT);
        CREATE TABLE stock_movements(id TEXT, product_id TEXT, qty_base_delta INT);
        INSERT INTO product_units VALUES('u1','s','111',10,NULL);
        INSERT INTO sales VALUES('s1','completed',100,10,90,10,NULL);
        INSERT INTO sale_items VALUES('i1','s1','u1',1,10,100,NULL);
        INSERT INTO payments VALUES('p1','s1',100,NULL);
        INSERT INTO stock_movements VALUES('m1','p1',-5);
        """)
        con.commit()
        con.close()

    def tearDown(self):
        self.tmp.cleanup()

    def test_clean_db_passes_with_stock_warning(self):
        r = core.check_invariants(self.db)
        self.assertTrue(r["passed"])
        neg = next(f for f in r["findings"] if f["check"] == "negative_stock")
        self.assertEqual(neg["severity"], "warning")

    def test_detects_broken_total(self):
        con = sqlite3.connect(self.db)
        con.execute("UPDATE sales SET total=999")
        con.commit()
        con.close()
        r = core.check_invariants(self.db)
        self.assertFalse(r["passed"])

    def test_detects_duplicate_barcode(self):
        con = sqlite3.connect(self.db)
        con.execute("INSERT INTO product_units VALUES('u2','s','111',1,NULL)")
        con.commit()
        con.close()
        r = core.check_invariants(self.db)
        dup = next(f for f in r["findings"] if f["check"] == "duplicate_barcode")
        self.assertEqual(dup["severity"], "error")


if __name__ == "__main__":
    unittest.main()
