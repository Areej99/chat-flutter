
import 'package:chat/screens/chat_room.dart';
import 'package:chat/screens/chats.dart';
import 'package:chat/screens/navigation_screen.dart';
import 'package:chat/screens/posts_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chat/screens/welcome_screen.dart';
import 'package:chat/screens/login_screen.dart';
import 'package:chat/screens/registration_screen.dart';
import 'package:chat/screens/chat_screen.dart';
import 'package:provider/provider.dart';
import 'data.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());


}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Data>(
      builder :(BuildContext context) => Data()  ,
      child: MaterialApp(

          debugShowCheckedModeBanner: false,

          initialRoute: WelcomeScreen.id,
          routes: {
            // ignore: missing_return
            WelcomeScreen.id: (context) =>
                WelcomeScreen(),
            // ignore: missing_return
            LoginScreen.id: (context) =>
                LoginScreen(),
            // ignore: missing_return
            RegistrationScreen.id: (context) =>
                RegistrationScreen(),
            // ignore: missing_return
            ChatScreen.id: (context) =>
                ChatScreen(),
            ChatRoom.id: (context) =>
                ChatRoom(),
            Chats.id: (context) =>
                Chats(),
            Posts.id: (context) =>
                Posts()
          }
      ),
    );
  }
}


//   // create an app
//   print('------------------------------------------------------------------');
//
//  // var credential = Credentials.applicationDefault();
//   //credential ??= await Credentials.login();
//
//   // when no credentials found, login using openid
//   // the credentials are stored on disk for later use
//
//   // create an app
//   var app = FirebaseAdmin.instance.initializeApp();
//   print('------------------------------------------------------------------');
//
//   //   // get a user by email
//   //var v = await app.auth().listUsers();
//   print('------------------------------------------------------------------');
//    //print(v);
//   print('------------------------------------------------------------------');
//
// //---------------------------------------------------
