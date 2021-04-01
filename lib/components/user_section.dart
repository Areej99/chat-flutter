import 'package:chat/screens/chat_room.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class UserSection extends StatelessWidget {
  UserSection({this.user});
  final String user;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,MaterialPageRoute(builder: (context) => ChatRoom(theSecondUser: user,),),);
      },
      child: Container(
        height: 70,
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              user,
              style: TextStyle(
                color: Colors.purple.shade800,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
