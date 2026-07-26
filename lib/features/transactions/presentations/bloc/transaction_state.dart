part of 'transaction_bloc.dart';

enum TransactionOperation { create, update, delete, analytics }

sealed class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

final class TransactionInitial extends TransactionState {
  const TransactionInitial();
}

final class TransactionLoading extends TransactionState {
  const TransactionLoading({this.operation});

  final TransactionOperation? operation;

  @override
  List<Object> get props => [if (operation != null) operation!];
}

final class TransactionSuccess extends TransactionState {
  const TransactionSuccess({this.operation});

  final TransactionOperation? operation;

  @override
  List<Object> get props => [if (operation != null) operation!];
}

final class AnnualGrowthLoaded extends TransactionState {
  const AnnualGrowthLoaded({required this.annualGrowth});

  final AnnualGrowth annualGrowth;

  @override
  List<Object> get props => [annualGrowth];
}

final class TransactionError extends TransactionState {
  const TransactionError({required this.message, this.operation});

  final String message;
  final TransactionOperation? operation;

  @override
  List<Object> get props => [message, if (operation != null) operation!];
}
