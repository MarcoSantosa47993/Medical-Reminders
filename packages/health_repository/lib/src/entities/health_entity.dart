import 'package:cloud_firestore/cloud_firestore.dart';

class HealthEntity {
  String id;
  String label;
  double value;
  String unit;
  String? image;
  DateTime date;

  HealthEntity({
    required this.id,
    required this.label,
    required this.value,
    required this.unit,
    required this.image,
    required this.date,
  });

  Map<String, Object?> toDocument() {
    return {
      'id': id,
      'label': label,
      'value': value,
      'unit': unit,
      'image': image,
      'date': date,
    };
  }

  static HealthEntity fromDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    return HealthEntity(
      id: "",
      label: doc["label"],
      value: doc['value'],
      unit: doc['unit'],
      image: doc['image'],
      date: (doc['date'] as Timestamp).toDate(),
    );
  }
}