part of 'transaction_list_cubit.dart';

sealed class TransactionListState extends Equatable {
  const TransactionListState();

  @override
  List<Object> get props => [];
}

final class TransactionListInitial extends TransactionListState {}

final class TransactionListLoading extends TransactionListState {}

final class TransactionListLoaded extends TransactionListState {
  final List<Transaction> transactions;

  const TransactionListLoaded({required this.transactions});

  @override
  List<Object> get props => [transactions];
}

final class TransactionListError extends TransactionListState {
  final String message;

  const TransactionListError({required this.message});

  @override
  List<Object> get props => [message];
}
