import 'package:flutter/material.dart';
import 'package:here_final/features/onboarding/splash_screen.dart';

import 'screens/event.dart';
import 'screens/home.dart';
import 'theme/style.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(GMapsClone());
}

class GMapsClone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Suraksha',
      theme: appTheme(),
      initialRoute: "/",
      // routes: <String, WidgetBuilder>{
      //   "/": (BuildContext ctx) => const Home(title: '',),
      //   "/Event": (BuildContext ctx) => Event()
      // },
      home: SplashScreen(),
    );
  }
}
