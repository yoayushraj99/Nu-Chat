import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/message_stream.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  static String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final User? user = _auth.currentUser;
    // if (user!=null && !user.emailVerified) {
    //   await user.sendEmailVerification();
    // }
    if (user != null) {
      MessagesStream.loggedInUser = user;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () async {
                //Implement logout functionality
                await _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // messageText + loggedInUser.email
                      //Implement send functionality
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': MessagesStream.loggedInUser.email,
                        'timestamp': DateTime.now()
                      });
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// void getMessages() async {
//   final messages = await _firestore.collection('messages').get().then(
//       (QuerySnapshot querySnapShot) {
//         return querySnapShot.docs;
//       }
//   );
//   for (var doc in messages) {
//     if (kDebugMode) {
//       print(doc.data());
//     }
//   }
// }
//
// void messagesStream() async {
//   await for (var snapShot in _firestore.collection('messages').snapshots()) {
//     for (var message in snapShot.docs) {
//       if (kDebugMode) {
//         print(message.data());
//       }
//     }
//   }
// }