import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/user_model.dart';
import '../repository/profile_details_repository.dart';

final profileDetailsControllerProvider = Provider((ref) {
  final profileDetailsRepository = ref.watch(profileDetailsRepositoryProvider);
  return ProfileDetailsController(
    profileDetailsRepository: profileDetailsRepository,
    ref: ref,
  );
});

class ProfileDetailsController {
  final ProfileDetailsRepository profileDetailsRepository;
  final ProviderRef ref;
  ProfileDetailsController({
    required this.profileDetailsRepository,
    required this.ref,
  });

  Future<UserModel?> getDetails(BuildContext context) {
    return profileDetailsRepository.getDetails(context);
  }

  void updateName(BuildContext context, String newName) {
    return profileDetailsRepository.changeName(context, newName);
  }

  Future<String?> getUsername(BuildContext context) {
    return profileDetailsRepository.getName(context);
  }
}
