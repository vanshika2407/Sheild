// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_apis/places.dart';
import 'package:she_secure/colors.dart';
import 'package:she_secure/features/navigation/route_tile.dart';
import '../../keys.dart';
import 'package:http/http.dart' as http;

class RoutingWidget extends StatefulWidget {
  const RoutingWidget({
    Key? key,
  }) : super(key: key);
  static const routeName = '/routing';

  @override
  State<RoutingWidget> createState() => _RoutingwidgetState();
}

class _RoutingwidgetState extends State<RoutingWidget> {
  var sessionToken = 'xyzabc_1234';
  late GoogleMapController mapController;
  Map<String, Marker> _markers = {};
  bool isLoading = false;
  bool isLocationLoading = false;
  var searchedLocation;

  var routes;

  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   Marker marker = Marker(
  //     markerId: MarkerId(""),
  //     position: LatLng(widget.startLoc["lat"], widget.startLoc["lng"]),
  //   );
  //   _markers[widget.startLoc["name"]] = marker;
  //   marker = Marker(
  //     markerId: MarkerId(""),
  //     position: LatLng(widget.destLoc["lat"], widget.destLoc["lng"]),
  //   );
  //   _markers[widget.destLoc["name"]] = marker;
  // }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  final places = GoogleMapsPlaces(apiKey: apiKey);
  List opt = [];

  CameraPosition location = CameraPosition(
    target: LatLng(19.20626, 72.873666),
    zoom: 13,
  );

  

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          // Wrap the content in a Column
          children: [
            Expanded(
              // Use Expanded to make the GoogleMap widget take up remaining space
              child: Stack(
                children: [
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: location,
                    markers: _markers.values.toSet(),
                  ),
                  if (isLocationLoading)
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
