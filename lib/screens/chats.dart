import 'package:chat/components/user_section.dart';
import 'package:chat/screens/chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat/data.dart';
import 'package:provider/provider.dart';

class Chats extends StatefulWidget {
  Chats({this.loggedInUser});
  final User loggedInUser;
  static String id = 'chats';
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final _firestoreVar = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chats',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 35, color: Colors.white),
        ),
        backgroundColor: Colors.purple.shade800,
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestoreVar.collection('users').snapshots(),
          builder: (context, snapshot) {
            //fluutter async snapshot //builder rebuilds the ui with info we provide
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.purple.shade800,
                ),
              );
            }
            else {
              final userEmails = snapshot.data.docs; //gets the last message
              List<UserSection> UserChats = [];
              for (var email in userEmails) {
                final userEmail = email.data()['email'];
                final userName = email.data()['name'];
                // ignore: missing_return

                if (userEmail != widget.loggedInUser.email) {
                  final userSection = UserSection(
                    user: userEmail,
                  );

                  UserChats.add(userSection);
                }
              }
              return Flex(
                direction: Axis.vertical,
                children: [
                 Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    //to scroll to the new message
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 20.0),
                    children: UserChats,
                  ),
                ),
                ],
              );
            }
          }
        ),

      ),
    );
  }
}
