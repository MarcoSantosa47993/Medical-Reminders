import 'package:cloud_firestore/cloud_firestore.dart';

class MedicinPurchaseEntity {
  final String id; // ← novo campo
  final int quantityPurchased;
  final String name;
  final String observations;
  final bool isAdministered;

  MedicinPurchaseEntity({
    required this.id, // ← passe aqui
    required this.quantityPurchased,
    required this.name,
    required this.observations,
    required this.isAdministered,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'quantityPurchased': quantityPurchased,
      'name': name,
      'observations': observations,
      'isAdministered': isAdministered,
    };
  }

  static MedicinPurchaseEntity fromMap(Map<String, dynamic> map) {
    return MedicinPurchaseEntity(
      id: map['id'] as String, // ← lê do documento
      quantityPurchased: map['quantityPurchased'] as int,
      name: map['name'] as String,
      observations: map['observations'] as String? ?? '',
      isAdministered: map['isAdministered'] as bool? ?? false,
    );
  }
}

class ReceiptEntity {
  String id;
  String receiptNumber;
  Timestamp emittedDate;
  Timestamp expireDate;
  List<MedicinPurchaseEntity> medications;

  ReceiptEntity({
    required this.id,
    required this.receiptNumber,
    required this.emittedDate,
    required this.expireDate,
    required this.medications,
  });

  Map<String, Object?> toDocument() {
    return {
      'receiptNumber': receiptNumber,
      'emittedDate': emittedDate,
      'expireDate': expireDate,
      'medications': medications.map((m) => m.toMap()).toList(),
    };
  }

  static ReceiptEntity fromDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? _,
  ) {
    final data = doc.data()!;
    return ReceiptEntity(
      id: doc.id,
      receiptNumber: data['receiptNumber'] as String,
      emittedDate: data['emittedDate'] as Timestamp,
      expireDate: data['expireDate'] as Timestamp,
      medications:
          (data['medications'] as List<dynamic>)
              .map(
                (m) => MedicinPurchaseEntity.fromMap(m as Map<String, dynamic>),
              )
              .toList(),
    );
  }
}
