// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_apis/geolocation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_apis/places.dart';
import 'package:she_secure/colors.dart';
import 'package:she_secure/features/navigation/option_widget.dart';
import '../../keys.dart';
import "package:google_maps_apis/geocoding.dart";

class Navigationwidget extends StatefulWidget {
  const Navigationwidget({Key? key}) : super(key: key);

  static const routeName = '/navigation';

  @override
  State<Navigationwidget> createState() => _NavigationwidgetState();
}

class _NavigationwidgetState extends State<Navigationwidget> {
  var sessionToken = 'xyzabc_1234';
  late GoogleMapController mapController;
  final TextEditingController destinationController = TextEditingController();
  Map<String, Marker> _markers = {};
  double destLati = 19.20626;
  double destLongi = 72.873666;
  bool isLoading = false;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      _markers.clear();
      final Marker marker = Marker(
        markerId: MarkerId(""),
        position: LatLng(destLati, destLongi),
      );
      _markers[""] = marker;
    });
  }

  final places = GoogleMapsPlaces(apiKey: apiKey);
  List opt = [];

  CameraPosition location = CameraPosition(
    target: LatLng(19.20626, 72.873666),
    zoom: 13,
  );

  void _onOptionSelected(String selectedName, double lati, double longi) {
    setState(() {
      destinationController.text = selectedName;
      _markers.clear();
      final Marker marker = Marker(
        markerId: MarkerId(""),
        position: LatLng(lati, longi),
      );
      _markers[""] = marker;
      opt = [];

      // Calculate zoom level based on the desired area to be displayed
      double zoomLevel =
          15.0; // You can adjust this value according to your preference

      // Specify the duration of the animation (e.g., 1.5 seconds)
      Duration animationDuration = Duration(milliseconds: 1500);

      // Animate camera with smoother movement using longer duration
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lati, longi), zoom: 15),
          // LatLng(lati, longi),
          // zoomLevel,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: Stack(
            children: [
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: location,
                markers: _markers.values.toSet(),
              ),
              Container(
                margin: EdgeInsets.only(left: size.width * 0.05, top: 10),
                padding: EdgeInsets.all(4),
                width: size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: greyColor,
                ),
                child: Stack(
                  children: [
                    TextField(
                      controller: destinationController,
                      decoration: InputDecoration(border: InputBorder.none),
                      onChanged: (value) async {
                        setState(() {
                          isLoading = true;
                        });
                        // show Google Places autocomplete to get user input
                        var res = await places.autocomplete(
                          destinationController.text,
                          sessionToken: sessionToken,
                        );
                        print("prediction: $res");
                        if (res.isOk && !res.hasNoResults) {
                          // update the text field with the selected place
                          List newOpt = [];
                          for (var p in (res.predictions ?? [])) {
                            final placeId = p.placeId;
                            // debugPrint(
                            //     "place id: ${res.predictions?[0].placeId}");
                            if (placeId == null) return;
                            // get detail of the first result
                            var details = await places.getDetailsByPlaceId(
                              placeId,
                              sessionToken: sessionToken,
                            );
                            newOpt.add(details.result);
                            // print('\nDetails :');
                            // print(details.result?.formattedAddress);
                            // print(details.result?.formattedPhoneNumber);
                            // print(details.result?.geometry!.location.);
                          }
                          setState(() {
                            opt = newOpt;
                            isLoading = false;
                          });
                        } else {
                          print(res.errorMessage);
                          setState(() {
                            opt = [];
                            isLoading = false;
                          });
                        }
                      },
                    ),
                    if (isLoading)
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              ),
              if (opt.isNotEmpty)
                Positioned(
                  top: 60,
                  child: Container(
                    decoration: BoxDecoration(
                        // border: Border.all(),
                        ),
                    width: size.width * 0.9,
                    margin: EdgeInsets.only(left: size.width * 0.05, top: 10),
                    child: OptionsWidget(
                      opt: opt,
                      onOptionSelected: _onOptionSelected,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
