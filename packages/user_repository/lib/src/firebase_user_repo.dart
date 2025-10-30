import 'dart:developer';
import 'dart:typed_data';

import 'package:appwriter_repository/appwriter_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:user_repository/user_repository.dart';

class FirebaseUserRepo implements UserRepository {
  final FirebaseAuth _firebaseAuth;
  final usersCollection = FirebaseFirestore.instance.collection('users');

  FirebaseUserRepo({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Stream<MyUser?> get user {
    return _firebaseAuth.authStateChanges().flatMap((firebaseUser) async* {
      if (firebaseUser == null) {
        yield MyUser.empty;
      } else {
        yield await usersCollection
            .doc(firebaseUser.uid)
            .get()
            .then(
              (value) =>
                  MyUser.fromEntity(MyUserEntity.fromDocument(value.data()!)),
            );
      }
    });
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyUser> signUp(MyUser myUser, String password) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: myUser.email,
        password: password,
      );

      myUser.id = user.user!.uid;
      return myUser;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> setUserData(MyUser myUser) async {
    try {
      await usersCollection.doc(myUser.id).set(myUser.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyUser> getDependentByPinCode(int pinCode) async {
    try {
      final snapshot =
          await usersCollection
              .where("pinCode", isEqualTo: pinCode)
              .where("role", isEqualTo: MyUserRole.dependent.index)
              .get();

      if (snapshot.size > 0) {
        return MyUser.fromEntity(
          MyUserEntity.fromDocument(snapshot.docs[0].data()),
        );
      } else {
        log("Not Found");
        throw Exception("User not found");
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<Uint8List?> changeImageProfile(
    List<int>? imageSrc,
    String userId,
  ) async {
    try {
      final myUser = await usersCollection
          .doc(userId)
          .get()
          .then(
            (value) =>
                MyUser.fromEntity(MyUserEntity.fromDocument(value.data()!)),
          );

      final appwriter = await Appwriter.init();
      final imageId = await appwriter.uploadImage(imageSrc, myUser.image);
      myUser.image = imageId;
      await setUserData(myUser);

      return await getImageProfile(userId);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<Uint8List?> getImageProfile(String userId) async {
    try {
      final myUser = await usersCollection
          .doc(userId)
          .get()
          .then(
            (value) =>
                MyUser.fromEntity(MyUserEntity.fromDocument(value.data()!)),
          );

      final appwriter = await Appwriter.init();

      if (myUser.image != null) {
        final file = await appwriter.getImage(myUser.image!);
        return file;
      }
      return null;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
