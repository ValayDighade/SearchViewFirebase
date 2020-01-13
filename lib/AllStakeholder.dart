import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/Dashboard.dart';
import 'package:toast/toast.dart';

import 'AssignTask.dart';

class AllStakeholder extends StatefulWidget {
  @override
  _AllStakeholderState createState() => _AllStakeholderState();
}

class _AllStakeholderState extends State<AllStakeholder> {
  final fromkey = new GlobalKey<FormState>();
  final taskAdd = new GlobalKey<FormState>();
  TextEditingController _Namecontroller = TextEditingController();
  TextEditingController _Descontroller = TextEditingController();
  TextEditingController _Phonecontroller = TextEditingController();
  TextEditingController _Emailcontroller = TextEditingController();
  TextEditingController _Addrescontroller = TextEditingController();
  TextEditingController _taskCompleteDate = TextEditingController();
  TextEditingController _taskRemindarDate = TextEditingController();
  final db = Firestore.instance;
  bool _saving=false;
  Color c=Color(0xFFF8F8EC);
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String stringValue;
  String finalID;


  @override
  void initState() {
    // TODO: implement initState
    getValuesSF();

    super.initState();
  }


  getValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String

    setState(() {
      stringValue = prefs.getString('stringValue');
      finalID=stringValue;

    });



    print(finalID+": i got id");



  }



  @override
  Widget build(BuildContext context) {

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return WillPopScope(
      // onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            /* leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
              )
            ),*/
            title: Text("All Stakeholder"),
            backgroundColor:Color(0xFF00606F),
          ),

          floatingActionButton: GestureDetector(
            onTap: (){
              _AddTaskToDbDialog();
            },
            child: SizedBox(
              height: 50,
              child: CircleAvatar(
                foregroundColor:Color(0xFF009DBD),
                child: Icon(

                  Icons.add,
                  color: Colors.black,

                ),),
            ),
          ),
          body: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(
                    height: h/1.15,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance.collection('SalesPersonInformation').where('Cid',isEqualTo: finalID).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError)
                          return new Text('Error: ${snapshot.error}');
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting: return new Text('Loading...');
                          default:
                            return new ListView(
                              children: snapshot.data.documents.map((DocumentSnapshot document) {
                                return GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => AssignTask(docID:document.documentID,
                                          name:document['Name'],Designation: document['Designation'],phone: document['MobileNo'],)),
                                      );
                                    });


                                  },
                                  child: Padding(
                                    padding:  EdgeInsets.only(top:h/70,left: w/30,right: w/30),
                                    child: SizedBox(
                                      height: h/12,
                                      child: new Card(
                                        color:c,
                                        child: Padding(
                                          padding:  EdgeInsets.only(top:h/70,left: w/20),
                                          child: new Text(document['Name'].toUpperCase(),
                                            style: TextStyle(fontSize: h/33,color: Colors.black),
                                            textAlign: TextAlign.left,

                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                        }
                      },
                    ),
                  )

                ],
              )
            ],
          ),
        ),
      ),
    );
  }


  validate(){
    if (fromkey.currentState.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      AddDataToFirebase();
    }
    else{
      print("error");
    }
  }





  _AddTaskToDbDialog() {

    showDialog<void>(
        context: context,
        //  barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          double h = MediaQuery.of(context).size.height;
          double w = MediaQuery.of(context).size.width;

          return StatefulBuilder(
              builder: (context,setState)
              {
                return ModalProgressHUD(
                  inAsyncCall: _saving,
                  opacity: 0.5,
                  progressIndicator: SpinKitFadingCircle(
                    color: Color(0xFF765d93),
                    size: 100,
                  ),
                  child: AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0))),

                      content: SingleChildScrollView(
                          child: Container(
                            //width: w/10,
                              height: h / 1.3,

                              child: Form(
                                  key: fromkey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Text("Add Data",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                      Divider(),
                                      new TextFormField(
                                        controller: _Namecontroller,
                                        decoration: new InputDecoration(
                                            labelText: "Enter Name",
                                            fillColor: Colors.white,

                                            border: new OutlineInputBorder(
                                              borderRadius: new BorderRadius.circular(5.0),
                                              borderSide: new BorderSide(
                                              ),
                                            ),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 5)
                                          //fillColor: Colors.green
                                        ),
                                        validator: (val) {
                                          if(val.length==0) {
                                            return "Name cannot be empty";
                                          }else{
                                            return null;
                                          }
                                        },

                                      ),
                                      new TextFormField(
                                        controller: _Descontroller,
                                        decoration: new InputDecoration(
                                            labelText: "Enter Designation",
                                            fillColor: Colors.white,
                                            border: new OutlineInputBorder(
                                              borderRadius: new BorderRadius.circular(5.0),
                                              borderSide: new BorderSide(
                                              ),
                                            ),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 5)
                                          //fillColor: Colors.green
                                        ),
                                        validator: (val) {
                                          if(val.length==0) {
                                            return "Designation cannot be empty";
                                          }else{
                                            return null;
                                          }
                                        },

                                      ),

                                      new TextFormField(
                                        controller: _Phonecontroller,
                                        keyboardType: TextInputType.phone,
                                        maxLength: 10,
                                        decoration: new InputDecoration(
                                            labelText: "Enter Phone No",
                                            counterText: "",
                                            fillColor: Colors.white,
                                            border: new OutlineInputBorder(
                                              borderRadius: new BorderRadius.circular(5.0),
                                              borderSide: new BorderSide(
                                              ),
                                            ),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 5)
                                          //fillColor: Colors.green
                                        ),
                                        validator: (String value) {
                                          if (value.isEmpty) {
                                            return "Enter Mobile No";
                                          } else if (value.length < 10) {
                                            return "Please Enter 10 Digit mobile No";
                                          } else {
                                            return null;
                                          }
                                        },

                                      ),
                                      new TextFormField(
                                        controller: _Emailcontroller,
                                        keyboardType: TextInputType.emailAddress,
                                        decoration: new InputDecoration(
                                            labelText: "Enter Email",
                                            fillColor: Colors.white,
                                            border: new OutlineInputBorder(
                                              borderRadius: new BorderRadius.circular(5.0),
                                              borderSide: new BorderSide(
                                              ),
                                            ),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 5)
                                          //fillColor: Colors.green
                                        ),
                                        validator: (String value) {
                                          Pattern pattern =
                                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                          RegExp regex = new RegExp(pattern);
                                          if (!regex.hasMatch(value))
                                            return 'Enter Valid Email';
                                          else if(value.length==0) {
                                            return "Email cannot be empty";
                                          }
                                          else
                                            return null;


                                        },
                                        /*validator: (val) {
                                          if(val.length==0) {
                                            return "Email cannot be empty";
                                          }else{
                                            return null;
                                          }
                                        },*/

                                      ),
                                      new TextFormField(
                                        controller: _Addrescontroller,
                                        maxLines: 4,
                                        decoration: new InputDecoration(
                                            labelText: "Enter Address",
                                            fillColor: Colors.white,
                                            border: new OutlineInputBorder(
                                              borderRadius: new BorderRadius.circular(5.0),
                                              borderSide: new BorderSide(
                                              ),
                                            ),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 5,vertical: 10)
                                          //fillColor: Colors.green
                                        ),
                                        validator: (val) {
                                          if(val.length==0) {
                                            return "Address cannot be empty";
                                          }else{
                                            return null;
                                          }
                                        },

                                      ),

                                      //FlutterOpenWhatsapp.sendSingleMessage("918179015345", "Hello");
                                      SizedBox(
                                          height: 50,
                                          width: 300,
                                          child:Material(
                                            // color: Colors.green,
                                            child:  RaisedButton(
                                              color: Color(0xFF009DBD),
                                              onPressed: (){
                                                validate();
                                                //
                                              },
                                              // color: Colors.green,
                                              child:Text(
                                                "ADD",style: TextStyle(color: Colors.white,fontSize: 18),
                                              ) ,),

                                          )
                                      )

                                    ],
                                  )
                              ))
                      )
                  ),
                );
              }

          );

        });

  }







  AddDataToFirebase(){
    var now = new DateTime.now();
    var formatter_date = new DateFormat('dd-MM-yyyy');
    var aaa = formatter_date.format(now);




    db.collection('SalesPersonInformation')
        .document()
        .setData(
        {

          'Date':aaa,
          'Name':_Namecontroller.text,
          'Designation':_Descontroller.text,
          'MobileNo':_Phonecontroller.text,
          'Email':_Emailcontroller.text,
          'Address':_Addrescontroller.text,
          'Cid':finalID
        }
    ).then((_){
      Toast.show("Data Added", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      _Namecontroller.text="";
      _Descontroller.text="";
      _Phonecontroller.text="";
      _Emailcontroller.text="";
      _Addrescontroller.text="";

      Navigator.of(context).pop();
      /*pdateTask();
      setState(() {

        setState(() {

          _updateData();


        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FinalBill(taskID: widget.taskID,)),
        );
      });*/

    }
    );
  }


}
