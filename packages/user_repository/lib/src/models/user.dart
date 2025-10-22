import 'dart:math';

import '../entities/entities.dart';

class MyUser {
  String id;
  String name;
  String email;
  DateTime birthday;
  String location;
  String phone;
  String phone2;
  MyUserRole role;
  int pinCode;
  String? image;

  MyUser({
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

  static final empty = MyUser(
    id: "",
    name: "",
    email: "",
    birthday: DateTime.now(),
    location: "",
    phone: "",
    phone2: "",
    role: MyUserRole.dependent,
    pinCode: 000,
    image: null,
  );

  MyUserEntity toEntity() {
    return MyUserEntity(
      id: id,
      name: name,
      email: email,
      birthday: birthday,
      location: location,
      phone: phone,
      phone2: phone2,
      role: role,
      pinCode: pinCode,
      image: image,
    );
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      birthday: entity.birthday,
      location: entity.location,
      phone: entity.phone,
      phone2: entity.phone2,
      role: entity.role,
      pinCode: entity.pinCode,
      image: entity.image,
    );
  }

  static int generateRandomPincode() {
    final random = Random();
    // Generates a number from 1000 to 9999 inclusive
    int pincode = 1000 + random.nextInt(9000);
    return pincode;
  }

  @override
  String toString() {
    return 'MyUser: $id, $email, $name, $birthday, $role, $location, $phone, $phone2, $pinCode, ${image.toString()}';
  }
}

enum MyUserRole { dependent, caregiver }
