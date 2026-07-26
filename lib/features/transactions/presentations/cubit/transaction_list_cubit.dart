import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kedai_ayam_nina/features/transactions/domain/entities/transaction.dart';
import 'package:kedai_ayam_nina/features/transactions/domain/usecases/get_transactions.dart';

part 'transaction_list_state.dart';

class TransactionListCubit extends Cubit<TransactionListState> {
  TransactionListCubit(this.getTransactions) : super(TransactionListInitial());

  final GetTransactions getTransactions;

  Future<void> fetchTransactions() async {
    emit(TransactionListLoading());

    try {
      final transactions = await getTransactions.execute();

      emit(TransactionListLoaded(transactions: transactions));
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('[TransactionListCubit][fetchTransactions] $error');
        debugPrintStack(stackTrace: stackTrace);
      }

      emit(
        const TransactionListError(
          message:
              'Riwayat transaksi belum dapat dimuat. '
              'Periksa koneksi lalu coba kembali.',
        ),
      );
    }
  }
}
