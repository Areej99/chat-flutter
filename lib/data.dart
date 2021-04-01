import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class Data extends ChangeNotifier{
  List<String> userList=[];
  void AddUser(String email){
    userList.add(email);
    notifyListeners();

  }

}