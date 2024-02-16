import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:she_secure/models/user_model.dart';

import '../repository/auth_repository.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(ref: ref, authRepository: authRepository);
});

final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getuserData();
});

class AuthController {
  final ProviderRef ref;
  final AuthRepository authRepository;

  AuthController({
    required this.ref,
    required this.authRepository,
  });

  Future<String?> getuserData() async {
    String? userId = await authRepository.getCurrentUserData();
    return userId;
  }

  void logout() {
    return authRepository.logoutUser();
  }

  void signUpWithPhone({
    required BuildContext context,
    required String email,
    required String password,
  }) {
    return authRepository.createUserWithEmailAndPassword(
      context: context,
      email: email,
      password: password,
    );
  }

  void saveUserDataToFirebase({
    required BuildContext context,
    required String name,
    required String phoneNumber,
    required String safeword,
    required List<String> emergencyNumbers,
    required String city,
  }) {
    return authRepository.saveUserDataToFirebase(
      ref: ref,
      context: context,
      name: name,
      phoneNumber: phoneNumber,
      emergencyNumbers: emergencyNumbers,
      safeword: safeword,
      city: city,
    );
  }

  void signInWithEmailAndPassword({
    required BuildContext context,
    required String email,
    required String password,
  }) {
    return authRepository.signInWithEmailAndPassword(
      context: context,
      email: email,
      password: password,
    );
  }

  // Stream<List<UserModel>> getListOfPatientsController() {
  //   return authRepository.getListofPatients();
  // }

  // Stream<List<UserModel>> getListOfDoctorsController() {
  //   return authRepository.getListofDoctors();
  // }

  // void savePatientToDoctorList({
  //   required BuildContext context,
  //   required String doctorId,
  // }) {
  //   return authRepository.savePatientInDoctorList(context, doctorId);
  // }
}
