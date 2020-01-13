

import 'package:firebase_auth/firebase_auth.dart';


import 'package:flutter/material.dart';

import 'package:task_manager/Dashboard.dart';
import 'package:task_manager/Login/signin.dart';







class PageRouteDecide extends StatefulWidget {
  @override
  _PageRouteDecideState createState() => _PageRouteDecideState();
}

class _PageRouteDecideState extends State<PageRouteDecide> {

  String userID='';
  @override
  void initState() {

    _getCurrentUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  _getCurrentUserName() async {
    await FirebaseAuth.instance.currentUser().then((user) {

     //  userID=user.uid;

      //print(userID+"gottttttttttttt uid");


      if (user != null) {
        print(user.uid.toString());
        print("yes");
        rout_Dashboard(user.uid);
      } else {
        print("no");
        rout_Signin();
      }
    });
  }

  void rout_Dashboard(String uid) async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Dashboard())); //WallPaper
  }

  void rout_Signin() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignIn())); //  AnimatedPositionedWidget
  }
}
