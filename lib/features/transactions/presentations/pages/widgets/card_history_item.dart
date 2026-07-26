import 'package:flutter/material.dart';

class CardHistoryItem extends StatelessWidget {
  const CardHistoryItem({
    super.key,
    required this.isPengeluaran,
    required this.tittle,
    required this.date,
    required this.nominal,
  });

  final bool isPengeluaran;
  final String tittle;
  final String date;
  final String nominal;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(
                context,
              ).colorScheme.primary.withAlpha(128),
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              child: Icon(
                isPengeluaran ? Icons.arrow_upward : Icons.arrow_downward,
                color: isPengeluaran ? Colors.red : Colors.green,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tittle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(date, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            Text(
              nominal,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isPengeluaran ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
