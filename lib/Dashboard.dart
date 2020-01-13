import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AllStakeholder.dart';
import 'Login/SideDrawerNavgation.dart';

import 'TestSearch.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var getDa;
  var aaa;
  int counter=0;
  Color c=Color(0xFFF6DFC0);
  int newCount=0;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool addButton=false;
  final FirebaseAuth auth = FirebaseAuth.instance;


  @override
  void initState() {
    inputData();

    Firestore.instance
        .collection('LoginUsers')
        .where("type", isEqualTo: "admin")
        .snapshots()
        .listen((data) =>
        data.documents.forEach((doc) {

          addButton=true;


        }));



    Firestore.instance
        .collection('AddTask')
        //.where("topic", isEqualTo: "flutter")
        .snapshots()
        .listen((data) =>
        data.documents.forEach((doc){

          newCount=newCount+doc['Counter'];

        }));


    /*Firestore.instance.collection("user").document(uid).setData({
      "fcmTocken":_key
    },merge: true);

    print(_key);
  });
*/


    getDate();

    super.initState();
  }

  void inputData() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;


    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('stringValue', uid);
    print(uid+"got by shared");
    // here you write the codes to input the data into firestore
  }



  @override
  Widget build(BuildContext context) {

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;





    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          endDrawer: SideDrawer(),

          //backgroundColor: Color(0xFFFFEEE7),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Center(child: Text("Dashboard")),
            backgroundColor:Color(0xFF00606F),
          ),
          body: Stack(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top:60),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top:20),
                        child: GestureDetector(
                          onTap:(){
                           // newCount=0;
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AllStakeholder()),
                            );
                          },
                          child: SizedBox(
                            height: 100,
                            width: 300,
                            child: Card(
                              elevation: 3,
                              color: c,
                              child: Center(child: Text("STAKEHOLDER",
                                style: TextStyle(fontSize: h/25,color: Color(0xFF00606F),),
                              )
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:20),
                        child: GestureDetector(
                          onTap: (){
                          //  newCount=0;
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HomePage()),
                            );
                          },
                          child: SizedBox(
                            height: 100,
                            width: 300,
                            child: Card(
                              elevation: 3,
                              color: c,
                              child: Column(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                children: <Widget>[
                                  Container(
                                   // color: Colors.green,
                                    height: 20,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          width: 200,
                                        ),
                                        newCount==0 ? Container() : Text(newCount.toString(),style: TextStyle(fontSize: h/35,color: Colors.green),) ,
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:  EdgeInsets.only(top:h/45),
                                    child: Center(
                                        child: Text("TASKS",
                                      style: TextStyle(fontSize: h/25,color: Color(0xFF00606F),),
                                    )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  getDate(){

    var now = new DateTime.now();
    var formatter_date = new DateFormat('dd-MM-yyyy');
     aaa = formatter_date.format(now);

    Firestore.instance
        .collection('AddTask')
        .where("type", isEqualTo: "assign")
        .snapshots()
        .listen((data) =>
        data.documents.forEach((doc) {



          setState(() {
            getDa=doc['RemindarDate'];
            //print(aaa+"got date");
            print(getDa+" ::: date");

            if(getDa!=null)
              {
                String did=doc.documentID;
                if(aaa==getDa)
                {

                  Firestore.instance
                      .collection('AddTask')
                      .document(did)
                      .updateData({
                    'Counter':1,
                  }).then((_){
                    //Navigator.of(context).pop();
                  });



                }
                else{
                  print("error");
                }
              }

          });

        }));
  }

  CompareDate(){



  }


}
