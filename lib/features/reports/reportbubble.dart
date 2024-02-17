// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:she_secure/colors.dart';

class ReportBubble extends StatelessWidget {
  final String message;
  final String name;
  final String location;
  final String date;
  const ReportBubble({
    required this.location,
    required this.message,
    required this.name,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      // ignore: sort_child_properties_last
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: blackColor,
                borderRadius: BorderRadius.circular(
                  20,
                ),
              ),
              width: 140,
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    location,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
      clipBehavior: Clip.none,
    );
  }
}
