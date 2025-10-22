import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:medicins_repository/medicins_repository.dart';

import 'package:receipts_repository/receipts_repository.dart';
import 'package:receipts_repository/src/entities/receipt_entity.dart' as entity;
import 'package:uuid/uuid.dart';

class FirebaseReceiptsRepo implements ReceiptsRepository {
  final CollectionReference<entity.ReceiptEntity> receiptsCollection;
  final CollectionReference<Medicin> medicinsCollection;
  final _uuid = Uuid();
  FirebaseReceiptsRepo({required String userId, required String dependentId})
    : receiptsCollection = FirebaseFirestore.instance
          .collection("users/$userId/dependents/$dependentId/receipts")
          .withConverter<entity.ReceiptEntity>(
            fromFirestore:
                (snap, _) => entity.ReceiptEntity.fromDocument(snap, null),
            toFirestore: (entity.ReceiptEntity r, _) => r.toDocument(),
          ),
      medicinsCollection = FirebaseFirestore.instance
          .collection("users/$userId/dependents/$dependentId/medicins")
          .withConverter<Medicin>(
            fromFirestore:
                (snap, _) =>
                    Medicin.fromEntity(MedicinEntity.fromDocument(snap, null)),
            toFirestore: (Medicin m, _) => m.toEntity().toDocument(),
          );

  @override
  Future<List<Receipt>> getMyReceipts() async {
    try {
      final query = await receiptsCollection.get();
      final data =
          query.docs.map((docSnap) {
            final ent = docSnap.data();
            ent.id = docSnap.id;
            return Receipt.fromEntity(ent);
          }).toList();
      return data;
    } catch (e) {
      log("Erro em getMyReceipts: $e");
      rethrow;
    }
  }

  @override
  Future<void> adjustMedicinStock(List<MedicinPurchaseInput> purchases) async {
    final batch = FirebaseFirestore.instance.batch();

    for (var purchase in purchases) {
      final query =
          await medicinsCollection
              .where('name', isEqualTo: purchase.name)
              .get();

      if (query.size > 0) {
        final doc = query.docs.first;
        final med = doc.data();
        med.quantity += purchase.quantityPurchased;
        batch.update(medicinsCollection.doc(doc.id), {
          'quantity': med.quantity,
        });
      } else {
        final newMed = Medicin(
          id: '',
          name: purchase.name,
          type: '',
          quantity: purchase.quantityPurchased,
          dosePerPeriod: purchase.dosePerPeriod,
          period: purchase.period,
          observations: purchase.observations,
        );
        batch.set(medicinsCollection.doc(), newMed);
      }
    }
    await batch.commit();
  }

  @override
  Future<void> addReceipt(
    String receiptNumber,
    DateTime emittedDate,
    DateTime expireDate,
    List<MedicinPurchaseInput> purchases,
  ) async {
    // Ao mapear, gere um id para cada MedicinPurchase:
    final receiptMedications =
        purchases.map((p) {
          return MedicinPurchase(
            id: _uuid.v4(), // ← aqui
            quantityPurchased: p.quantityPurchased,
            name: p.name,
            observations: p.observations,
          );
        }).toList();

    final newReceipt = Receipt(
      id: '',
      receiptNumber: receiptNumber,
      emittedDate: emittedDate,
      expireDate: expireDate,
      medications: receiptMedications,
    );

    final receiptDocRef = receiptsCollection.doc();
    await receiptDocRef.set(newReceipt.toEntity());
  }

  @override
  Future<void> updateReceipt(Receipt receipt) async {
    print('[FirebaseReceiptsRepo] updateReceipt id=${receipt.id}');
    try {
      await receiptsCollection.doc(receipt.id).set(receipt.toEntity());
    } catch (e) {
      log("Erro em updateReceipt: $e");
      rethrow;
    }
  }

  @override
  Future<void> removeReceipt(String receiptId) async {
    try {
      await receiptsCollection.doc(receiptId).delete();
    } catch (e) {
      log("Erro em removeReceipt: $e");
      rethrow;
    }
  }

  @override
  Future<void> setReceipt(Receipt receipt) async {
    if (receipt.id.isEmpty) {
      await addReceipt(
        receipt.receiptNumber,
        receipt.emittedDate,
        receipt.expireDate,
        receipt.medications.map((mp) {
          return MedicinPurchaseInput(
            name: mp.name,
            type: '',
            quantityPurchased: mp.quantityPurchased,
            dosePerPeriod: 1,
            period: Period.day,
            observations: mp.observations,
          );
        }).toList(),
      );
    } else {
      await updateReceipt(receipt);
    }
  }
}
