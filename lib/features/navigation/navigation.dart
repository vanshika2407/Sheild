// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Navigationwidget extends StatefulWidget {
  const Navigationwidget({super.key});

  static const routeName = '/navigation';

  @override
  State<Navigationwidget> createState() => _NavigationwidgetState();
}

class _NavigationwidgetState extends State<Navigationwidget> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(19.20626, 72.873666),
            ),
          ),
        ),
      ),
    );
  }
}
