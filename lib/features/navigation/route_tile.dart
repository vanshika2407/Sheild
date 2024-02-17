// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

class RouteTile extends StatelessWidget {
  final String distance;
  final String duration;
  final Function onTap;

  const RouteTile({
    Key? key,
    required this.distance,
    required this.duration,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Distance: $distance'),
      subtitle: Text('Duration: $duration'),
      onTap: () => onTap(),
    );
  }
}
