import 'package:cloud_firestore/cloud_firestore.dart'
    show CollectionReference, FieldValue, FirebaseFirestore;

import '../model/annual_growth_model.dart';
import '../model/transaction_model.dart';
import '../services/transaction_analytics_calculator.dart';

abstract class TransactionFirestoreDatasource {
  Future<List<TransactionModel>> getTransactions();

  Future<TransactionModel> getTransaction(String id);

  Future<void> createTransaction(TransactionModel transaction);

  Future<void> updateTransaction(TransactionModel transaction);

  Future<void> deleteTransaction(String id);

  Future<AnnualGrowthModel> getAnnualGrowth(int year);
}

class TransactionFirestoreDatasourceImpl
    implements TransactionFirestoreDatasource {
  final FirebaseFirestore firestore;
  final TransactionAnalyticsCalculator analyticsCalculator;

  TransactionFirestoreDatasourceImpl({
    required this.firestore,
    this.analyticsCalculator = const TransactionAnalyticsCalculator(),
  });

  CollectionReference<Map<String, dynamic>> get _transactions {
    return firestore.collection('transactions');
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    try {
      final snapshot = await _transactions.get();

      final transactions = snapshot.docs
          .map(TransactionModel.fromFirestore)
          .toList();

      transactions.sort((first, second) {
        final dateComparison = second.tanggal.compareTo(first.tanggal);

        if (dateComparison != 0) {
          return dateComparison;
        }

        return second.id.compareTo(first.id);
      });

      return transactions;
    } catch (error) {
      throw Exception('Gagal memuat daftar transaksi: $error');
    }
  }

  @override
  Future<TransactionModel> getTransaction(String id) async {
    final normalizedId = id.trim();

    if (normalizedId.isEmpty) {
      throw ArgumentError('ID transaksi tidak boleh kosong.');
    }

    try {
      final snapshot = await _transactions.doc(normalizedId).get();

      if (!snapshot.exists) {
        throw StateError('Transaksi tidak ditemukan.');
      }

      return TransactionModel.fromFirestore(snapshot);
    } catch (error) {
      throw Exception('Gagal memuat transaksi: $error');
    }
  }

  @override
  Future<void> createTransaction(TransactionModel transaction) async {
    _validateTransaction(transaction);

    final data = transaction.toFirestore();

    data.addAll({
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    try {
      await _transactions.add(data);
    } catch (error) {
      throw Exception('Gagal menambahkan transaksi: $error');
    }
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    _validateTransaction(transaction);

    final normalizedId = transaction.id.trim();

    if (normalizedId.isEmpty) {
      throw const FormatException('ID transaksi tidak valid.');
    }

    final data = transaction.toFirestore();

    data['updatedAt'] = FieldValue.serverTimestamp();

    await _transactions.doc(normalizedId).update(data);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final normalizedId = id.trim();

    if (normalizedId.isEmpty) {
      throw ArgumentError('ID transaksi tidak boleh kosong.');
    }

    try {
      await _transactions.doc(normalizedId).delete();
    } catch (error) {
      throw Exception('Gagal menghapus transaksi: $error');
    }
  }

  @override
  Future<AnnualGrowthModel> getAnnualGrowth(int year) async {
    if (year < 2000 || year > 2101) {
      throw ArgumentError('Tahun analitik tidak valid.');
    }

    try {
      final transactions = await getTransactions();

      return analyticsCalculator.calculate(
        year: year,
        transactions: transactions,
      );
    } catch (error) {
      throw Exception(
        'Gagal memuat data pertumbuhan tahunan: '
        '$error',
      );
    }
  }

  void _validateTransaction(TransactionModel transaction) {
    if (transaction.nominal <= 0) {
      throw ArgumentError('Nominal transaksi harus lebih dari nol.');
    }

    if (transaction.keterangan.trim().isEmpty) {
      throw ArgumentError('Keterangan transaksi tidak boleh kosong.');
    }
  }
}
