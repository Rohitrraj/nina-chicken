import 'package:cloud_firestore/cloud_firestore.dart'
    show DocumentSnapshot, Timestamp;

import '../../../../core/constant/enum.dart';
import '../../domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  TransactionModel({
    required super.id,
    required super.tanggal,
    required super.jenis,
    required super.kategori,
    required super.nominal,
    required super.keterangan,
  });

  factory TransactionModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();

    if (data == null) {
      throw StateError('Data transaksi ${document.id} tidak ditemukan.');
    }

    return TransactionModel.fromMap(data, documentId: document.id);
  }

  factory TransactionModel.fromMap(
    Map<String, dynamic> data, {
    String? documentId,
  }) {
    return TransactionModel(
      id: documentId ?? data['id']?.toString() ?? '',
      tanggal: _parseDate(data['tanggal']),
      jenis: _parseJenis(data['jenis']),
      kategori: _parseKategori(data['kategori']),
      nominal: _parseNominal(data['nominal']),
      keterangan: data['keterangan']?.toString() ?? '',
    );
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel.fromMap(json);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'tanggal': Timestamp.fromDate(tanggal),
      'jenis': jenis.name,
      'kategori': kategori.name,
      'nominal': nominal,
      'keterangan': keterangan.trim(),
    };
  }

  Map<String, dynamic> toJson() {
    return {'id': id, ...toFirestore()};
  }

  factory TransactionModel.fromEntity(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      tanggal: transaction.tanggal,
      jenis: transaction.jenis,
      kategori: transaction.kategori,
      nominal: transaction.nominal,
      keterangan: transaction.keterangan,
    );
  }

  static JenisTransaksi _parseJenis(dynamic value) {
    final normalized = value?.toString().trim();

    return JenisTransaksi.values.firstWhere(
      (jenis) => jenis.name == normalized,
      orElse: () => JenisTransaksi.pengeluaran,
    );
  }

  static KategoriTransaksi _parseKategori(dynamic value) {
    final normalized = value?.toString().trim();

    // Kompatibilitas data lama:
    // "pengeluaran" dahulu digunakan untuk
    // kategori "Penjualan Langsung".
    if (normalized == 'pengeluaran') {
      return KategoriTransaksi.penjualanLangsung;
    }

    return KategoriTransaksi.values.firstWhere(
      (kategori) => kategori.name == normalized,
      orElse: () => KategoriTransaksi.lainnya,
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      final parsed = DateTime.tryParse(value.trim());

      if (parsed != null) {
        return parsed;
      }
    }

    if (value is num) {
      return DateTime.fromMillisecondsSinceEpoch(value.toInt());
    }

    throw const FormatException('Field tanggal transaksi tidak valid.');
  }

  static int _parseNominal(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
