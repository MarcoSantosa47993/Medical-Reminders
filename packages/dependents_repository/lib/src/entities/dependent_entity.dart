import 'package:cloud_firestore/cloud_firestore.dart';

class DependentEntity {
  String id;
  String name;
  DateTime birthday;
  String location;
  String phone;
  String phone2;
  String userId;

  DependentEntity({
    required this.id,
    required this.name,
    required this.birthday,
    required this.location,
    required this.phone,
    required this.phone2,
    required this.userId,
  });

  Map<String, Object?> toDocument() {
    return {
      'name': name,
      'birthday': birthday,
      'location': location,
      'phone': phone,
      'phone2': phone2,
      'userId': userId,
    };
  }

  static DependentEntity fromDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    return DependentEntity(
      id: "",
      name: doc["name"],
      birthday: (doc['birthday'] as Timestamp).toDate(),
      location: doc['location'],
      phone: doc['phone'],
      phone2: doc['phone2'],
      userId: doc['userId'],
    );
  }
}
