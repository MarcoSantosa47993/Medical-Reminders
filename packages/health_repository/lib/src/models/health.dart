import 'package:health_repository/src/entities/health_entity.dart';

class Health {
  String id;
  String label;
  double value;
  String unit;
  String? image;
  DateTime date;

  Health({
    required this.id,
    required this.label,
    required this.value,
    required this.unit,
    required this.image,
    required this.date,
  });
  static Health empty() => Health(
    id: "",
    label: "",
    value: 1.0,
    unit: "",
    image: null,
    date: DateTime.now(),
  );

  HealthEntity toEntity() {
    return HealthEntity(
      id: id,
      label: label,
      value: value,
      unit: unit,
      image: image,
      date: date,
    );
  }

  static Health fromEntity(HealthEntity entity) {
    return Health(
      id: entity.id,
      label: entity.label,
      value: entity.value,
      unit: entity.unit,
      image: entity.image,
      date: entity.date,
    );
  }
}