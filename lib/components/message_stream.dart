import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'message_bubble.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class MessagesStream extends StatelessWidget {
  const MessagesStream({Key? key}) : super(key: key);
  static late User loggedInUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
      _firestore.collection('messages').orderBy('timestamp', descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data!.docs;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final Map<String, dynamic> docs =
          message.data()! as Map<String, dynamic>;
          final messageText = docs['text'];
          final messageSender = docs['sender'];

          final currentUser = loggedInUser.email;

          final messageBubble = MessageBubble(
              text: messageText,
              sender: messageSender,
              isMe: currentUser == messageSender);
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}