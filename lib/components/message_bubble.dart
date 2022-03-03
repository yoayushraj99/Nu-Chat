import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {Key? key, required this.text, required this.sender, required this.isMe})
      : super(key: key);

  final String text;
  final String sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              sender,
              style: const TextStyle(fontSize: 12.0, color: Colors.black54),
            ),
            Material(
              borderRadius: BorderRadius.only(
                  topLeft: isMe ? const Radius.circular(30.0) : Radius.zero,
                  topRight: isMe ? Radius.zero : const Radius.circular(30.0),
                  bottomLeft: const Radius.circular(30.0),
                  bottomRight: const Radius.circular(30.0)),
              elevation: 5.0,
              color: isMe ? Colors.lightBlueAccent : Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: Text(
                  text,
                  style: TextStyle(
                      fontSize: 17.0,
                      color: isMe ? Colors.white : Colors.black54),
                ),
              ),
            ),
          ],
        ));
  }
}