import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  ButtonWidget({this.myText,this.myColor,this.onPressed});
  final String myText;
  final Color myColor ;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: myColor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: () {
            onPressed();

//Go to login screen.
          },
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            myText,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

