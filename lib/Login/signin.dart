import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'package:task_manager/Dashboard.dart';



class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => new _SignInState();
}

class _SignInState extends State<SignIn> {
  String uid;
  String name;
  String mtoken;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final db =Firestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
 /* void inputData() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;


    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('stringValue', uid);
    print(uid);
    // here you write the codes to input the data into firestore
  }
*/

  void routing() async {

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Dashboard()));
  }

  bool p = false;

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    FirebaseUser user = (await _auth.signInWithCredential(credential)).user ;
    uid = user.uid;
    name = user.displayName;
    print("----signedin--------" + user.displayName);
    print(user.phoneNumber);
    print('----gotmobileNo----');

    print(uid);
    print('----got UID-----');

    if(uid != null){

      db.collection('LoginUsers').document(uid).setData({

        'cid':uid,
        'email':user.email.toString(),
        'name':user.displayName.toString(),
        'image':user.photoUrl,
        'mobile':user.phoneNumber,

      }).then((_){

        _firebaseMessaging.getToken().then((_key){
          Firestore.instance.collection("LoginUsers").document(uid).setData({
            "fcmTocken":_key
          },merge: true);

          print(_key);
        });

      });

      print('two');

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Dashboard()));

    }


    return user;
  }



  @override
  void initState() {
    // TODO: implement initState
    if (FirebaseAuth.instance.currentUser() != null) {
      Future.delayed(Duration(seconds: 2), () {
        _googleSignIn.signOut();
        FirebaseAuth.instance.signOut();
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Hero(tag: 'btn2', child: Container(
          color: Colors.white,

          child: Stack(

            children: <Widget>[
              Container(

              ),


              Column(
                children: <Widget>[
                  Expanded(child: Container(
                    color: Colors.transparent,

                  ),
                    flex: 8,

                  ),
                  Expanded(child: Container(
                    color: Colors.white30,
                    child: Center(
                      child:Container(
                        height: 100.0,

                        child:  Column(
                          children: <Widget>[
                            SignInButton(

                              Buttons.Google,
                              onPressed: () {


                                _handleSignIn()
                                    .then((FirebaseUser user) => routing())
                                    .catchError((e) => print(e));

                                setState(() {
                                  p=true;
                                });

                              },
                            ),
                            Container(child: p==true ? Center(child: CircularProgressIndicator(),):null ),

                          ],
                        ),
                      ),
                      /*RaisedButton(
                          onPressed: () {
                            _handleSignIn()
                                .then((FirebaseUser user) => routing())
                                .catchError((e) => print(e));
                          },
                          child: Text("click"),


                        )*/
                    ),

                  ),
                    flex: 2,


                  )

                ],

              ),




            ],
          ),
        )),
        onWillPop: null);
  }
}
