import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:she_secure/common/widgets/common_snackbar.dart';

class FourInputFieldsWidget extends StatefulWidget {
  @override
  State<FourInputFieldsWidget> createState() => _FourInputFieldsWidgetState();
}

class _FourInputFieldsWidgetState extends State<FourInputFieldsWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController issueController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  void onSubmit() async {
    try {
      await FirebaseFirestore.instance.collection('reports').add({
        'name': nameController.text.trim(),
        'date': dateController.text.trim(),
        'issue': issueController.text.trim(),
        "location": locationController.text.trim(),
      });
      showsnackbar(context: context, msg: "added report");
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: issueController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => onSubmit(),
              child: const Text('Add report'),
            ),
          ],
        ),
      ),
    );
  }
}
