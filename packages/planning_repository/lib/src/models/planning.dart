import 'package:planning_repository/src/entities/entities.dart';
import 'package:planning_repository/src/enums.dart';

class Planning {
  String id;
  bool jejum;
  String medicineId;
  PlanningPriority priority;
  int quantity;
  DateTime takeAt;
  PlanningStatus taked;

  Planning({
    required this.id,
    required this.jejum,
    required this.medicineId,
    required this.priority,
    required this.quantity,
    required this.takeAt,
    required this.taked,
  });

  static empty() => Planning(
    id: "",
    jejum: false,
    medicineId: "",
    priority: PlanningPriority.low,
    quantity: 1,
    takeAt: DateTime.now(),
    taked: PlanningStatus.pending,
  );

  PlanningEntity toEntity() {
    return PlanningEntity(
      id: id,
      jejum: jejum,
      medicineId: medicineId,
      priority: priority,
      quantity: quantity,
      takeAt: takeAt,
      taked: taked,
    );
  }

  static Planning fromEntity(PlanningEntity entity) {
    return Planning(
      id: entity.id,
      jejum: entity.jejum,
      medicineId: entity.medicineId,
      priority: entity.priority,
      quantity: entity.quantity,
      takeAt: entity.takeAt,
      taked: entity.taked,
    );
  }
}
