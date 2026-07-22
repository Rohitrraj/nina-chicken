import '../../../../core/constant/enum.dart';
import '../model/annual_growth_model.dart';
import '../model/transaction_model.dart';

class TransactionAnalyticsCalculator {
  const TransactionAnalyticsCalculator();

  AnnualGrowthModel calculate({
    required int year,
    required Iterable<TransactionModel> transactions,
  }) {
    final monthlyPemasukan = List<int>.filled(12, 0);
    final monthlyPengeluaran = List<int>.filled(12, 0);

    var previousPemasukan = 0;
    var previousPengeluaran = 0;

    for (final transaction in transactions) {
      final transactionYear = transaction.tanggal.year;

      if (transactionYear == year) {
        final monthIndex = transaction.tanggal.month - 1;

        if (transaction.jenis == JenisTransaksi.pemasukan) {
          monthlyPemasukan[monthIndex] += transaction.nominal;
        } else {
          monthlyPengeluaran[monthIndex] += transaction.nominal;
        }
      } else if (transactionYear == year - 1) {
        if (transaction.jenis == JenisTransaksi.pemasukan) {
          previousPemasukan += transaction.nominal;
        } else {
          previousPengeluaran += transaction.nominal;
        }
      }
    }

    final monthlyData = List.generate(12, (index) {
      final pemasukan = monthlyPemasukan[index];
      final pengeluaran = monthlyPengeluaran[index];

      return MonthlyData(
        month: index + 1,
        pemasukan: pemasukan,
        pengeluaran: pengeluaran,
        profit: pemasukan - pengeluaran,
      );
    });

    final totalPemasukan = monthlyPemasukan.fold<int>(
      0,
      (total, value) => total + value,
    );

    final totalPengeluaran = monthlyPengeluaran.fold<int>(
      0,
      (total, value) => total + value,
    );

    final profitBersih = totalPemasukan - totalPengeluaran;
    final previousProfit = previousPemasukan - previousPengeluaran;

    return AnnualGrowthModel(
      year: year,
      totalPemasukan: totalPemasukan,
      pemasukanGrowth: _calculateGrowth(previousPemasukan, totalPemasukan),
      totalPengeluaran: totalPengeluaran,
      pengeluaranGrowth: _calculateGrowth(
        previousPengeluaran,
        totalPengeluaran,
      ),
      profitBersih: profitBersih,
      profitGrowth: _calculateGrowth(previousProfit, profitBersih),
      monthlyData: monthlyData,
    );
  }

  double _calculateGrowth(int previousValue, int currentValue) {
    if (previousValue == 0) {
      return currentValue > 0 ? 100.0 : 0.0;
    }

    final growth = ((currentValue - previousValue) / previousValue.abs()) * 100;

    return double.parse(growth.toStringAsFixed(1));
  }
}
