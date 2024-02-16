import 'package:flutter/material.dart';

import 'screens/event.dart';
import 'screens/home.dart';
import 'theme/style.dart';


void main() => runApp(GMapsClone());

class GMapsClone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Suraksha',
      theme: appTheme(),
      initialRoute: "/",
      routes: <String, WidgetBuilder>{
        "/": (BuildContext ctx) => const Home(title: '',),
        "/Event": (BuildContext ctx) => Event()
      },
    );
  }
}
