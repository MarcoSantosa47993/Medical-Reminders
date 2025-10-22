import 'package:dependents_repository/src/entities/dependent_entity.dart';

class Dependent {
  String id;
  String name;
  DateTime birthday;
  String location;
  String phone;
  String phone2;
  String userId;

  Dependent({
    required this.id,
    required this.name,
    required this.birthday,
    required this.location,
    required this.phone,
    required this.phone2,
    required this.userId,
  });

  static empty(String userId) => Dependent(
    id: "",
    name: "",
    birthday: DateTime.now(),
    location: "",
    phone: "",
    phone2: "",
    userId: userId,
  );

  DependentEntity toEntity() {
    return DependentEntity(
      id: id,
      name: name,
      birthday: birthday,
      location: location,
      phone: phone,
      phone2: phone2,
      userId: userId,
    );
  }

  static Dependent fromEntity(DependentEntity entity) {
    return Dependent(
      id: entity.id,
      name: entity.name,
      birthday: entity.birthday,
      location: entity.location,
      phone: entity.phone,
      phone2: entity.phone2,
      userId: entity.userId,
    );
  }
}
