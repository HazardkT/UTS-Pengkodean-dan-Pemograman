-- 1. Membuat Fungsi Trigger untuk Pencegahan
CREATE OR REPLACE FUNCTION prevent_modify_posted_voucher()
RETURNS TRIGGER AS $$ BEGIN -- Memeriksa jika ada percobaan UPDATE atau DELETE IF (TG_OP = 'UPDATE' OR TG_OP = 'DELETE') THEN -- Mencegah aksi jika status data lama adalah 'POSTED' IF OLD.status = 'POSTED' THEN RAISE EXCEPTION 'Pelanggaran Jejak Audit: Transaksi dengan status POSTED tidak dapat diubah atau dihapus. Sistem mensyaratkan Jurnal Pembalik (Storno).'; END IF; END IF;  RETURN NEW; END; $$ LANGUAGE plpgsql;

-- 2. Memasang Trigger pada Tabel `vouchers`
CREATE TRIGGER trigger_lock_posted_vouchers
BEFORE UPDATE OR DELETE ON vouchers
FOR EACH ROW
EXECUTE FUNCTION prevent_modify_posted_voucher();
