// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:she_secure/common/widgets/loader.dart';

class SafeSpacesScreen extends StatefulWidget {
  const SafeSpacesScreen({super.key});
  static const routeName = '/safe-spaces';

  @override
  State<SafeSpacesScreen> createState() => _SafeSpacesScreenState();
}

class _SafeSpacesScreenState extends State<SafeSpacesScreen> {
  late GoogleMapController mapController;
  Map<String, Marker> _markers = {};
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _initializeMap(double latitude, double longitude) {
    CameraPosition userPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 15,
    );
    mapController.animateCamera(CameraUpdate.newCameraPosition(userPosition));
  }

  late Position _position;
  bool isLocationLoading = false;

  void _getUserLocation() async {
    setState(() {
      isLocationLoading = true;
    });
    _position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    const url = "http://10.0.2.2/";

    try {
      final response = await http.post(Uri.parse(url), body: {
        "lat": _position.latitude,
        "lng": _position.longitude,
      });

      if (response.statusCode == 200) {
        setState(() {
          _markers = jsonDecode(response.body);
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() {
      isLocationLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Safe Spaces"),
      ),
      body: isLocationLoading
          ? LoaderWidget()
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      _position.latitude,
                      _position.longitude,
                    ),
                  ),
                  markers: _markers.values.toSet(),
                ),
              ],
            ),
    );
  }
}
