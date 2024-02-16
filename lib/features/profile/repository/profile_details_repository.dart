// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/common_snackbar.dart';
import '../../../models/user_model.dart';
import '../../home/home_page.dart';

final profileDetailsRepositoryProvider = Provider((ref) {
  return ProfileDetailsRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  );
});

class ProfileDetailsRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;
  ProfileDetailsRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  Future<UserModel?> getDetails(BuildContext context) async {
    try {
      UserModel docDetails;
      var userData =
          await firestore.collection('users').doc(auth.currentUser!.uid).get();
      docDetails = UserModel.fromMap(userData.data()!);
      return docDetails;
    } catch (e) {
      showsnackbar(context: context, msg: e.toString());
    }
    return null;
  }

  void changeName(BuildContext context, String newName) async {
    try {
      var existingUser = await getDetails(context);
      var newUser = UserModel(
        name: newName,
        userId: existingUser!.userId,
        phoneNumber: existingUser.phoneNumber,
        email: existingUser.email,
      );
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .set(newUser.toMap());

      Future.delayed(const Duration(seconds: 2)).then((value) {
        showsnackbar(context: context, msg: 'Details updated successfully');
        Navigator.popAndPushNamed(context, HomePage.routeName);
      });
    } catch (e) {
      showsnackbar(context: context, msg: e.toString());
    }
  }

  

  Future<String?> getName(BuildContext context) async {
    try {
      var userDetails = await getDetails(context);
      return userDetails!.name;
    } catch (e) {
      showsnackbar(context: context, msg: e.toString());
    }
    return null;
  }
}
