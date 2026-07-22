import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/core/constant/enum.dart';
import 'package:kedai_ayam_nina/features/transactions/data/model/transaction_model.dart';

void main() {
  group('TransactionModel category compatibility', () {
    test('membaca kategori lama pengeluaran '
        'sebagai penjualanLangsung', () {
      final transaction = TransactionModel.fromJson({
        'id': 'legacy-transaction',
        'tanggal': '2026-07-22T00:00:00.000',
        'jenis': 'pemasukan',
        'kategori': 'pengeluaran',
        'nominal': 300000,
        'keterangan': 'Transaksi lama',
      });

      expect(transaction.kategori, KategoriTransaksi.penjualanLangsung);

      expect(transaction.kategori.label, 'Penjualan Langsung');
    });

    test('membaca kategori baru penjualanLangsung', () {
      final transaction = TransactionModel.fromJson({
        'id': 'new-transaction',
        'tanggal': '2026-07-22T00:00:00.000',
        'jenis': 'pemasukan',
        'kategori': 'penjualanLangsung',
        'nominal': 300000,
        'keterangan': 'Transaksi baru',
      });

      expect(transaction.kategori, KategoriTransaksi.penjualanLangsung);
    });

    test('menulis kategori baru sebagai '
        'penjualanLangsung', () {
      final transaction = TransactionModel(
        id: 'new-transaction',
        tanggal: DateTime(2026, 7, 22),
        jenis: JenisTransaksi.pemasukan,
        kategori: KategoriTransaksi.penjualanLangsung,
        nominal: 300000,
        keterangan: 'Transaksi baru',
      );

      final data = transaction.toFirestore();

      expect(data['kategori'], 'penjualanLangsung');

      expect(data['jenis'], 'pemasukan');
    });

    test('kategori tidak dikenal menjadi lainnya', () {
      final transaction = TransactionModel.fromJson({
        'id': 'unknown-category',
        'tanggal': '2026-07-22T00:00:00.000',
        'jenis': 'pengeluaran',
        'kategori': 'kategoriTidakDikenal',
        'nominal': 100000,
        'keterangan': 'Kategori tidak dikenal',
      });

      expect(transaction.kategori, KategoriTransaksi.lainnya);
    });
  });
}
