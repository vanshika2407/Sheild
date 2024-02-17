// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:she_secure/features/auth/user_information_screen.dart';
import 'package:she_secure/features/home/home_page.dart';
import 'package:she_secure/features/navigation/options.dart';
import 'package:she_secure/features/navigation/routing.dart';

import 'common/widgets/error.dart';
import 'features/auth/auth_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const AuthScreen(),
      );

    case HomePage.routeName:
      return MaterialPageRoute(
        builder: (context) => const HomePage(),
      );

    case UserInformationScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserInformationScreen(),
      );

    case RoutingWidget.routeName:
      return MaterialPageRoute(
        builder: (context) => const RoutingWidget(),
      );

    case Options.routeName:
      return MaterialPageRoute(
        builder: (context) => const Options(),
      );

    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: const ErrorScreen(error: 'This page does not exist'),
        ),
      );
  }
}
