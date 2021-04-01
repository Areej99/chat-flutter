import 'package:flutter/material.dart';
import 'package:chat/components/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
final _firestoreVar = FirebaseFirestore.instance;
class MessageStream extends StatelessWidget {
  MessageStream({this.loggedInUser , this.theSecondUser});
  final  User loggedInUser;
  final  String theSecondUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestoreVar.collection('messages').snapshots(),
      //stream: _firestoreVar.collection('messages').orderBy('time',descending: false,).snapshots(),

      // ignore: missing_return
      builder: (context, snapshot) {
        //fluutter async snapshot //builder rebuilds the ui with info we provide
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlue,
            ),
          );
        }
        final messages = snapshot.data.docs.reversed; //gets the last message
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data()['text'];
          // ignore: missing_return
          final messageSender = message.data()['sender'];
          final messageReceiver=message.data()['receiver'];
          final currentUser = loggedInUser.email.trim();
          final wantedUser = theSecondUser;
          if (((messageSender==currentUser)||(messageSender==wantedUser)) && ((messageReceiver==wantedUser)||(messageReceiver== currentUser))) {
            final messageWidget = MessageBubble(
              sender: messageSender,
              text: messageText,
              isMe: currentUser == messageSender,
            );

            messageBubbles.add(messageWidget);
          }
        }
        return Expanded(
          child: ListView(
            reverse: true, //to scroll to the new message
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}