import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dependents_repository/dependents_repository.dart';
import 'package:user_repository/user_repository.dart';

class FirebaseDependentsRepo implements DependentsRepository {
  CollectionReference<Dependent> dependentsCollection;

  FirebaseDependentsRepo({required userId})
    : dependentsCollection = FirebaseFirestore.instance
          .collection("users/$userId/dependents")
          .withConverter(
            fromFirestore:
                (snapshot, otpions) => Dependent.fromEntity(
                  DependentEntity.fromDocument(snapshot, null),
                ),
            toFirestore: (Dependent d, options) => d.toEntity().toDocument(),
          );

  @override
  Future<void> addDependent(int pinCode) async {
    try {
      // get user with pincode
      final user = await FirebaseUserRepo().getDependentByPinCode(pinCode);

      // verify if user already exists in dependents list
      final query =
          await dependentsCollection.where("userId", isEqualTo: user.id).get();
      if (query.size > 0) {
        throw Exception("Dependent already exists");
      }

      // add dependent
      final d = Dependent(
        id: "",
        name: user.name,
        birthday: user.birthday,
        location: user.location,
        phone: user.phone,
        phone2: user.phone2,
        userId: user.id,
      );
      await dependentsCollection.add(d);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Dependent>> getMyDependents() async {
    try {
      final query =
          await dependentsCollection
              .withConverter(
                fromFirestore:
                    (snapshot, otpions) => Dependent.fromEntity(
                      DependentEntity.fromDocument(snapshot, null),
                    ),
                toFirestore:
                    (Dependent d, options) => d.toEntity().toDocument(),
              )
              .get();

      final data =
          query.docs.map((e) {
            final d = e.data();
            d.id = e.id;
            return d;
          }).toList();

      return data;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> removeDependent(String dependentId) async {
    try {
      await dependentsCollection.doc(dependentId).delete();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> setDependent(Dependent dependent) async {
    try {
      await dependentsCollection.doc(dependent.id).set(dependent);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<Dependent> getDependent(String dependentId) async {
    try {
      final query = await dependentsCollection.doc(dependentId).get();

      if (!query.exists) throw Exception("Dependent not found");

      final dependent = query.data()!;
      dependent.id = query.id;

      return dependent;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
