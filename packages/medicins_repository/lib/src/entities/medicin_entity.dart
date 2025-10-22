import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/models.dart';

class MedicinEntity {
  String id;
  String name;
  String type;
  int quantity;
  int dosePerPeriod;
  Period period;
  String observations;

  MedicinEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.quantity,
    required this.dosePerPeriod,
    required this.period,
    required this.observations,
  });

  Map<String, Object?> toDocument() {
    return {
      'name': name,
      'type': type,
      'quantity': quantity,
      'dosePerPeriod': dosePerPeriod,
      'period': period.index,
      'observations': observations,
    };
  }

  static MedicinEntity fromDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    return MedicinEntity(
      id: "",
      name: doc["name"],
      type: doc['type'],
      quantity: doc['quantity'],
      dosePerPeriod: doc['dosePerPeriod'],
      period: Period.values[doc['period']],
      observations: doc['observations'],
    );
  }
}
