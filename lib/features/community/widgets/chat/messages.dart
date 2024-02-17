// ignore_for_file: prefer_const_constructors

// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './message_bubble.dart';

class Messages extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        // if (chatSnapshot.hasError) {
        //   return Center(
        //     child: CircularProgressIndicator(),
        //   );
        // }
        // if (!chatSnapshot.hasData) {
        //   return Center(
        //     child: Text('No data Available'),
        //   );
        // }
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = chatSnapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemBuilder: (ctx, index) => MessageBubble(
            chatDocs[index].data()['text'],
            chatDocs[index].data()['userId']==user.uid ,
            chatDocs[index].data()['name'],
            key: ValueKey(chatDocs[index].id),
          ),
          itemCount: chatDocs.length,
        );
      },
    );
  }
}
