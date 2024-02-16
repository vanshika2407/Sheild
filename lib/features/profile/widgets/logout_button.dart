import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/auth_screen.dart';
import '../../auth/controller/auth_controller.dart';

class LogoutButton extends ConsumerWidget {
  const LogoutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(authControllerProvider).logout();
        Navigator.pushNamed(context, AuthScreen.routeName);
      },
      child: Container(
        margin: const EdgeInsets.all(9),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              'Logout',
              style: TextStyle(
                fontSize: 20,
                color: Colors.red,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: const Icon(
                Icons.logout_rounded,
                color: Colors.red,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
