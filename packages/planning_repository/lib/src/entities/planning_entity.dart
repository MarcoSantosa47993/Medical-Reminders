import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planning_repository/src/enums.dart';

class PlanningEntity {
  String id;
  bool jejum;
  String medicineId;
  PlanningPriority priority;
  int quantity;
  DateTime takeAt;
  PlanningStatus taked;

  PlanningEntity({
    required this.id,
    required this.jejum,
    required this.medicineId,
    required this.priority,
    required this.quantity,
    required this.takeAt,
    required this.taked,
  });

  Map<String, Object?> toDocument() {
    return {
      'jejum': jejum,
      'medicineId': medicineId,
      'priority': priority.index,
      'quantity': quantity,
      'takeAt': takeAt,
      'taked': taked.index,
    };
  }

  static PlanningEntity fromDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return PlanningEntity(
      id: "",
      jejum: doc["jejum"],
      medicineId: doc["medicineId"],
      priority: PlanningPriority.values[doc["priority"]],
      quantity: doc["quantity"],
      takeAt: (doc["takeAt"] as Timestamp).toDate(),
      taked: PlanningStatus.values[doc["taked"]],
    );
  }
}
