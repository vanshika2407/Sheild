import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/widgets/common_snackbar.dart';
import 'controller/auth_controller.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  const UserInformationScreen({super.key});

  static const routeName = '/user-information';

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController safeKeyWordController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController emergencyNumberController =
      TextEditingController();
  final TextEditingController emergencyNumberController1 =
      TextEditingController();
  final TextEditingController emergencyNumberController2 =
      TextEditingController();

  void saveUserDataToFirebase() {
    String name = nameController.text.trim();
    String phoneNumber = phoneController.text.trim();
    String safeWord = safeKeyWordController.text.trim();
    String city = cityController.text.trim();

    List<String> emergencyNumbers = [emergencyNumberController.text.trim()];
    if (emergencyNumberController1.text.trim() != "") {
      emergencyNumbers.add(emergencyNumberController1.text.trim());
    }
    if (emergencyNumberController2.text.trim() != "") {
      emergencyNumbers.add(emergencyNumberController2.text.trim());
    }
    debugPrint(emergencyNumbers.toString());
    if (name.isNotEmpty &&
        phoneNumber.isNotEmpty &&
        safeWord.isNotEmpty &&
        city.isNotEmpty &&
        emergencyNumbers.isNotEmpty) {
      ref.read(authControllerProvider).saveUserDataToFirebase(
            context: context,
            name: name,
            phoneNumber: phoneNumber,
            safeword: safeWord,
            emergencyNumbers: emergencyNumbers,
            city: city,
          );
    } else {
      showsnackbar(context: context, msg: 'enter all fields');
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                Container(
                  width: size.width * 0.85,
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your phone number',
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
                Container(
                  width: size.width * 0.85,
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: safeKeyWordController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your safe word',
                    ),
                  ),
                ),
                Container(
                  width: size.width * 0.85,
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: cityController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your city',
                    ),
                  ),
                ),
                Container(
                  width: size.width * 0.85,
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: emergencyNumberController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your emergency number*',
                    ),
                  ),
                ),
                Container(
                  width: size.width * 0.85,
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: emergencyNumberController1,
                    decoration: const InputDecoration(
                      hintText: 'Enter your emergency number',
                    ),
                  ),
                ),
                Container(
                  width: size.width * 0.85,
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: emergencyNumberController2,
                    decoration: const InputDecoration(
                      hintText: 'Enter your emergency number',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => saveUserDataToFirebase(),
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
