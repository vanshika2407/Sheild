// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:she_secure/colors.dart';
import 'package:she_secure/features/navigation/widgets/draggablesection.dart';

import 'widgets/topsection.dart';

class Navigationwidget extends StatefulWidget {
  const Navigationwidget({super.key});

  static const routeName = '/navigation';

  @override
  State<Navigationwidget> createState() => _NavigationwidgetState();
}

class _NavigationwidgetState extends State<Navigationwidget> {
  late GoogleMapController mapController;
  final TextEditingController destinationController = TextEditingController();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  GoogleMapsPlaces _places = GoogleMapsPlaces(
    apiKey: "AIzaSyAgdWqFlB-negWJL6wAp1YsPg5ZoiamECI",
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(19.20626, 72.873666),
              ),
            ),
            // TopSection(),
            GestureDetector(
              child: CDraggable(),
            ),
            Positioned(
              top: 10,
              left: size.width * 0.05,
              child: Container(
                width: size.width * 0.9,
                decoration: BoxDecoration(
                  color: greyColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.all(10),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                  ),
                  
                  onTap: () async {
                    // show Google Places autocomplete to get user input
                    Prediction? prediction = await PlacesAutocomplete.show(
                      types: ["locality"],

                      strictbounds: false,
                      components: [Component(Component.country, 'in')],
                      context: context,
                      apiKey: "AIzaSyAgdWqFlB-negWJL6wAp1YsPg5ZoiamECI",
                      mode: Mode.overlay,
                      // display over the current view
                      language: "en",
                      // components: [Component(Component.country, "in")],
                    );
                    print("prediction: $prediction");
                    if (prediction != null) {
                      // update the text field with the selected place
                      destinationController.text = prediction.description!;
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
