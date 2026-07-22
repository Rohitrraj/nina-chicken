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
  @override
  void initState() {
    context.read<TransactionListCubit>().fetchTransactions();
    super.initState();
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Buku Kas",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const SizedBox(height: 4),
                      const Text("Kelola arus kas harian Kedai Ayam Nina"),
                    ],
                  ),
                  IconButton.filled(
                    onPressed: () => context
                        .read<TransactionListCubit>()
                        .fetchTransactions(),
                    icon: const Icon(Icons.refresh_rounded),
                    tooltip: "Muat ulang riwayat",
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFF8B4513),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocConsumer<TransactionBloc, TransactionState>(
                  listener: (context, state) {
                    if (state is TransactionSuccess) {
                      context.read<TransactionListCubit>().fetchTransactions();
                    }
                  },
                  builder: (context, state) {
                    if (state is TransactionLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final isSmallScreen =
                        MediaQuery.of(context).size.width < 800;

                    final cardTransactionWidget = CardTransaction(
                      onSubmit: (Transaction input) {
                        context.read<TransactionBloc>().add(
                          CreateTransactionEvent(transaction: input),
                        );
                      },
                    );

                    final listCubitWidget =
                        BlocConsumer<
                          TransactionListCubit,
                          TransactionListState
                        >(
                          builder: (context, state) {
                            if (state is TransactionListLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (state is TransactionListError) {
                              return Center(child: Text(state.message));
                            }
                            if (state is TransactionListLoaded) {
                              if (state.transactions.isEmpty) {
                                return const Center(child: Text("No Data"));
                              }
                              return CardHistory(
                                transaction: state.transactions,
                              );
                            }
                            return const Center(child: Text("No Data"));
                          },
                          listener: (context, state) {},
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
