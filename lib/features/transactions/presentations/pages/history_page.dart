import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kedai_ayam_nina/core/constant/enum.dart';
import 'package:kedai_ayam_nina/core/utils/rupiah_formatter.dart';
import 'package:kedai_ayam_nina/features/transactions/domain/entities/transaction.dart';
import 'package:kedai_ayam_nina/features/transactions/presentations/bloc/transaction_bloc.dart';
import 'package:kedai_ayam_nina/features/transactions/presentations/cubit/transaction_list_cubit.dart';
import 'package:kedai_ayam_nina/features/transactions/presentations/pages/widgets/card_history_item.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String? _pendingDeleteId;

  @override
  void initState() {
    super.initState();

    context.read<TransactionListCubit>().fetchTransactions();
  }

  void _showMessage(String message, {required bool isError}) {
    final messenger = ScaffoldMessenger.of(context);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError
              ? Colors.red.shade700
              : const Color(0xFF2E7D32),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF0),
      body: BlocListener<TransactionBloc, TransactionState>(
        listenWhen: (previous, current) {
          if (current is TransactionSuccess) {
            return current.operation == TransactionOperation.delete;
          }

          if (current is TransactionError) {
            return current.operation == TransactionOperation.delete;
          }

          return false;
        },
        listener: (context, state) {
          if (mounted) {
            setState(() {
              _pendingDeleteId = null;
            });
          }

          if (state is TransactionSuccess) {
            _showMessage('Transaksi berhasil dihapus.', isError: false);
          }

          if (state is TransactionError) {
            _showMessage(state.message, isError: true);
          }

          context.read<TransactionListCubit>().fetchTransactions();
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<TransactionListCubit, TransactionListState>(
            builder: (context, state) {
              if (state is TransactionListLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is TransactionListError) {
                return _buildErrorState(context, state.message);
              }

              if (state is TransactionListLoaded) {
                if (state.transactions.isEmpty) {
                  return _buildEmptyState(context);
                }

                return _buildTransactionList(context, state.transactions);
              }

              return _buildEmptyState(context);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Belum ada transaksi',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Mulai tambahkan transaksi '
            'untuk melihat riwayat',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
          const SizedBox(height: 16),
          Text(
            'Riwayat belum dapat dimuat',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            key: const Key('transaction-history-retry'),
            onPressed: () {
              context.read<TransactionListCubit>().fetchTransactions();
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(
    BuildContext context,
    List<Transaction> transactions,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade600, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Geser kiri untuk hapus • '
                  'Ketuk untuk edit transaksi',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Semantics(
                button: true,
                label: 'Muat ulang riwayat transaksi',
                child: Tooltip(
                  message: 'Muat ulang',
                  child: IconButton(
                    key: const Key('transaction-history-refresh'),
                    onPressed: () {
                      context.read<TransactionListCubit>().fetchTransactions();
                    },
                    constraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 48,
                    ),
                    icon: Icon(
                      Icons.refresh_rounded,
                      color: Colors.blue.shade700,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];

              final isDeleting = _pendingDeleteId == transaction.id;

              return Dismissible(
                key: ValueKey<String>(transaction.id),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) async {
                  await _confirmAndDelete(context, transaction);

                  return false;
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: isDeleting
                            ? null
                            : () {
                                _showEditDialog(context, transaction);
                              },
                        child: CardHistoryItem(
                          isPengeluaran:
                              transaction.jenis == JenisTransaksi.pengeluaran,
                          tittle: transaction.kategori.label,
                          date: _formatDate(transaction.tanggal),
                          nominal: formatRupiah(transaction.nominal),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Tooltip(
                            message: 'Edit transaksi',
                            child: IconButton(
                              key: ValueKey<String>(
                                'transaction-edit-'
                                '${transaction.id}',
                              ),
                              onPressed: isDeleting
                                  ? null
                                  : () {
                                      _showEditDialog(context, transaction);
                                    },
                              constraints: const BoxConstraints(
                                minWidth: 48,
                                minHeight: 48,
                              ),
                              icon: const Icon(Icons.edit_outlined),
                            ),
                          ),
                          Tooltip(
                            message: 'Hapus transaksi',
                            child: IconButton(
                              key: ValueKey<String>(
                                'transaction-delete-'
                                '${transaction.id}',
                              ),
                              onPressed: isDeleting
                                  ? null
                                  : () {
                                      _confirmAndDelete(context, transaction);
                                    },
                              constraints: const BoxConstraints(
                                minWidth: 48,
                                minHeight: 48,
                              ),
                              color: Colors.red,
                              icon: isDeleting
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.delete_outline),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _confirmAndDelete(
    BuildContext context,
    Transaction transaction,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFDFBF0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Hapus transaksi?'),
          content: Text(
            'Transaksi '
            '${transaction.kategori.label} '
            'senilai '
            '${formatRupiah(transaction.nominal)} '
            'akan dihapus permanen.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Batal'),
            ),
            FilledButton(
              key: const Key('transaction-delete-confirm'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red.shade700,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    setState(() {
      _pendingDeleteId = transaction.id;
    });

    context.read<TransactionBloc>().add(
      DeleteTransactionEvent(id: transaction.id),
    );
  }

  Future<void> _showEditDialog(
    BuildContext context,
    Transaction transaction,
  ) async {
    final transactionBloc = context.read<TransactionBloc>();

    final updated = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: transactionBloc,
          child: _EditTransactionDialog(transaction: transaction),
        );
      },
    );

    if (updated == true && mounted) {
      context.read<TransactionListCubit>().fetchTransactions();

      _showMessage('Transaksi berhasil diperbarui.', isError: false);
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }
}

class _EditTransactionDialog extends StatefulWidget {
  const _EditTransactionDialog({required this.transaction});

  final Transaction transaction;

  @override
  State<_EditTransactionDialog> createState() => _EditTransactionDialogState();
}

class _EditTransactionDialogState extends State<_EditTransactionDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _dateController;

  late final TextEditingController _nominalController;

  late final TextEditingController _descriptionController;

  late DateTime _selectedDate;
  late JenisTransaksi _selectedType;
  late KategoriTransaksi _selectedCategory;

  String? _safeError;

  @override
  void initState() {
    super.initState();

    _selectedDate = widget.transaction.tanggal;

    _selectedType = widget.transaction.jenis;

    _selectedCategory = widget.transaction.kategori;

    _dateController = TextEditingController(text: _formatDate(_selectedDate));

    _nominalController = TextEditingController(
      text: widget.transaction.nominal.toString(),
    );

    _descriptionController = TextEditingController(
      text: widget.transaction.keterangan,
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    _nominalController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionBloc, TransactionState>(
      listenWhen: (previous, current) {
        if (current is TransactionSuccess) {
          return current.operation == TransactionOperation.update;
        }

        if (current is TransactionError) {
          return current.operation == TransactionOperation.update;
        }

        return false;
      },
      listener: (context, state) {
        if (state is TransactionSuccess) {
          Navigator.of(context).pop(true);
        }

        if (state is TransactionError) {
          setState(() {
            _safeError = state.message;
          });
        }
      },
      builder: (context, state) {
        final isSaving =
            state is TransactionLoading &&
            state.operation == TransactionOperation.update;

        return AlertDialog(
          backgroundColor: const Color(0xFFFDFBF0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B4513).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.edit_rounded, color: Color(0xFF8B4513)),
              ),
              const SizedBox(width: 12),
              const Text(
                'Edit Transaksi',
                style: TextStyle(
                  color: Color(0xFF8B4513),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Tanggal'),
                    const SizedBox(height: 6),
                    TextFormField(
                      key: const Key('transaction-edit-date'),
                      controller: _dateController,
                      enabled: !isSaving,
                      readOnly: true,
                      onTap: _pickDate,
                      decoration: _fieldDecoration(
                        prefixIcon: Icons.calendar_today,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _fieldLabel('Jenis Transaksi'),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<JenisTransaksi>(
                      initialValue: _selectedType,
                      isExpanded: true,
                      decoration: _fieldDecoration(),
                      items: JenisTransaksi.values
                          .map(
                            (item) => DropdownMenuItem<JenisTransaksi>(
                              value: item,
                              child: Text(item.label),
                            ),
                          )
                          .toList(),
                      onChanged: isSaving
                          ? null
                          : (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedType = value;
                                });
                              }
                            },
                    ),
                    const SizedBox(height: 16),
                    _fieldLabel('Kategori'),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<KategoriTransaksi>(
                      initialValue: _selectedCategory,
                      isExpanded: true,
                      decoration: _fieldDecoration(),
                      items: KategoriTransaksi.values
                          .map(
                            (item) => DropdownMenuItem<KategoriTransaksi>(
                              value: item,
                              child: Text(item.label),
                            ),
                          )
                          .toList(),
                      onChanged: isSaving
                          ? null
                          : (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedCategory = value;
                                });
                              }
                            },
                    ),
                    const SizedBox(height: 16),
                    _fieldLabel('Nominal (Rp)'),
                    const SizedBox(height: 6),
                    TextFormField(
                      key: const Key('transaction-edit-nominal'),
                      controller: _nominalController,
                      enabled: !isSaving,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        final nominal = int.tryParse(value?.trim() ?? '');

                        if (nominal == null || nominal <= 0) {
                          return 'Nominal harus '
                              'lebih dari Rp 0.';
                        }

                        return null;
                      },
                      decoration: _fieldDecoration(prefixText: 'Rp '),
                    ),
                    const SizedBox(height: 16),
                    _fieldLabel('Keterangan'),
                    const SizedBox(height: 6),
                    TextFormField(
                      key: const Key('transaction-edit-description'),
                      controller: _descriptionController,
                      enabled: !isSaving,
                      minLines: 2,
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Keterangan '
                              'wajib diisi.';
                        }

                        return null;
                      },
                      decoration: _fieldDecoration(
                        hintText: 'Catatan tambahan...',
                      ),
                    ),
                    if (_safeError != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _safeError!,
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: isSaving
                  ? null
                  : () {
                      Navigator.of(context).pop(false);
                    },
              child: Text(
                'Batal',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton(
              key: const Key('transaction-edit-save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B4513),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              onPressed: isSaving ? null : _submit,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSaving)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  else
                    const Icon(Icons.save_rounded, size: 16),
                  const SizedBox(width: 8),
                  Text(isSaving ? 'Menyimpan...' : 'Simpan'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked == null || !mounted) {
      return;
    }

    setState(() {
      _selectedDate = picked;
      _dateController.text = _formatDate(picked);
    });
  }

  void _submit() {
    FocusScope.of(context).unfocus();

    final valid = _formKey.currentState?.validate() ?? false;

    if (!valid) {
      return;
    }

    setState(() {
      _safeError = null;
    });

    context.read<TransactionBloc>().add(
      UpdateTransactionEvent(
        transaction: Transaction(
          id: widget.transaction.id,
          tanggal: _selectedDate,
          jenis: _selectedType,
          kategori: _selectedCategory,
          nominal: int.parse(_nominalController.text.trim()),
          keterangan: _descriptionController.text.trim(),
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 13,
        color: Colors.grey,
      ),
    );
  }

  InputDecoration _fieldDecoration({
    IconData? prefixIcon,
    String? prefixText,
    String? hintText,
  }) {
    return InputDecoration(
      prefixIcon: prefixIcon == null
          ? null
          : Icon(prefixIcon, color: const Color(0xFF8B4513)),
      prefixText: prefixText,
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF8B4513)),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }
}
