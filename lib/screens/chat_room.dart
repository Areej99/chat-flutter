import 'package:flutter/material.dart';
import 'file:///D:/projects/chat/lib/components/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat/components/message_stream.dart';
import 'package:intl/intl.dart';

User loggedInUser;
final _firestoreVar = FirebaseFirestore.instance;

class ChatRoom extends StatefulWidget {
  ChatRoom({this.theSecondUser});
  final  String theSecondUser;
  static String id = 'chat_room';
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final _auth = FirebaseAuth.instance;
  final messageTextController = TextEditingController();

  String messageText;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }
//----------------------------------------------------------------------------------------------------------
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        setState(() {
          loggedInUser = user;
        });

      }
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
        title: Text(widget.theSecondUser),
        backgroundColor: Colors.purple.shade800,
      ),
      body:
      SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(loggedInUser:loggedInUser , theSecondUser: widget.theSecondUser),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller:
                      messageTextController, //clears the text fiels when we hit send
                      onChanged: (value) {
                        setState(() {
                          messageText = value;
                        });

                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController
                          .clear(); //clears the text fiels when we hit send
                      final date = new DateFormat('yyyy.MM.dd HH:mm:ss').format(new DateTime.now());
                      _firestoreVar.collection('messages').doc(date).set({
                        'text': messageText,
                        'sender': loggedInUser.email,
                        'receiver':widget.theSecondUser
                      });
                      //Implement send functionality.
                    },
                    child: Text(
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


// void getMessages() async{
//  final messages= await _firestoreVar.collection('messages').get();
//  for (var msgs in messages.docs){
//    print(msgs.data()); //gets all the messages
//  }
// }

// void messegesStresm() async{
//   await for (var snapshot in _firestoreVar.collection('messages').snapshots()){
//     for (var msgs in snapshot.docs) {
//       print(msgs.data()); //gets all the messages
//     }
//   } //the stream gets the new changes
// }
