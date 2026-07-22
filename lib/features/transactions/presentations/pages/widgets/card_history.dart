import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/utils/rupiah_formatter.dart';
import 'package:kedai_ayam_nina/core/widgets/card/card_gradient.dart';
import 'package:kedai_ayam_nina/core/widgets/chip/custom_chip.dart';
import 'package:kedai_ayam_nina/features/transactions/domain/entities/transaction.dart';
import 'package:kedai_ayam_nina/features/transactions/presentations/pages/widgets/card_history_item.dart';
import 'package:kedai_ayam_nina/core/widgets/main_scaffold_admin.dart';

class CardHistory extends StatelessWidget {
  final List<Transaction> transaction;
  const CardHistory({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        Card(
          elevation: 16,
          color: Theme.of(context).colorScheme.onSecondary,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 10,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Riwayat Transaksi",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextButton(
                      onPressed: () =>
                          AdminShellProvider.of(context).goBranch(0),
                      child: const Text("Lihat Semua"),
                    ),
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: transaction.length > 5 ? 5 : transaction.length,
                  itemBuilder: (context, index) => CardHistoryItem(
                    isPengeluaran:
                        transaction[index].jenis.name == 'pengeluaran',
                    tittle: transaction[index].kategori.label,
                    date:
                        "${transaction[index].tanggal.day.toString().padLeft(2, '0')}/${transaction[index].tanggal.month.toString().padLeft(2, '0')}/${transaction[index].tanggal.year}",
                    nominal: formatRupiah(transaction[index].nominal),
                  ),
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
                "Total Keuangan",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              Text(
                "Total 5 Transaksi Terakhir:",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              Row(
                children: [
                  CustomTrendChip(
                    text: formatNumber(
                      transaction
                          .take(transaction.length > 5 ? 5 : transaction.length)
                          .where(
                            (element) => element.jenis.name == 'pengeluaran',
                          )
                          .fold(
                            0,
                            (previousValue, element) =>
                                previousValue + element.nominal,
                          ),
                    ),
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
}
