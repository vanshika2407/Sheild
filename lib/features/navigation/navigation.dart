// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

class Navigationwidget extends StatelessWidget {
  const Navigationwidget({super.key});

  static const routeName = '/navigation';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Navigation'),
      ),
    );
  }
}
