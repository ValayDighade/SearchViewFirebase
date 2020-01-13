import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewAssignTask extends StatefulWidget {
  @override
  _ViewAssignTaskState createState() => _ViewAssignTaskState();
}

class _ViewAssignTaskState extends State<ViewAssignTask> {
  Color c=Color(0xFFF8F8EC);
  @override
  Widget build(BuildContext context) {

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("View Task"),
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('AddTask').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting: return new Text('Loading...');
                default:
                  return new ListView(
                    children: snapshot.data.documents.map((DocumentSnapshot document) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                         // height: 100,
                          child: Card(

                            child: new ListTile(
                             // title: new Text(document['Name']),
                              subtitle: Column(

                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:  EdgeInsets.only(top:8.0),
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'Assignee : ',
                                        style: TextStyle(fontSize: h/37,color: Colors.black),
                                        children: <TextSpan>[
                                          TextSpan(text: document['Name'],style: TextStyle(fontSize: h/40),),

                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:  EdgeInsets.only(top:8.0),
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'Date : ',
                                        style: TextStyle(fontSize: h/37,color: Colors.black),
                                        children: <TextSpan>[
                                          TextSpan(text: document['TaskCompletionDate'],style: TextStyle(fontSize: h/40),),

                                        ],
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding:  EdgeInsets.only(top:8.0),
                                    child: new Text(document['Description'],style: TextStyle(fontWeight: FontWeight.w400),),
                                  ),
                                ],
                              ),

                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
              }
            },
          )
        ],
      ),
    );
  }
}
