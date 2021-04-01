import 'package:chat/components/reusable_button.dart';
import 'package:chat/screens/posts_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chats.dart';


  class NavigationScreen extends StatefulWidget {
    NavigationScreen({this.loggedInUser});
    final User loggedInUser;
    @override
    _NavigationScreenState createState() => _NavigationScreenState();
  }

  class _NavigationScreenState extends State<NavigationScreen> with TickerProviderStateMixin {
    AnimationController _controller;
    //double opacityLevel = 1.0;

    // void _changeOpacity() {
    //   setState(() => opacityLevel = opacityLevel == 0 ? 1.0 : 0.0);}

      @override
  void initState() {
        _controller = AnimationController(
            duration: const Duration(seconds: 2),
        vsync: this,);
   // _changeOpacity();
    super.initState();
  }
    @override
    Widget build(BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Colors.purple.shade900,
                Colors.grey.shade500
              ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              ButtonWidget(
                myText: 'Feed',
                myColor: Colors.purple.shade800,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Posts(
                        loggedInUser: widget.loggedInUser,
                      ),
                    ),
                  );
                },
              ),

            // AnimatedOpacity(
            //   opacity: 0.3,
            //   duration: Duration(seconds: 2),
            //   child:
        ButtonWidget(
                myText: 'Chats',
                myColor: Colors.purple.shade800,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Chats(
                        loggedInUser: widget.loggedInUser,
                      ),
                    ),
                  );
                },
              ),

          ],
        ),
      );
    }
  }




