import 'package:chat/screens/login_screen.dart';
import 'package:chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'file:///D:/projects/chat/lib/components/reusable_button.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin //
{
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    );
    //animation=CurvedAnimation(parent: controller,curve: Curves.decelerate);
    controller.forward(); //increment the value of the controller
    animation =
        ColorTween(begin: Colors.grey.shade800, end: Colors.purple.shade800).animate(controller);
//    animation.addStatusListener((status) {
//     if(status==AnimationStatus.completed) {
//       controller.reverse(from: 1.0);
//     }
//       else if(status==AnimationStatus.dismissed){
//         controller.forward();
//     }
//
//    });
    controller.addListener(() {
      setState(() {});
      print(animation.value);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: animation.value,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Colors.purple.shade900,
                  Colors.grey.shade500
                ])),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: 60.0,
                    ),
                  ),
                  TypewriterAnimatedTextKit(
                    text: ['Flash chat'],
                    textStyle: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 48.0,
              ),
              ButtonWidget(
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                myColor: Colors.purple.shade800,
                myText: 'Log in',
              ),
              ButtonWidget(
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
                myColor: Colors.purple.shade800,
                myText: 'Register',
              )

            ],
          ),
        ),
      ),
    );
  }
}
