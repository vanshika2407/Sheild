// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_apis/places.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:she_secure/colors.dart';
import 'package:she_secure/common/widgets/common_snackbar.dart';
import 'package:she_secure/features/navigation/option_widget.dart';
import '../../keys.dart';
import 'widgets/draggablesection.dart';

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
  bool isLoading = false;
  bool isLocationLoading = false;
  var searchedLocation;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      _getUserLocation();
    } else if (status.isDenied) {
      showsnackbar(
        context: context,
        msg: "Location permission is required for this app.",
      );
    } else if (status.isPermanentlyDenied) {
      showsnackbar(
        context: context,
        msg:
            "Location permission is permanently denied. Please enable it in app settings.",
      );
    }
  }

  void _getUserLocation() async {
    setState(() {
      isLocationLoading = true;
    });
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      isLocationLoading = false;
      final Marker marker = Marker(
        markerId: MarkerId("user_location"),
        position: LatLng(position.latitude, position.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
      _markers["user_location"] = marker;
      _initializeMap(position.latitude, position.longitude);
    });
  }

  void _initializeMap(double latitude, double longitude) {
    CameraPosition userPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 15,
    );
    mapController.animateCamera(CameraUpdate.newCameraPosition(userPosition));
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
              if (isLocationLoading)
                Center(
                  child: CircularProgressIndicator(),
                ),
              if (!isLocationLoading)
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
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search...',
                        ),
                        onChanged: (value) async {
                          setState(() {
                            isLoading = true;
                          });
                          var res = await places.autocomplete(
                            destinationController.text,
                            sessionToken: sessionToken,
                          );
                          // print("prediction: $res");
                          if (res.isOk && !res.hasNoResults) {
                            List newOpt = [];
                            for (var p in (res.predictions ?? [])) {
                              final placeId = p.placeId;
                              if (placeId == null) return;
                              var details = await places.getDetailsByPlaceId(
                                placeId,
                                sessionToken: sessionToken,
                              );
                              newOpt.add(details.result);
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
                    decoration: BoxDecoration(),
                    width: size.width * 0.9,
                    margin: EdgeInsets.only(left: size.width * 0.05, top: 10),
                    child: OptionsWidget(
                      opt: opt,
                      onOptionSelected: _onOptionSelected,
                    ),
                  ),
                ),
              if (searchedLocation != null)
                GestureDetector(
                  child: CDraggable(
                    title: searchedLocation["name"],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
