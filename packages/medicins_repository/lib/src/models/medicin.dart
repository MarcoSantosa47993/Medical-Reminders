import 'package:medicins_repository/src/entities/medicin_entity.dart';

class Medicin {
  String id;
  String name;
  String type;
  int quantity;
  int dosePerPeriod;
  Period period;
  String observations;

  Medicin({
    required this.id,
    required this.name,
    required this.type,
    required this.quantity,
    required this.dosePerPeriod,
    required this.period,
    required this.observations,
  });

  static empty() => Medicin(
    id: "",
    name: "",
    type: "",
    quantity: 1,
    dosePerPeriod: 1,
    period: Period.day,
    observations: "",
  );

  MedicinEntity toEntity() {
    return MedicinEntity(
      id: id,
      name: name,
      type: type,
      quantity: quantity,
      dosePerPeriod: dosePerPeriod,
      period: period,
      observations: observations,
    );
  }

  static Medicin fromEntity(MedicinEntity entity) {
    return Medicin(
      id: entity.id,
      name: entity.name,
      type: entity.type,
      quantity: entity.quantity,
      dosePerPeriod: entity.dosePerPeriod,
      period: entity.period,
      observations: entity.observations,
    );
  }
}

enum Period { day, week, month, year }