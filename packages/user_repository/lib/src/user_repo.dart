import 'dart:typed_data';

import 'models/models.dart';

abstract class UserRepository {
  Stream<MyUser?> get user;

  Future<MyUser> signUp(MyUser myUser, String password);

  Future<void> setUserData(MyUser user);

  Future<void> signIn(String email, String password);

  Future<void> logOut();

  Future<Uint8List?> changeImageProfile(List<int>? imageSrc, String userId);

  Future<Uint8List?> getImageProfile(String userId);

  Future<MyUser> getDependentByPinCode(int pinCode);
}
