// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:she_secure/features/auth/controller/auth_controller.dart';
import 'package:she_secure/features/profile/controller/profile_details_controller.dart';

import '../../models/user_model.dart';

class SOSButton extends ConsumerStatefulWidget {
  const SOSButton({super.key});

  @override
  ConsumerState<SOSButton> createState() => _SOSButtonState();
}

class _SOSButtonState extends ConsumerState<SOSButton> {
  bool isActive = false;

  void sendMessage() async {
    final UserModel? user =
        await ref.read(profileDetailsControllerProvider).getDetails(context);
    if (user != null) {
      final List<String> emergencyContacts = user.emergencyNumbers;

      Position _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      
    }
  }

  void sendSOS() {
    setState(() {
      isActive = true;
    });
    Future.delayed(
      Duration(seconds: 10),
    ).then((value) => sendMessage());
  }

  void cancelSOS() {
    setState(() {
      isActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 10,
        side: BorderSide(width: 20),
      ),
      onPressed: () {},
      child: Text('SOS'),
    );
  }
}
