import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:receipts_repository/src/entities/receipt_entity.dart' as entity;

class MedicinPurchase {
  final String id; // ← novo campo
  final int quantityPurchased;
  final String name;
  final String observations;
  final bool isAdministered;

  MedicinPurchase({
    required this.id,
    required this.quantityPurchased,
    required this.name,
    required this.observations,
    this.isAdministered = false,
  });

  entity.MedicinPurchaseEntity toEntity() => entity.MedicinPurchaseEntity(
    id: id, // ← propaga
    quantityPurchased: quantityPurchased,
    name: name,
    observations: observations,
    isAdministered: isAdministered,
  );

  static MedicinPurchase fromEntity(entity.MedicinPurchaseEntity ent) {
    return MedicinPurchase(
      id: ent.id, // ← recupera
      quantityPurchased: ent.quantityPurchased,
      name: ent.name,
      observations: ent.observations,
      isAdministered: ent.isAdministered,
    );
  }
}

class Receipt {
  String id;
  String receiptNumber;
  DateTime emittedDate;
  DateTime expireDate;
  List<MedicinPurchase> medications;

  Receipt({
    required this.id,
    required this.receiptNumber,
    required this.emittedDate,
    required this.expireDate,
    required this.medications,
  });

  entity.ReceiptEntity toEntity() {
    // Função auxiliar para normalizar para 01:00:00 local e converter para UTC
    Timestamp _normalizeDate(DateTime date) {
      final normalized = DateTime(date.year, date.month, date.day, 1); // 01:00
      return Timestamp.fromDate(normalized.toUtc());
    }

    return entity.ReceiptEntity(
      id: id,
      receiptNumber: receiptNumber,
      emittedDate: _normalizeDate(emittedDate),
      expireDate: _normalizeDate(expireDate),
      medications: medications.map((m) => m.toEntity()).toList(),
    );
  }

  static Receipt fromEntity(entity.ReceiptEntity ent) {
    return Receipt(
      id: ent.id,
      receiptNumber: ent.receiptNumber,
      emittedDate: ent.emittedDate.toDate(), // converte de UTC para local
      expireDate: ent.expireDate.toDate(),
      medications: ent.medications.map(MedicinPurchase.fromEntity).toList(),
    );
  }
}
