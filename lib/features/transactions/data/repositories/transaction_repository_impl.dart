import '../../domain/entities/annual_growth.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasource/transaction_firestore_datasource.dart';
import '../model/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionFirestoreDatasource firestoreDatasource;

  TransactionRepositoryImpl({required this.firestoreDatasource});

  @override
  Future<List<Transaction>> getTransactions() {
    return firestoreDatasource.getTransactions();
  }

  @override
  Future<Transaction> getTransaction(String id) {
    return firestoreDatasource.getTransaction(id);
  }

  @override
  Future<void> createTransaction(Transaction transaction) {
    return firestoreDatasource.createTransaction(
      TransactionModel.fromEntity(transaction),
    );
  }

  @override
  Future<void> updateTransaction(Transaction transaction) {
    return firestoreDatasource.updateTransaction(
      TransactionModel.fromEntity(transaction),
    );
  }

  @override
  Future<void> deleteTransaction(String id) {
    return firestoreDatasource.deleteTransaction(id);
  }

  @override
  Future<AnnualGrowth> getAnnualGrowth(int year) {
    return firestoreDatasource.getAnnualGrowth(year);
  }
}
