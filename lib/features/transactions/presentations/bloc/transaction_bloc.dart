import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kedai_ayam_nina/features/transactions/domain/entities/annual_growth.dart';
import 'package:kedai_ayam_nina/features/transactions/domain/entities/transaction.dart';
import 'package:kedai_ayam_nina/features/transactions/domain/usecases/create_transaction.dart';
import 'package:kedai_ayam_nina/features/transactions/domain/usecases/delete_transaction.dart';
import 'package:kedai_ayam_nina/features/transactions/domain/usecases/get_annual_growth.dart';
import 'package:kedai_ayam_nina/features/transactions/domain/usecases/update_transaction.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc({
    required this.createTransaction,
    required this.deleteTransaction,
    required this.getAnnualGrowth,
    required this.updateTransaction,
  }) : super(const TransactionInitial()) {
    on<CreateTransactionEvent>(_onCreateTransaction);
    on<DeleteTransactionEvent>(_onDeleteTransaction);
    on<GetAnnualGrowthEvent>(_onGetAnnualGrowth);
    on<UpdateTransactionEvent>(_onUpdateTransaction);
  }

  final CreateTransaction createTransaction;
  final DeleteTransaction deleteTransaction;
  final GetAnnualGrowth getAnnualGrowth;
  final UpdateTransaction updateTransaction;

  Future<void> _onCreateTransaction(
    CreateTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    await _runMutation(
      operation: TransactionOperation.create,
      action: () => createTransaction.execute(event.transaction),
      emit: emit,
    );
  }

  Future<void> _onDeleteTransaction(
    DeleteTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    await _runMutation(
      operation: TransactionOperation.delete,
      action: () => deleteTransaction.execute(event.id),
      emit: emit,
    );
  }

  Future<void> _onUpdateTransaction(
    UpdateTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    await _runMutation(
      operation: TransactionOperation.update,
      action: () => updateTransaction.execute(event.transaction),
      emit: emit,
    );
  }

  Future<void> _onGetAnnualGrowth(
    GetAnnualGrowthEvent event,
    Emitter<TransactionState> emit,
  ) async {
    const operation = TransactionOperation.analytics;

    emit(const TransactionLoading(operation: operation));

    try {
      final result = await getAnnualGrowth.execute(event.year);

      emit(AnnualGrowthLoaded(annualGrowth: result));
    } catch (error, stackTrace) {
      _logError(operation, error, stackTrace);

      emit(
        const TransactionError(
          operation: operation,
          message:
              'Data analitik belum dapat dimuat. '
              'Silakan coba kembali.',
        ),
      );
    }
  }

  Future<void> _runMutation({
    required TransactionOperation operation,
    required Future<void> Function() action,
    required Emitter<TransactionState> emit,
  }) async {
    emit(TransactionLoading(operation: operation));

    try {
      await action();

      emit(TransactionSuccess(operation: operation));
    } catch (error, stackTrace) {
      _logError(operation, error, stackTrace);

      emit(
        TransactionError(
          operation: operation,
          message: _safeMessage(operation),
        ),
      );
    }
  }

  String _safeMessage(TransactionOperation operation) {
    return switch (operation) {
      TransactionOperation.create =>
        'Transaksi belum dapat disimpan. '
            'Periksa data lalu coba kembali.',
      TransactionOperation.update =>
        'Perubahan transaksi belum dapat disimpan. '
            'Silakan coba kembali.',
      TransactionOperation.delete =>
        'Transaksi belum dapat dihapus. '
            'Silakan coba kembali.',
      TransactionOperation.analytics =>
        'Data analitik belum dapat dimuat. '
            'Silakan coba kembali.',
    };
  }

  void _logError(
    TransactionOperation operation,
    Object error,
    StackTrace stackTrace,
  ) {
    if (!kDebugMode) {
      return;
    }

    debugPrint('[TransactionBloc][${operation.name}] $error');
    debugPrintStack(stackTrace: stackTrace);
  }
}
