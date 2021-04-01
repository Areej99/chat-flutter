import 'package:chat/screens/navigation_screen.dart';
import 'chats.dart';
import 'file:///D:/projects/chat/lib/components/constants.dart';
import 'file:///D:/projects/chat/lib/components/reusable_button.dart';
import 'package:chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
final _firestoreVar = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
String email;
String password;
var _formKey = GlobalKey<FormState>();
class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  // Future<bool> checkInternetConnectevity() async {
  //   var result = await Connectivity().checkConnectivity();
  //   if (result == ConnectivityResult.none) {
  //     return false;
  //   } else if (result == ConnectivityResult.mobile ||result==ConnectivityResult.wifi ) {
  //     return true ;
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Colors.purple.shade900,
                    Colors.grey.shade500
                  ])),
          child: Builder(
            builder: (context) {
              return ModalProgressHUD(
                inAsyncCall: showSpinner,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Flexible(
                        child: Hero(
                          tag: 'logo',
                          child: Container(
                            height: 200.0,
                            child: Image.asset('images/logo.png'),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 48.0,
                      ),
                      Form(
                        key: _formKey,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            TextFormField(
                                // ignore: missing_return
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your email';
                                  } else if (!value.contains('@') ||
                                      !value.contains('.')) {
                                    return 'please enter a proper email format example@ex.ex';
                                  }
                                },
                                keyboardType: TextInputType.emailAddress,
                                textAlign: TextAlign.center,
                                onChanged: (value) {
                                  email = value;
                                },
                                decoration: kInputDecoration.copyWith(
                                    hintText: 'enter your Email')),
                            SizedBox(
                              height: 8.0,
                            ),
                            TextFormField(
                                // ignore: missing_return

                                textAlign: TextAlign.center,
                                obscureText: true,
                                onChanged: (value) {
                                  password = value;
                                  //Do something with the user input.
                                },
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your password';
                                  } else if (value.length < 8) {
                                    return 'password must be more than 8 characters';
                                  } else {
                                    bool hasUpperCase = false;

                                    for (int i = 0; i < value.length; i++) {
                                      if (value[i].toUpperCase() == value[i]) {
                                        hasUpperCase = true;
                                        break;
                                      }
                                    }

                                    return !hasUpperCase
                                        ? 'password must have at least one upper cas character'
                                        : null;
                                  }
                                },
                                decoration: kInputDecoration.copyWith(
                                    hintText: 'enter your password')),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      ButtonWidget(
                        myText: 'Log In',
                        myColor: Colors.purple.shade800,
                        onPressed: () async {
                          var connectResult =
                              await (Connectivity().checkConnectivity());
                          if ((connectResult != ConnectivityResult.wifi) &&
                              (connectResult != ConnectivityResult.mobile)) {
                            final snackBar = SnackBar(
                                content: Text(
                                  'you don\'t have an internet connection',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                backgroundColor: Colors.lightBlueAccent,
                                action: SnackBarAction(
                                  label: 'got it',
                                  textColor: Colors.white,
                                  onPressed: () {
                                    Scaffold.of(context).hideCurrentSnackBar();
                                  },
                                ));
                            Scaffold.of(context).showSnackBar(snackBar);
                          } else {
                            try {
                              setState(()  {
                                showSpinner = true;
                              });
                              if (_formKey.currentState.validate()) {
                                final user =
                                    await _auth.signInWithEmailAndPassword(
                                        email: email, password: password);

                                //Implement login functionality.
                                if (user != null) {

                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return NavigationScreen(loggedInUser:user.user);
                                  },));
                                }
                              }
                              setState(() {
                                showSpinner = false;
                              });
                            } catch (e) {
                              print(e);
                              if (e.toString().contains('no user')) {
                                final snackBar = SnackBar(
                                    content: Text(
                                      'this email doesn\'t exist',
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                    backgroundColor: Colors.lightBlueAccent,
                                    action: SnackBarAction(
                                      label: 'got it',
                                      textColor: Colors.white,
                                      onPressed: () {
                                        Scaffold.of(context)
                                            .hideCurrentSnackBar();
                                      },
                                    ));
                                setState(() {
                                  showSpinner = false;
                                });
                                Scaffold.of(context).showSnackBar(snackBar);
                              }
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}
