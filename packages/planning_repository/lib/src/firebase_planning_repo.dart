import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicins_repository/medicins_repository.dart';
import 'package:planning_repository/src/entities/entities.dart';
import 'package:planning_repository/src/enums.dart';
import 'package:planning_repository/src/models/planning.dart';
import 'package:planning_repository/src/planning_repo.dart';

class FirebasePlanningRepo implements PlanningRepository {
  CollectionReference<Planning> planningCollection;
  FirebaseMedicinsRepo medicinsRepo;

  static Future<FirebasePlanningRepo> initWithoutDependent(
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
            .collection("planning")
            .withConverter(
              fromFirestore:
                  (snapshot, options) => Planning.fromEntity(
                    PlanningEntity.fromDocument(snapshot),
                  ),
              toFirestore: (Planning p, options) => p.toEntity().toDocument(),
            );

        final mr = await FirebaseMedicinsRepo.initWithoutDependent(userId);
        return FirebasePlanningRepo._(pl, mr);
      } else {
        throw Exception("dependent not exists");
      }
    } catch (e) {
      rethrow;
    }
  }

  FirebasePlanningRepo._(this.planningCollection, this.medicinsRepo);

  FirebasePlanningRepo({required userId, required dependentId})
    : planningCollection = FirebaseFirestore.instance
          .collection("users/$userId/dependents/$dependentId/planning")
          .withConverter(
            fromFirestore:
                (snapshot, options) =>
                    Planning.fromEntity(PlanningEntity.fromDocument(snapshot)),
            toFirestore: (Planning p, options) => p.toEntity().toDocument(),
          ),
      medicinsRepo = FirebaseMedicinsRepo(
        userId: userId,
        dependentId: dependentId,
      );

  @override
  Future<Planning> addPlan(Planning plan) async {
    try {
      // get number of medicines in period
      final medicine = await medicinsRepo.getMedicin(plan.medicineId);

      final dateRange = _getPeriodRangeByDate(plan.takeAt, medicine.period);

      final query =
          await planningCollection
              .where("medicineId", isEqualTo: plan.medicineId)
              .where("takeAt", isGreaterThanOrEqualTo: dateRange["firstDate"])
              .where("takeAt", isLessThanOrEqualTo: dateRange["lastDate"])
              .get();

      if (query.size >= medicine.dosePerPeriod) {
        throw Exception(
          "Dependent just can take ${medicine.dosePerPeriod} by ${medicine.period.name}",
        );
      }

      final p = await (await planningCollection.add(plan)).get();
      final newPlan = p.data()!;
      newPlan.id = p.id;
      await medicinsRepo.updateStock(newPlan.medicineId);
      return newPlan;
    } catch (e) {
      print(e.toString());
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<Planning> getPlan(String planId) async {
    try {
      final query = await planningCollection.doc(planId).get();

      if (!query.exists) throw Exception("Plan not found");

      final plan = query.data()!;
      plan.id = query.id;

      return plan;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Planning>> getPlans(DateTime date) async {
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
          await planningCollection
              .where("takeAt", isGreaterThanOrEqualTo: startDate)
              .where("takeAt", isLessThanOrEqualTo: endDate)
              .get();

      final data =
          query.docs.map((e) {
            final p = e.data();
            p.id = e.id;
            return p;
          }).toList();

      return data;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> removePlan(String planId, String medicineId) async {
    try {
      await planningCollection.doc(planId).delete();
      await medicinsRepo.updateStock(medicineId, value: 1);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> setPlan(Planning plan) async {
    try {
      await planningCollection.doc(plan.id).set(plan);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Map<String, DateTime> _getPeriodRangeByDate(DateTime date, Period period) {
    var firstDate = DateTime.now();
    var lastDate = DateTime.now();

    switch (period) {
      case Period.day:
        firstDate = date.copyWith(hour: 0, minute: 0, second: 0);
        lastDate = date.copyWith(hour: 23, minute: 59, second: 59);
        break;

      case Period.week:
        int weekday = date.weekday;
        firstDate = date.subtract(Duration(days: weekday - 1));
        lastDate = date.add(Duration(days: 7 - weekday));
        break;

      case Period.month:
        firstDate = DateTime(date.year, date.month, 1);
        lastDate = DateTime(date.year, date.month, 0);
        break;

      case Period.year:
        final year = date.year;
        firstDate = DateTime(year, 1, 1, 0, 0, 0, 0, 0);
        lastDate = DateTime(year, 31, 12, 23, 59, 59, 59);
        break;
    }

    return {"firstDate": firstDate, "lastDate": lastDate};
  }

  @override
  Future<List<Planning>> getAlerts() async {
    try {
      final currentDate = DateTime.now();

      final query =
          await planningCollection
              .where("taked", isEqualTo: PlanningStatus.pending.index)
              .where("takeAt", isLessThanOrEqualTo: currentDate)
              .orderBy("takeAt")
              .get();

      final data =
          query.docs.map((e) {
            final p = e.data();
            p.id = e.id;
            return p;
          }).toList();

      return data;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
