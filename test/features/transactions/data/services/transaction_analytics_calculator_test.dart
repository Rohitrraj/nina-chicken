import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/core/constant/enum.dart';
import 'package:kedai_ayam_nina/features/transactions/data/model/transaction_model.dart';
import 'package:kedai_ayam_nina/features/transactions/data/services/transaction_analytics_calculator.dart';

void main() {
  const calculator = TransactionAnalyticsCalculator();

  TransactionModel createTransaction({
    required String id,
    required DateTime tanggal,
    required JenisTransaksi jenis,
    required int nominal,
    KategoriTransaksi kategori = KategoriTransaksi.lainnya,
    String keterangan = 'Test transaksi',
  }) {
    return TransactionModel(
      id: id,
      tanggal: tanggal,
      jenis: jenis,
      kategori: kategori,
      nominal: nominal,
      keterangan: keterangan,
    );
  }

  group('TransactionAnalyticsCalculator', () {
    test('menghitung total pemasukan, pengeluaran, '
        'profit, monthly data, dan growth', () {
      final result = calculator.calculate(
        year: 2026,
        transactions: [
          createTransaction(
            id: 'previous-income',
            tanggal: DateTime(2025, 1, 10),
            jenis: JenisTransaksi.pemasukan,
            nominal: 1000,
          ),
          createTransaction(
            id: 'previous-expense',
            tanggal: DateTime(2025, 1, 11),
            jenis: JenisTransaksi.pengeluaran,
            nominal: 400,
          ),
          createTransaction(
            id: 'current-income-january',
            tanggal: DateTime(2026, 1, 10),
            jenis: JenisTransaksi.pemasukan,
            nominal: 1000,
          ),
          createTransaction(
            id: 'current-income-february',
            tanggal: DateTime(2026, 2, 10),
            jenis: JenisTransaksi.pemasukan,
            nominal: 500,
          ),
          createTransaction(
            id: 'current-expense-january',
            tanggal: DateTime(2026, 1, 12),
            jenis: JenisTransaksi.pengeluaran,
            nominal: 500,
          ),
        ],
      );

      expect(result.year, 2026);

      expect(result.totalPemasukan, 1500);
      expect(result.totalPengeluaran, 500);
      expect(result.profitBersih, 1000);

      expect(result.pemasukanGrowth, 50.0);
      expect(result.pengeluaranGrowth, 25.0);
      expect(result.profitGrowth, 66.7);

      expect(result.monthlyData.length, 12);

      final january = result.monthlyData[0];
      final february = result.monthlyData[1];

      expect(january.month, 1);
      expect(january.pemasukan, 1000);
      expect(january.pengeluaran, 500);
      expect(january.profit, 500);

      expect(february.month, 2);
      expect(february.pemasukan, 500);
      expect(february.pengeluaran, 0);
      expect(february.profit, 500);
    });

    test('menghasilkan growth 100 persen ketika '
        'tahun sebelumnya nol dan tahun sekarang positif', () {
      final result = calculator.calculate(
        year: 2026,
        transactions: [
          createTransaction(
            id: 'income',
            tanggal: DateTime(2026, 3, 1),
            jenis: JenisTransaksi.pemasukan,
            nominal: 250000,
          ),
        ],
      );

      expect(result.totalPemasukan, 250000);
      expect(result.totalPengeluaran, 0);
      expect(result.profitBersih, 250000);

      expect(result.pemasukanGrowth, 100.0);
      expect(result.pengeluaranGrowth, 0.0);
      expect(result.profitGrowth, 100.0);
    });

    test('menghasilkan dua belas bulan bernilai nol '
        'ketika tidak ada transaksi', () {
      final result = calculator.calculate(year: 2026, transactions: const []);

      expect(result.totalPemasukan, 0);
      expect(result.totalPengeluaran, 0);
      expect(result.profitBersih, 0);

      expect(result.pemasukanGrowth, 0.0);
      expect(result.pengeluaranGrowth, 0.0);
      expect(result.profitGrowth, 0.0);

      expect(result.monthlyData.length, 12);

      for (final month in result.monthlyData) {
        expect(month.pemasukan, 0);
        expect(month.pengeluaran, 0);
        expect(month.profit, 0);
      }
    });

    test('mengabaikan transaksi di luar tahun target '
        'dan tahun sebelumnya', () {
      final result = calculator.calculate(
        year: 2026,
        transactions: [
          createTransaction(
            id: 'too-old',
            tanggal: DateTime(2024, 1, 1),
            jenis: JenisTransaksi.pemasukan,
            nominal: 999999,
          ),
          createTransaction(
            id: 'future',
            tanggal: DateTime(2027, 1, 1),
            jenis: JenisTransaksi.pemasukan,
            nominal: 888888,
          ),
        ],
      );

      expect(result.totalPemasukan, 0);
      expect(result.totalPengeluaran, 0);
      expect(result.profitBersih, 0);

      expect(result.pemasukanGrowth, 0.0);
      expect(result.pengeluaranGrowth, 0.0);
      expect(result.profitGrowth, 0.0);
    });

    test('menghitung profit negatif ketika '
        'pengeluaran lebih besar dari pemasukan', () {
      final result = calculator.calculate(
        year: 2026,
        transactions: [
          createTransaction(
            id: 'income',
            tanggal: DateTime(2026, 4, 1),
            jenis: JenisTransaksi.pemasukan,
            nominal: 100000,
          ),
          createTransaction(
            id: 'expense',
            tanggal: DateTime(2026, 4, 2),
            jenis: JenisTransaksi.pengeluaran,
            nominal: 150000,
          ),
        ],
      );

      expect(result.totalPemasukan, 100000);
      expect(result.totalPengeluaran, 150000);
      expect(result.profitBersih, -50000);

      final april = result.monthlyData[3];

      expect(april.month, 4);
      expect(april.pemasukan, 100000);
      expect(april.pengeluaran, 150000);
      expect(april.profit, -50000);
    });
  });
}
