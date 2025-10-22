import 'package:planning_repository/src/models/planning.dart';

abstract class PlanningRepository {
  Future<List<Planning>> getPlans(DateTime date);

  Future<void> setPlan(Planning plan);

  Future<void> removePlan(String planId, String medicineId);

  Future<Planning> addPlan(Planning plan);

  Future<Planning> getPlan(String planId);

  Future<List<Planning>> getAlerts();
}
