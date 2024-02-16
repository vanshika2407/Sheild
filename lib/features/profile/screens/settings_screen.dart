import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/loader.dart';
import '../controller/profile_details_controller.dart';
import '../widgets/list_tile_widget.dart';
import '../widgets/logout_button.dart';
import 'profile_screen.dart';
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: FutureBuilder(
          future: ref
              .read(profileDetailsControllerProvider)
              .getDetails(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoaderPage();
            }
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 4),
              child: Column(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.all(10),
                        child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 100,
                          // backgroundImage:
                          //     NetworkImage(snapshot.data!.profilePic),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          snapshot.data!.name,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          snapshot.data!.email,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      // Container(
                      //   margin: const EdgeInsets.only(bottom: 10),
                      //   child: Text(
                      //     '${snapshot.data!.expertise} specialist',
                      //     style: const TextStyle(fontSize: 16),
                      //   ),
                      // ),
                      // Container(
                      //   margin: const EdgeInsets.only(bottom: 10),
                      //   child: Text(
                      //     'work at: ${snapshot.data!.address}',
                      //     style: const TextStyle(fontSize: 16),
                      //   ),
                      // ),
                    ],
                  ),
                  Column(
                    children: [
                      ListTileWidget(
                        icon: Icons.person,
                        text: 'Account',
                        onTap: () {
                          Navigator.pushNamed(
                              context, ProfilePage.routeName);
                        },
                      ),
                      ListTileWidget(
                        icon: Icons.notifications,
                        text: 'Notification',
                        onTap: () {},
                      ),
                      ListTileWidget(
                        icon: Icons.remove_red_eye,
                        text: 'Appearance',
                        onTap: () {},
                      ),
                      ListTileWidget(
                        icon: Icons.shield_rounded,
                        text: 'Privacy and Security',
                        onTap: () {},
                      ),
                      const LogoutButton(),
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }
}
