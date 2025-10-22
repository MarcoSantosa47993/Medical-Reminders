import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicins_repository/medicins_repository.dart';

class FirebaseMedicinsRepo implements MedicinsRepository {
  CollectionReference<Medicin> medicinsCollection;

  static Future<FirebaseMedicinsRepo> initWithoutDependent(
    String userId,
  ) async {
    try {
      final dependentQuery =
          await FirebaseFirestore.instance
              .collectionGroup("dependents")
              .where("userId", isEqualTo: userId)
              .get();

      if (dependentQuery.size > 0) {
        final dependentRef = dependentQuery.docs.first;

        final pl = dependentRef.reference
            .collection("medicins")
            .withConverter(
              fromFirestore:
                  (snapshot, otpions) => Medicin.fromEntity(
                    MedicinEntity.fromDocument(snapshot, null),
                  ),
              toFirestore: (Medicin m, options) => m.toEntity().toDocument(),
            );

        return FirebaseMedicinsRepo._(pl);
      } else {
        throw Exception("dependent not exists");
      }
    } catch (e) {
      rethrow;
    }
  }

  FirebaseMedicinsRepo._(this.medicinsCollection);

  FirebaseMedicinsRepo({required userId, required dependentId})
    : medicinsCollection = FirebaseFirestore.instance
          .collection("users/$userId/dependents/$dependentId/medicins")
          .withConverter(
            fromFirestore:
                (snapshot, otpions) => Medicin.fromEntity(
                  MedicinEntity.fromDocument(snapshot, null),
                ),
            toFirestore: (Medicin m, options) => m.toEntity().toDocument(),
          );

  @override
  Future<List<Medicin>> getMyMedicins() async {
    try {
      final query =
          await medicinsCollection
              .withConverter(
                fromFirestore:
                    (snapshot, otpions) => Medicin.fromEntity(
                      MedicinEntity.fromDocument(snapshot, null),
                    ),
                toFirestore: (Medicin m, options) => m.toEntity().toDocument(),
              )
              .get();

      final data =
          query.docs.map((e) {
            final m = e.data();
            m.id = e.id;
            return m;
          }).toList();

      return data;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> setMedicin(Medicin medicin) async {
    try {
      await medicinsCollection.doc(medicin.id).set(medicin);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> removeMedicin(String medicinId) async {
    try {
      await medicinsCollection.doc(medicinId).delete();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> addMedicin(Medicin medicin) async {
    try {
      // verify if medicin already exists
      final query =
          await medicinsCollection.where("name", isEqualTo: medicin.name).get();
      if (query.size > 0) {
        throw Exception("Medicin already exists");
      }

      // add medicin
      final m = Medicin(
        id: "",
        name: medicin.name,
        type: medicin.type,
        quantity: medicin.quantity,
        dosePerPeriod: medicin.dosePerPeriod,
        period: medicin.period,
        observations: medicin.observations,
      );
      await medicinsCollection.add(m);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Medicin> getMedicin(String medicinId) async {
    try {
      final query = await medicinsCollection.doc(medicinId).get();

      if (!query.exists) throw Exception("Medicin not found");

      final medicin = query.data()!;
      medicin.id = query.id;

      return medicin;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> updateStock(String medicineId, {int value = -1}) async {
    try {
      final medicine = await getMedicin(medicineId);

      medicine.quantity = medicine.quantity + value;
      await setMedicin(medicine);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
