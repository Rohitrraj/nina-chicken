import 'package:flutter/material.dart';

class CardHistoryItem extends StatelessWidget {
  const CardHistoryItem({
    super.key,
    required this.isPengeluaran,
    required this.tittle,
    required this.date,
    required this.nominal,
    this.transactionId,
    this.onEdit,
    this.onDelete,
    this.isDeleting = false,
  });

  final bool isPengeluaran;
  final String tittle;
  final String date;
  final String nominal;

  final String? transactionId;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isDeleting;

  @override
  Widget build(BuildContext context) {
    final valueColor = isPengeluaran ? Colors.red : Colors.green;

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
                color: valueColor,
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
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 112),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  nominal,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: valueColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (onEdit != null)
              Tooltip(
                message: 'Edit transaksi',
                child: IconButton(
                  key: ValueKey<String>(
                    'transaction-edit-'
                    '${transactionId ?? tittle}',
                  ),
                  onPressed: isDeleting ? null : onEdit,
                  constraints: const BoxConstraints(
                    minWidth: 48,
                    minHeight: 48,
                  ),
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.edit_outlined, size: 20),
                ),
              ),
            if (onDelete != null)
              Tooltip(
                message: 'Hapus transaksi',
                child: IconButton(
                  key: ValueKey<String>(
                    'transaction-delete-'
                    '${transactionId ?? tittle}',
                  ),
                  onPressed: isDeleting ? null : onDelete,
                  constraints: const BoxConstraints(
                    minWidth: 48,
                    minHeight: 48,
                  ),
                  visualDensity: VisualDensity.compact,
                  color: Colors.red,
                  icon: isDeleting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.delete_outline, size: 20),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
