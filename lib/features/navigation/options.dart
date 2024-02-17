// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_apis/places.dart';

import '../../colors.dart';
import '../../keys.dart';
import 'route_tile.dart';

class Options extends StatefulWidget {
  const Options({Key? key, required this.startLoc, required this.destLoc}) : super(key: key);
  final startLoc;
  final destLoc;
  static const routeName = '/options';

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  var sessionToken = 'xyzabc_1234';
  final TextEditingController startController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  bool isLoading = false;
  var routes;
  var searchedLocation;

  final places = GoogleMapsPlaces(apiKey: apiKey);
  List opt = [];

  void _onOptionSelected(String selectedName, double lati, double longi) {
    setState(() {
      destinationController.text = selectedName;
      searchedLocation = {
        "name": selectedName,
        "lat": lati,
        "lng": longi,
      };
    });
  }

  void _fetchRoutes() async {
    setState(() {
      isLoading = true;
    });
    debugPrint("start: thakur college");
    debugPrint("end: ${widget.destLoc["name"]}");
    const url =
        'http://10.0.2.2/routes'; // Replace this with your actual API endpoint

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "origin": "Thakur College of Engineering and Technolgy, Kandivali",
          "destination": widget.destLoc["name"],
        }),
      );
      debugPrint("resp ${response.statusCode.toString()}");
      debugPrint(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        setState(() {
          routes = decodedResponse;
          isLoading = false;
        });
      } else {
        // Handle error
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load routes');
      }
    } catch (error) {
      // Handle error
      setState(() {
        isLoading = false;
      });
      print('Error fetching routes: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    startController.text = widget.startLoc["name"];
    destinationController.text = widget.destLoc["name"];

    _fetchRoutes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
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
          if (routes != null)
            Expanded(
              child: ListView.builder(
                itemCount: routes.length,
                itemBuilder: (context, index) {
                  final route = routes[index];
                  return RouteTile(
                    distance: route['distance'],
                    duration: route['duration'],
                    onTap: () {
                      // Handle route tile tap
                      // For example, you can update the map markers based on the selected route
                      // Or navigate to a new screen to show detailed route information
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
