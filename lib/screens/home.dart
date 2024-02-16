// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:async';

import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/background.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../widgets/draggablesection.dart';
import '../widgets/topsection.dart';


class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home> {
  double top = 0.0;
  double initialTop = 0.0;

  final Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    final baseTop = MediaQuery.of(context).size.height * 0.6;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          BackgroundImage(
            mapWidget: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(48.814716, 2.349014),
                zoom: 12.0,
              ),
            ),
          ),
          TopSection(),
          GestureDetector(
            onPanUpdate: (DragUpdateDetails details) {
              final double scrollPos = details.globalPosition.dy;
              if (scrollPos < baseTop && scrollPos > searchBarHeight) {
                setState(() {
                  top = scrollPos;
                });
              }
            },
            child: DraggableSection(
              top: top == 0.0 ? baseTop : top,
              searchBarHeight: searchBarHeight,
            ),
          ),
        ],
      ),
    );
  }
}
