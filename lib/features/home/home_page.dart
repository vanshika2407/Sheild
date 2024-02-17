import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:she_secure/features/community/chat_screen.dart';
import 'package:she_secure/features/home/dashboard.dart';
import 'package:she_secure/features/navigation/navigation.dart';
import 'package:she_secure/features/safe_spaces/safe_spaces_screen.dart';

import '../../colors.dart';
import '../profile/screens/settings_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const routeName = '/doctor-home-page';
  @override
  State<HomePage> createState() => _DoctorMainPageState();
}

class _DoctorMainPageState extends State<HomePage> {
  List pages = [
    Navigationwidget(),
    SafeSpacesScreen(),
    ChatScreen(),
    const SettingsPage(),
  ];

  int _selectedIndex = 0;

  final textStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    color: blackColor,
    fontSize: 16,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: appBarColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
          child: GNav(
            selectedIndex: _selectedIndex,
            backgroundColor: appBarColor,
            color: Colors.white,
            //activeColor: Colors.white,
            gap: 8,
            tabBackgroundColor: tabColor,

            padding: const EdgeInsets.all(20),
            tabs: [
              GButton(
                icon: Icons.dashboard_sharp,
                text: 'Map',
                textColor: blackColor,
                iconColor: whiteColor,
                textStyle: textStyle,
              ),
              GButton(
                  icon: Icons.people_alt_sharp,
                  text: 'Safe Spaces',
                  textColor: Colors.black,
                  iconColor: whiteColor,
                  textStyle: textStyle),
              GButton(
                icon: Icons.settings_outlined,
                text: 'Community',
                textColor: Colors.black,
                iconColor: whiteColor,
                textStyle: textStyle,
              ),
              GButton(
                icon: Icons.settings_outlined,
                text: 'Settings',
                textColor: Colors.black,
                iconColor: whiteColor,
                textStyle: textStyle,
              ),
            ],
            onTabChange: (index) {
              setState(
                () {
                  _selectedIndex = index;
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
