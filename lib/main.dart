import 'package:flutter/material.dart';
import 'package:she_secure/features/onboarding/on_boardingpage.dart';

import 'colors.dart';
import 'router.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(SheSecure());
}

class SheSecure extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Suraksha',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(color: appBarColor),
        bottomAppBarTheme: const BottomAppBarTheme(color: backgroundColor),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: backgroundColor,
        ),
        
      ),
      initialRoute: "/",
      onGenerateRoute: (settings) => generateRoute(settings),
      home: OnBoardingPage(),
    );
  }
}
