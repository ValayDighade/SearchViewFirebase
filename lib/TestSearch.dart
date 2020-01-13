import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = new TextEditingController();
  //List customers = [];

  List<UserDetails> _searchResult = [];

  List<UserDetails> _userDetails = [];
  String stringValue;
  String finalID;
  Color c=Color(0xFFF8F8EC);

/*
  // Get json result and convert it to model. Then add
  Future<Null> getUserDetails() async {
    final response = await http.get(url);
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map user in responseJson) {
        _userDetails.add(UserDetails.fromJson(user));
      }
    });
  }
*/



  @override
  void initState() {
    // TODO: implement initState

    getValuesSF();
    //getUserDetails();

    Firestore.instance
        .collection('AddTask')
        .where("cid", isEqualTo:finalID)
        .snapshots()
        .listen((data) =>
        data.documents.forEach((doc) {


          _userDetails.add(UserDetails(
              email: doc['RemindarDate'],
              firstName: doc['Name'],
              lastName: doc['Description'],

          )
          );

         _userDetails.forEach((f){
           print(f.email);
         });



        }));


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
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Home'),
        elevation: 0.0,
      ),
      body: new Column(
        children: <Widget>[
          new Container(
            color: Theme.of(context).primaryColor,
            child: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Card(
                color: c,
                child: new ListTile(
                  leading: new Icon(Icons.search),
                  title: new TextField(
                    controller: controller,
                    decoration: new InputDecoration(
                        hintText: 'Search', border: InputBorder.none),
                    onChanged: onSearchTextChanged,
                  ),
                  trailing: new IconButton(icon: new Icon(Icons.cancel), onPressed: () {
                    controller.clear();
                    onSearchTextChanged('');
                  },),
                ),
              ),
            ),
          ),
          new Expanded(
            child: _searchResult.length != 0 || controller.text.isNotEmpty
                ? new ListView.builder(
              itemCount: _searchResult.length,
              itemBuilder: (context, i) {
                return new Card(
                  color: c,
                  child: new ListTile(

                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text("Assignee :"),
                            new Text(_searchResult[i].firstName),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text("Date :"),
                            new Text(_searchResult[i].email),
                          ],
                        ),
                        new Text(_searchResult[i].lastName),
                      ],
                    ),
                  ),

                );
              },
            )
                : new ListView.builder(
              itemCount: _userDetails.length,
              itemBuilder: (context, index) {
                return new Card(
                  color: c,
                  child: new ListTile(

                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text("Assignee :"),
                            Text(_userDetails[index].firstName),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text("Date :"),
                            Text(_userDetails[index].email),
                          ],
                        ),
                        new Text(_userDetails[index].lastName),
                      ],
                    ),
                  ),

                );
              },
            ),
          ),
        ],
      ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _userDetails.forEach((userDetail) {
      if (userDetail.firstName.toLowerCase().contains(text.toLowerCase()) ||
          userDetail.lastName.toLowerCase().contains(text.toLowerCase())||
          userDetail.email.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(userDetail);
    });

    setState(() {});
  }
}


//final String url = 'https://jsonplaceholder.typicode.com/users';
class UserDetails {
  //final int id;
  final String firstName, lastName,email;

  UserDetails({this.firstName, this.lastName,this.email});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return new UserDetails(

      firstName: json['name'],
      lastName: json['username'],
      email: json['email'],

    );
  }
}