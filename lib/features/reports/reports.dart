import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:she_secure/features/reports/new_report.dart';
import 'package:she_secure/features/reports/reportbubble.dart';

import '../community/widgets/chat/message_bubble.dart';

class ReportsWidget extends ConsumerWidget {
  const ReportsWidget({super.key});

  static const routeName = '/reports-page';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('reports')
            .orderBy(
              'createdAt',
              descending: true,
            )
            .snapshots(),
        builder: (ctx, chatSnapshot) {
          if (chatSnapshot.hasError) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!chatSnapshot.hasData) {
            return Center(
              child: Text('No data Available'),
            );
          }
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final chatDocs = chatSnapshot.data!.docs;
          return ListView.builder(
            reverse: true,
            itemBuilder: (ctx, index) => ReportBubble(
              name: chatDocs[index].data()['name'],
              date: chatDocs[index].data()['date'],
              message: chatDocs[index].data()['message'],
              location: chatDocs[index].data()['location'],
            ),
            itemCount: chatDocs.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => FourInputFieldsWidget()));
      }),
    );
  }
}
