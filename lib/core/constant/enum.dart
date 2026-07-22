enum KategoriTransaksi {
  penjualanLangsung("Penjualan Langsung"),
  bahanbaku("Bahan Baku"),
  operasional("Operasional"),
  pesananKatering("Pesanan Katering"),
  lainnya("Lainnya"),
  bumbu("Bumbu & Rempah");

  const KategoriTransaksi(this.label);
  final String label;
}

enum JenisTransaksi {
  pemasukan("Pemasukan"),
  pengeluaran("Pengeluaran");

  const JenisTransaksi(this.label);
  final String label;
}

enum SnackBarState { success, error, info }
