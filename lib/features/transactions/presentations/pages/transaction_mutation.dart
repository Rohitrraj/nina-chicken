import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kedai_ayam_nina/features/transactions/domain/entities/transaction.dart';
import 'package:kedai_ayam_nina/features/transactions/presentations/bloc/transaction_bloc.dart';
import 'package:kedai_ayam_nina/features/transactions/presentations/cubit/transaction_list_cubit.dart';
import 'package:kedai_ayam_nina/features/transactions/presentations/pages/widgets/card_history.dart';
import 'package:kedai_ayam_nina/features/transactions/presentations/pages/widgets/card_transaction.dart';

class TransactionMutation extends StatefulWidget {
  const TransactionMutation({super.key});

  @override
  State<TransactionMutation> createState() => _TransactionMutationState();
}

class _TransactionMutationState extends State<TransactionMutation> {
  int _formResetToken = 0;

  @override
  void initState() {
    context.read<TransactionListCubit>().fetchTransactions();

    super.initState();
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
              : Colors.green.shade700,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Buku Kas',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Kelola arus kas harian '
                          'Kedai Ayam Nina',
                        ),
                      ],
                    ),
                  ),
                  Semantics(
                    button: true,
                    label: 'Muat ulang riwayat transaksi',
                    child: Tooltip(
                      message: 'Muat ulang riwayat',
                      child: IconButton.filled(
                        key: const Key('transaction-mutation-refresh'),
                        onPressed: () {
                          context
                              .read<TransactionListCubit>()
                              .fetchTransactions();
                        },
                        constraints: const BoxConstraints(
                          minWidth: 48,
                          minHeight: 48,
                        ),
                        icon: const Icon(Icons.refresh_rounded),
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFF8B4513),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: BlocConsumer<TransactionBloc, TransactionState>(
                  listenWhen: (previous, current) {
                    if (current is TransactionSuccess) {
                      return current.operation == TransactionOperation.create;
                    }

                    if (current is TransactionError) {
                      return current.operation == TransactionOperation.create;
                    }

                    return false;
                  },
                  listener: (context, state) {
                    if (state is TransactionSuccess) {
                      setState(() {
                        _formResetToken++;
                      });

                      context.read<TransactionListCubit>().fetchTransactions();

                      _showMessage(
                        'Transaksi berhasil '
                        'disimpan.',
                        isError: false,
                      );
                    }

                    if (state is TransactionError) {
                      _showMessage(state.message, isError: true);
                    }
                  },
                  builder: (context, state) {
                    final isCreating =
                        state is TransactionLoading &&
                        state.operation == TransactionOperation.create;

                    final isSmallScreen =
                        MediaQuery.of(context).size.width < 800;

                    final cardTransactionWidget = CardTransaction(
                      key: ValueKey<String>(
                        'transaction-create-form-'
                        '$_formResetToken',
                      ),
                      isLoading: isCreating,
                      resetToken: _formResetToken,
                      onSubmit: (Transaction input) {
                        context.read<TransactionBloc>().add(
                          CreateTransactionEvent(transaction: input),
                        );
                      },
                    );

                    final listCubitWidget =
                        BlocBuilder<TransactionListCubit, TransactionListState>(
                          builder: (context, state) {
                            if (state is TransactionListLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (state is TransactionListError) {
                              return Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      state.message,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    OutlinedButton.icon(
                                      key: const Key(
                                        'transaction-'
                                        'mutation-retry',
                                      ),
                                      onPressed: () {
                                        context
                                            .read<TransactionListCubit>()
                                            .fetchTransactions();
                                      },
                                      icon: const Icon(Icons.refresh_rounded),
                                      label: const Text('Coba Lagi'),
                                    ),
                                  ],
                                ),
                              );
                            }

                            if (state is TransactionListLoaded) {
                              if (state.transactions.isEmpty) {
                                return const Center(
                                  child: Text('Belum ada transaksi'),
                                );
                              }

                              return CardHistory(
                                transaction: state.transactions,
                              );
                            }

                            return const Center(
                              child: Text('Belum ada transaksi'),
                            );
                          },
                        );

                    if (isSmallScreen) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          cardTransactionWidget,
                          const SizedBox(height: 16),
                          listCubitWidget,
                        ],
                      );
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        Expanded(child: cardTransactionWidget),
                        Expanded(child: listCubitWidget),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
