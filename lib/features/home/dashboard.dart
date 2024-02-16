import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/widgets/loader.dart';
import '../profile/controller/profile_details_controller.dart';
import '../profile/widgets/list_tile_widget.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future:
              ref.read(profileDetailsControllerProvider).getUsername(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoaderWidget();
            }
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: size.height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: size.width * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "Welcome ${snapshot.data}",
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "What would you like to do today?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
                Column(
                  children: [
                    ListTileWidget(
                      icon: Icons.search,
                      text: 'Scan an image to get result',
                      onTap: () {
                        // Navigator.pushNamed(
                        //   context,
                        //   DoctorAllScanPages.routeName,
                        // );
                      },
                    ),
                    ListTileWidget(
                      icon: Icons.mail,
                      text: 'See your reports',
                      onTap: () {
                        // Navigator.pushNamed(
                        //   context,
                        //   DoctorAllReports.routeName,
                        // );
                      },
                    ),
                    ListTileWidget(
                        icon: Icons.mail,
                        text: 'See patient reports',
                        onTap: () {
                          // Navigator.pushNamed(
                          //   context,
                          //   ListofPatientsForReports.routeName,
                          // );
                        }),
                    ListTileWidget(
                      icon: Icons.phone,
                      text: 'Messages',
                      onTap: () {
                        // Navigator.pushNamed(context, ListofPatients.routeName);
                      },
                    ),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
