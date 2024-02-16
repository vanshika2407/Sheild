import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/common_snackbar.dart';
import '../controller/profile_details_controller.dart';

class ChangeNameScreen extends ConsumerWidget {
  ChangeNameScreen({
    super.key,
  });

  static const routeName = '/update-name';

  final TextEditingController nameController = TextEditingController();

  void updateUserDataToFirebase(BuildContext context, WidgetRef ref) {
    String name = nameController.text.trim();
    if (name.isNotEmpty) {
      ref.read(profileDetailsControllerProvider).updateName(
            context,
            name,
          );
    } else {
      showsnackbar(context: context, msg: 'enter name');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  width: size.width * 0.85,
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your name',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => updateUserDataToFirebase(context, ref),
                  icon: const Icon(Icons.done),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
