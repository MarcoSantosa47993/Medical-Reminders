import 'dart:developer';
import 'dart:typed_data';

import 'package:appwriter_repository/appwriter_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_repository/health_repository.dart';

class FirebaseHealthRepo implements HealthRepository {
  CollectionReference<Health> healthCollection;

  FirebaseHealthRepo({required userId, required dependentId})
    : healthCollection = FirebaseFirestore.instance
          .collection("users/$userId/dependents/$dependentId/health")
          .withConverter(
            fromFirestore:
                (snapshot, otpions) => Health.fromEntity(
                  HealthEntity.fromDocument(snapshot, null),
                ),
            toFirestore: (Health m, options) => m.toEntity().toDocument(),
          );

  @override
  Future<List<Health>> getMyHealth(DateTime date) async {
    try {
      // convert date in date-range
      // id date is 12-12-2002, so it needs to be converted into two dates:
      // 12-12-2002:00:00
      // 12-12-2002:23:59

      final startDate = date.copyWith(
        hour: 0,
        minute: 0,
        second: 0,
        microsecond: 0,
        millisecond: 0,
      );
      final endDate = date.copyWith(
        hour: 23,
        minute: 59,
        second: 59,
        microsecond: 59,
        millisecond: 59,
      );

      final query =
          await healthCollection
              .where("date", isGreaterThanOrEqualTo: startDate)
              .where("date", isLessThanOrEqualTo: endDate)
              .get();

      final data =
          query.docs.map((e) {
            final m = e.data();
            m.id = e.id;
            return m;
          }).toList();

      return data;
    } catch (e) {
      print(e.toString());
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> setHealth(Health health, {List<int>? imageSrc}) async {
    try {
      String? imageId = health.image;

      if (imageSrc != null) {
        final appwriter = await Appwriter.init();
        imageId = await appwriter.uploadImage(imageSrc, imageId);
      }

      health.image = imageId;
      await healthCollection.doc(health.id).set(health);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> removeHealth(String healthId) async {
    try {
      await healthCollection.doc(healthId).delete();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<Health> addHealth(Health health, {List<int>? imageSrc}) async {
    try {
      if (health.id.isNotEmpty) {
        throw Exception("Health ID should be empty for new entries");
      }

      String? imageId = health.image;

      if (imageSrc != null) {
        final appwriter = await Appwriter.init();
        imageId = await appwriter.uploadImage(imageSrc, imageId);
      }

      // add medicin
      final healthRegistry = Health(
        id: "",
        label: health.label,
        value: health.value,
        unit: health.unit,
        image: imageId,
        date: health.date,
      );

      final x = await (await healthCollection.add(healthRegistry)).get();
      final newHealth = x.data()!;
      newHealth.id = x.id;
      return newHealth;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<Health> getHealth(String healthId) async {
    try {
      final query = await healthCollection.doc(healthId).get();

      if (!query.exists) throw Exception("Health Registry not found");

      final health = query.data()!;
      health.id = query.id;

      return health;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<Uint8List?> getImage(String healthId) async {
    try {
      final health = await getHealth(healthId);

      if (health.image != null) {
        final appwriter = await Appwriter.init();
        final file = await appwriter.getImage(health.image!);
        return file;
      }
      return null;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
