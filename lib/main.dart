import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:she_secure/features/home/home_page.dart';
import 'package:she_secure/features/onboarding/on_boardingpage.dart';

import 'colors.dart';
import 'common/widgets/error.dart';
import 'common/widgets/loader.dart';
import 'features/auth/controller/auth_controller.dart';
import 'router.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: SheSecure()));
}

class SheSecure extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Suraksha',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(color: appBarColor),
        bottomAppBarTheme: const BottomAppBarTheme(color: backgroundColor),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: backgroundColor,
        ),
      ),
      initialRoute: "/",
      onGenerateRoute: (settings) => generateRoute(settings),
      home: ref.watch(userDataAuthProvider).when(
            data: (data) {
              if (data != null) {
                return const HomePage();
              }
              return const OnBoardingPage();
            },
            error: (error, stackTrace) => ErrorScreen(
              error: error.toString(),
            ),
            loading: () => const LoaderPage(),
          ),
    );
  }
}
