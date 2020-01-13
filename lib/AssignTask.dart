import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:native_contact_picker/native_contact_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/Dashboard.dart';
import 'package:toast/toast.dart';

class AssignTask extends StatefulWidget {

  String docID;
  String name;
  String Designation;
  String phone;
  AssignTask({Key key, this.docID,this.name,this.Designation,this.phone}) : super(key: key);


  @override
  _AssignTaskState createState() => _AssignTaskState();
}

class _AssignTaskState extends State<AssignTask> {
  final db = Firestore.instance;
  DateTime firstdate;
  var firstConvertedDate;
  bool _saving=false;

  DateTime secondDate;
  var remindarDate;
  final taskAdd = new GlobalKey<FormState>();
  bool monVal = false;
  TextEditingController _address = TextEditingController();
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

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Assign Task"),
          backgroundColor:Color(0xFF00606F),
        ),
        body: ModalProgressHUD(
          inAsyncCall: _saving,
          opacity: 0.5,
          progressIndicator: SpinKitFadingCircle(
            color: Color(0xFF765d93),
            size: 100,
          ),
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                  child: Form(
                      key: taskAdd,
                      child: Padding(
                        padding:  EdgeInsets.only(top:h/20,left: w/20,right: w/20),
                        child: Column(
                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(widget.name.toUpperCase(),style: TextStyle(fontSize: h/25,fontWeight: FontWeight.w600,),),
                            Text(widget.Designation.toUpperCase(),style: TextStyle(fontSize: h/35,fontWeight: FontWeight.w400),),
                            Divider(height: 50,),

                            Row(
                             // crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: (){
                                    _selectStartDate();

                                  },
                                  child: Icon(
                                    Icons.date_range,
                                    size: 50,
                                    color:Color(0xFF009DBD),
                                  ),
                                ),
                                Padding(
                                  padding:  EdgeInsets.only(left:w/40),
                                  child: Container(
                                      height: h/15,
                                      width: w/2,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)
                                      ,border: Border.all(width: 1)
                                      ),
                                      child: Center(
                                          child: firstConvertedDate != null
                                              ? new Text(firstConvertedDate,
                                            style:TextStyle(fontSize: h/35) ,
                                          )
                                              : Text("Task Completion Date"))),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top:h/50),
                              child: Row(

                               // crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: (){
                                      _selectReminderDate();


                                    },
                                    child: Icon(
                                      Icons.date_range,
                                      size: 50,
                                      color:Color(0xFF009DBD),

                                    ),
                                  ),
                                  Padding(
                                    padding:  EdgeInsets.only(left:w/40),
                                    child: Container(
                                        height: h/15,
                                        width: w/2,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5)
                                         ,border: Border.all(width: 1)
                                        ),
                                        child: Center(
                                            child: remindarDate != null
                                                ? new Text(remindarDate,
                                              style:TextStyle(fontSize: h/35) ,
                                            )
                                                : Text("Remindar Date"))),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top:h/50),
                              child: new TextFormField(
                                controller: _address,
                                maxLines: 4,
                                decoration: new InputDecoration(
                                    labelText: "Task Description",
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
                                    return "Task Description cannot be empty";
                                  }else{
                                    return null;
                                  }
                                },

                              ),
                            ),
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.s,
                              children: <Widget>[
                                Checkbox(
                                  value: monVal,
                                  onChanged: (bool value) {
                                    setState(() {
                                      monVal = value;



                                    });
                                  },
                                ),
                                Text("Notify Through Whats App",style: TextStyle(fontSize: 14),),

                              ],
                            ),




                            Padding(
                              padding: EdgeInsets.only(top:h/20),
                              child: SizedBox(
                                  height: 50,
                                  width: 300,
                                  child:Material(
                                    // color: Colors.green,
                                    child:  RaisedButton(
                                      color: Color(0xFF009DBD),
                                      onPressed: (){
                                        setState(() {
                                          _saving=true;
                                        });
                                        validateAddedtask();
                                        //
                                      },
                                      // color: Colors.green,
                                      child:Text(
                                        "SUBMIT",style: TextStyle(color: Colors.white,fontSize: 18),
                                      ) ,),

                                  )
                              ),
                            )

                          ],
                        ),
                      )
                  )
              )
            ],
          ),
        ),
      ),
    );
  }





  validateAddedtask(){
    if (taskAdd.currentState.validate()) {


      if(firstConvertedDate==null)
        {
          Toast.show("Select Task date", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
        }
      else if(remindarDate==null)
        {
          Toast.show("Select Remindar Date", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
        }
      else{
        _saving=true;
        AddDataToFirebase();
      }

      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
     // AddDataToFirebase();
    }
    else{
      print("error");
      _saving=false;
    }
  }
  Future _selectStartDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2019),
        lastDate: new DateTime(2022));
    if (picked != null) {
      setState(() {
        /*_value = picked.toString();
           var formattedDate = "${_value.day}-${date.month}-${date.year}";*/
        firstdate = picked;
        firstConvertedDate = "${firstdate.day}-${firstdate.month}-${firstdate.year}";
      });
    }

    print(firstConvertedDate+" first date");
  }
  Future _selectReminderDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2019),
        lastDate: new DateTime(2022));
    if (picked != null) {
      setState(() {
        /*_value = picked.toString();
           var formattedDate = "${_value.day}-${date.month}-${date.year}";*/
        secondDate = picked;
        remindarDate = "${secondDate.day}-${secondDate.month}-${secondDate.year}";

      });
    }

    print(remindarDate+" second date");
  }



  AddDataToFirebase(){
    var now = new DateTime.now();
    var formatter_date = new DateFormat('dd-MM-yyyy');
    var aaa = formatter_date.format(now);




    db.collection('AddTask')
        .document(widget.docID)
        .setData(
        {

          'TaskCreatedDate':aaa,
          'Name':widget.name,
          'Designation':widget.Designation,
          'TaskCompletionDate':firstConvertedDate,
          'RemindarDate':remindarDate,
          'Description':_address.text,
          'PersonID':widget.docID,
          'type':'assign',
          'Counter':0,
          'cid':finalID
        }
    ).then((_){
      Toast.show("Data Added", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

     // _address.text="";

      Navigator.of(context).pop();

     /* Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );*/


      if(monVal==true){


        FlutterOpenWhatsapp.sendSingleMessage("+91"+widget.phone,
          " Hi,"+widget.name+" You have been assign a task "+_address.text+ " which should be finished by "+ "*" + firstConvertedDate + "*");
      }

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
