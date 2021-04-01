import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class PostContainer extends StatelessWidget {
  PostContainer({this.email,this.post});
  final String email;
  final String post;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin:EdgeInsets.all(20) ,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(30)
      ),
      width: 180,
     height: 200,

      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(email, style: TextStyle(color: Colors.purple,fontSize: 15),),
          ),
          SizedBox(height: 15,),
          Text(post,style: TextStyle(color: Colors.pink,fontSize: 30)),
        ],
      ),
    );
  }
}
