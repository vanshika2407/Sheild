import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:she_secure/common/widgets/loader.dart';

class SafeSpacesScreen extends StatefulWidget {
  const SafeSpacesScreen({Key? key}) : super(key: key);
  static const routeName = '/safe-spaces';

  @override
  State<SafeSpacesScreen> createState() => _SafeSpacesScreenState();
}

class _SafeSpacesScreenState extends State<SafeSpacesScreen> {
  late GoogleMapController mapController;
  List<Marker> _markers = [];
  late Position _position;
  bool isLocationLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _getUserLocation() async {
    _position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    var url =
        "http://10.0.2.2/police?latitude=${_position.latitude}&longitude=${_position.longitude}";

    try {
      debugPrint("sending");
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        debugPrint("jsondedcode:");
        debugPrint(response.body.toString());
        parseDataAndCreateMarkers(jsonDecode(response.body));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void parseDataAndCreateMarkers(dynamic responseData) {
    final List<dynamic> allP = responseData['placeIdsP'];
    debugPrint("\nallP = $allP\n");

    for (var place in allP) {
      final lat = place['latitude'] as double;
      final lng = place['longitude'] as double;
      final name = place['name'] as String;
      final rating = place['rating'] as double;
      final marker = Marker(
        markerId: MarkerId(name),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
          title: name,
          snippet: 'Rating: $rating',
        ),
      );

      setState(() {
        _markers.add(marker);
      });
    }

    setState(() {
      isLocationLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Safe Spaces"),
      ),
      body: isLocationLoading
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _position.latitude,
                  _position.longitude,
                ),
                zoom: 15,
              ),
              markers: Set<Marker>.of(_markers),
            ),
    );
  }
}
