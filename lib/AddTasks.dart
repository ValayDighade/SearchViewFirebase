import 'package:flutter/material.dart';

class AddTasks extends StatefulWidget {
  @override
  _AddTasksState createState() => _AddTasksState();
}

class _AddTasksState extends State<AddTasks> {
  TextEditingController _Namecontroller = TextEditingController();
  TextEditingController _Descontroller = TextEditingController();
  TextEditingController _Phonecontroller = TextEditingController();
  TextEditingController _Emailcontroller = TextEditingController();
  TextEditingController _Addrescontroller = TextEditingController();
  final fromkey = new GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;


    return Scaffold(
      appBar: AppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: SizedBox(
        height: 50,
        child: CircleAvatar(
          child: Icon(

          Icons.add,

          ),),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Material(
                elevation: 2,
                child: Container(
                  height: h/1.4,
                  child: Form(
                    key: fromkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding:  EdgeInsets.only(left: w/20,right: w/20),
                          child: new TextFormField(
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
                        ),
                        Padding(
                          padding:  EdgeInsets.only(left: w/20,right: w/20),
                          child: new TextFormField(
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
                        ),

                        Padding(
                          padding:  EdgeInsets.only(left: w/20,right: w/20),
                          child: new TextFormField(
                            controller: _Phonecontroller,
                            decoration: new InputDecoration(
                                labelText: "Enter Phone No(Whats App)",
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
                                return "Phone no cannot be empty";
                              }else{
                                return null;
                              }
                            },

                          ),
                        ),
                        Padding(
                          padding:  EdgeInsets.only(left: w/20,right: w/20),
                          child: new TextFormField(
                            controller: _Emailcontroller,
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
                            validator: (val) {
                              if(val.length==0) {
                                return "Email cannot be empty";
                              }else{
                                return null;
                              }
                            },

                          ),
                        ),
                        Padding(
                          padding:  EdgeInsets.only(left: w/20,right: w/20),
                          child: new TextFormField(
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
                                contentPadding: EdgeInsets.symmetric(horizontal: 5)
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
                        ),
                        SizedBox(
                          height: 50,
                          width: 300,
                          child:Material(
                            color: Colors.green,
                            child:  RaisedButton(
                             // color: Colors.green,
                              child:Text(
                                  "ADD",style: TextStyle(color: Colors.white,fontSize: 18),
                              ) ,),

                          )
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
