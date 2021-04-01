import 'file:///D:/projects/chat/lib/components/constants.dart';
import 'file:///D:/projects/chat/lib/components/reusable_button.dart';
import 'package:chat/screens/chats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:chat/data.dart';
import 'package:provider/provider.dart';

import 'navigation_screen.dart';
final _firestoreVar = FirebaseFirestore.instance;


class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  Future<bool> checkInternetConnectevity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      return false;
    } else if (result == ConnectivityResult.mobile ||result==ConnectivityResult.wifi ) {
      return true ;
    }



  }
  var _formKey = GlobalKey<FormState>();

  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password;
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
                                } else if (!value.contains('@')||!value.contains('.')) {
                                  return 'please enter a proper email format example@ex.ex';
                                }
                              },
                              keyboardType: TextInputType.emailAddress,
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                setState(() {
                                  email = value;
                                });
//Do something with the user input.
                              },
                              decoration: kInputDecoration.copyWith(
                                  hintText: 'Enter your Email')),
                          SizedBox(
                            height: 8.0,
                          ),
                          TextFormField(
                              // ignore: missing_return

                              obscureText: true, //for password
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                setState(() {
                                  password = value;
                                });

//Do something with the user input.
                              },
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Please enter your password';
                                } else if (value.length < 8) {
                                  return 'password must be more than 8 characters';
                                } //-----------------------------------------------------------------
                                else {
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
                                  hintText: 'Enter your password')),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    ButtonWidget(
                      onPressed: () async {
                        setState(()  {
                          if (_formKey.currentState.validate())
                            showSpinner = true;
                        });
                          bool result =  await  checkInternetConnectevity();
                          if(!result) {
                            setState(() {
                            showSpinner = false;
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
                                )
                            );
                            Scaffold.of(context).showSnackBar(snackBar);
                          });

                                }
                        try {
                          final newUser =
                              await _auth.createUserWithEmailAndPassword(
                                  email: email, password: password);
                          print('$email -------------------------------------------------------------------------------------------------');
                          if (newUser != null) {

                            _firestoreVar.collection('users').add({
                              'email': email
                            });
                            Provider.of<Data>(context).AddUser(email);
                            //---------------------------------------------------------------------------------------------------------------
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return NavigationScreen(loggedInUser:_auth.currentUser);
                            },));
                          }

//Implement registration functionality.
                        }
                          catch (e) {
                          if (e.toString().contains('already in use')) {
                            final snackBar = SnackBar(
                                content: Text(
                                  'this email already exists , try another email',
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
                            setState(() {
                              showSpinner = false;
                            });
                            Scaffold.of(context).showSnackBar(snackBar);
                          }
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      },
                      myColor: Colors.purple.shade800,
                      myText: 'Register',
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
