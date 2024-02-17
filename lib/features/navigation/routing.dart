// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_apis/places.dart';
import 'package:she_secure/colors.dart';
import '../../keys.dart';

class RoutingWidget extends StatefulWidget {
  const RoutingWidget({
    Key? key,
    this.startLoc,
    this.destLoc,
  }) : super(key: key);
  final startLoc;
  final destLoc;
  static const routeName = '/routing';

  @override
  State<RoutingWidget> createState() => _RoutingwidgetState();
}

class _RoutingwidgetState extends State<RoutingWidget> {
  var sessionToken = 'xyzabc_1234';
  late GoogleMapController mapController;
  final TextEditingController startController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  Map<String, Marker> _markers = {};
  bool isLoading = false;
  bool isLocationLoading = false;
  var searchedLocation;

  @override
  void initState() {
    super.initState();
    startController.text = widget.startLoc["name"];
    destinationController.text = widget.destLoc["name"];
    Marker marker = Marker(
      markerId: MarkerId(""),
      position: LatLng(widget.startLoc["lat"], widget.startLoc["lng"]),
    );
    _markers[widget.startLoc["name"]] = marker;
    marker = Marker(
      markerId: MarkerId(""),
      position: LatLng(widget.destLoc["lat"], widget.destLoc["lng"]),
    );
    _markers[widget.destLoc["name"]] = marker;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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
      searchedLocation = {
        "name": selectedName,
      };
      double zoomLevel = 15.0;
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(lati, longi),
          zoomLevel,
        ),
      );
    });
  }

  @override
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: greyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: startController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Start Location...',
                    ),
                    onChanged: (value) async {
                      // Handle text field changes
                    },
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: destinationController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Destination...',
                    ),
                    onChanged: (value) async {
                      // Handle text field changes
                    },
                  ),
                  if (isLoading)
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
