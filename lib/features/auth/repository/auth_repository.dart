// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/common_snackbar.dart';
import '../../../models/user_model.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
});

class AuthRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  AuthRepository({
    required this.firestore,
    required this.auth,
  });

  void savePatientInDoctorList(BuildContext context, String doctorId) async {
    try {
      var userData =
          await firestore.collection('users').doc(auth.currentUser?.uid).get();
      UserModel user = UserModel.fromMap(userData.data()!);
      await firestore
          .collection('users')
          .doc(doctorId)
          .collection('patients')
          .doc(auth.currentUser!.uid)
          .set(user.toMap());
    } catch (e) {
      showsnackbar(context: context, msg: e.toString());
    }
  }

  Future<String?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
      return user.userId;
    }
    return null;
  }

  void logoutUser() async {
    await auth.signOut();
  }

  void createUserWithEmailAndPassword({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Navigator.pushNamedAndRemoveUntil(
      //   context,
      //   DoctorUserInformationScreen.routeName,
      //   (route) => false,
      // );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showsnackbar(
          context: context,
          msg: 'The password provided is too weak.',
        );
      } else if (e.code == 'email-already-in-use') {
        showsnackbar(
          context: context,
          msg: 'The account already exists for that email.',
        );
      }
    } catch (e) {
      showsnackbar(context: context, msg: e.toString());
    }
  }

  void saveUserDataToFirebase({
    required BuildContext context,
    required String name,
    required String phoneNumber,
    required File? profilePic,
    required ProviderRef ref,
    String? expertise,
    String? address,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      var user = UserModel(
        name: name,
        userId: 'doctor ${auth.currentUser!.uid}',
        phoneNumber: phoneNumber,
        email: auth.currentUser!.email!,
      );
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .set(user.toMap());
      // Navigator.pushNamedAndRemoveUntil(
      //   context,
      //   DoctorHomePage.routeName,
      //   (route) => false,
      // );
      return;
    } catch (e) {
      showsnackbar(context: context, msg: e.toString());
    }
  }

  void signInWithEmailAndPassword({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);

      // Navigator.pushNamedAndRemoveUntil(
      //   context,
      //   DoctorHomePage.routeName,
      //   (route) => false,
      // );
      return;
    } catch (e) {
      showsnackbar(context: context, msg: e.toString());
    }
  }

  Stream<List<UserModel>> getListofDoctors() {
    return firestore
        .collection('users')
        .orderBy('name')
        .snapshots()
        .map((event) {
      List<UserModel> doctors = [];
      for (var element in event.docs) {
        var doctorDetails = UserModel.fromMap(element.data());
        if (doctorDetails.userId.startsWith('doctor')) {
          doctors.add(UserModel.fromMap(element.data()));
        }
      }
      debugPrint('$doctors');
      return doctors;
    });
  }

  Stream<List<UserModel>> getListofPatients() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('patients')
        .snapshots()
        .map((event) {
      List<UserModel> patients = [];
      for (var element in event.docs) {
        patients.add(UserModel.fromMap(element.data()));
      }
      return patients;
    });
  }
}
