import 'package:chat/components/post_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart';

class Posts extends StatefulWidget {
  Posts({this.loggedInUser});
  final User loggedInUser;
  //////////////////getLoggedinUser
  static String id = 'chats';
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  final TextController = TextEditingController();
  final _firestoreVar = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    String newPost;
    String userMail=widget.loggedInUser.email;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showSlideDialog(
            context: context,
            child: Column(
              children: [
                Container(
                  width: 200,
                  child: TextField(
                    controller: TextController,
                    autofocus: true,
                    onChanged: (value) {
                      setState(() {
                        newPost = value;
                      });
                    },
                  ),
                ),
                FlatButton(
                  child: Text('Add Post',style: TextStyle(color: Colors.white),),
                  color: Colors.purple.shade800,
                  onPressed: () {
                    TextController
                        .clear(); //clears the text fiels when we hit send
                    setState(() {
                      final date = new DateFormat('yyyy.MM.dd HH:mm:ss').format(new DateTime.now());
                      _firestoreVar.collection('posts').doc(date).set({
                        'post': newPost,
                        'email': userMail,
                    });

                    });
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        },
        child: Icon(
          Icons.add,
          size: 30,
        ),
        backgroundColor: Colors.purple.shade800,
      ),
      appBar: AppBar(
        backgroundColor: Colors.purple.shade800,
        title: Text('Feed'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _firestoreVar.collection('posts').snapshots(),
          builder: (context, snapshot) {
           if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.purple.shade800,
                ),
              );
            } else {
              final userData = snapshot.data.docs;
              List<PostContainer> userPosts = [];
              for (var post in userData) {
                final userEmail = post.data()['email'];
                final userPost = post.data()['post'];
                final postContainer = PostContainer(email: userEmail, post: userPost);
                userPosts.add(postContainer);
              }
              return ListView(
                //reverse: true,
                scrollDirection: Axis.horizontal,
                //shrinkWrap: true,
                //to scroll to the new message
                padding: EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 100.0),
                children: userPosts,
              );
            }
          }
          ),

    );
  }
}
