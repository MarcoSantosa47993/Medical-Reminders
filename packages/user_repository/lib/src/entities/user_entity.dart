import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/models.dart';

class MyUserEntity {
  String id;
  String name;
  String email;
  DateTime birthday;
  String location;
  String phone;
  String phone2;
  String? image;
  MyUserRole role;
  int pinCode;

  MyUserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.birthday,
    required this.location,
    required this.phone,
    required this.phone2,
    required this.role,
    required this.pinCode,
    required this.image,
  });

  Map<String, Object?> toDocument() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'birthday': birthday,
      'location': location,
      'phone': phone,
      'phone2': phone2,
      'role': role.index,
      'pinCode': pinCode,
      'image': image,
    };
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
      id: doc["id"],
      name: doc['name'],
      email: doc['email'],
      birthday: (doc['birthday'] as Timestamp).toDate(),
      location: doc['location'],
      phone: doc['phone'],
      phone2: doc['phone2'],
      role: MyUserRole.values[doc['role']],
      pinCode: doc['pinCode'],
      image: doc['image'],
    );
  }
}
