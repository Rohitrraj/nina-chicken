import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/constant/enum.dart';
import 'package:kedai_ayam_nina/core/utils/rupiah_formatter.dart';
import 'package:kedai_ayam_nina/core/widgets/card/card_gradient.dart';
import 'package:kedai_ayam_nina/core/widgets/chip/custom_chip.dart';
import 'package:kedai_ayam_nina/core/widgets/main_scaffold_admin.dart';
import 'package:kedai_ayam_nina/features/transactions/domain/entities/transaction.dart';
import 'package:kedai_ayam_nina/features/transactions/presentations/pages/widgets/card_history_item.dart';

class CardHistory extends StatelessWidget {
  const CardHistory({super.key, required this.transaction});

  final List<Transaction> transaction;

  @override
  Widget build(BuildContext context) {
    final recentTransactions = transaction.take(5).toList();

    final totalRecentExpenses = recentTransactions
        .where((item) => item.jenis == JenisTransaksi.pengeluaran)
        .fold<int>(0, (total, item) => total + item.nominal);

    return Column(
      spacing: 10,
      children: [
        Card(
          elevation: 16,
          color: Theme.of(context).colorScheme.onSecondary,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              spacing: 10,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Riwayat Transaksi',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextButton(
                      onPressed: () {
                        AdminShellProvider.of(context).goBranch(0);
                      },
                      child: const Text('Lihat Semua'),
                    ),
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentTransactions.length,
                  itemBuilder: (context, index) {
                    final item = recentTransactions[index];

                    return CardHistoryItem(
                      isPengeluaran: item.jenis == JenisTransaksi.pengeluaran,
                      tittle: item.kategori.label,
                      date: _formatDate(item.tanggal),
                      nominal: formatRupiah(item.nominal),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        CardGradient(
          backgroundIcon: Icons.account_balance_wallet,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Total Pengeluaran',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              Text(
                'Dari maksimal 5 transaksi terakhir:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              Row(
                children: [
                  CustomTrendChip(
                    text: formatNumber(totalRecentExpenses),
                    icon: Icons.trending_up,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }
}
