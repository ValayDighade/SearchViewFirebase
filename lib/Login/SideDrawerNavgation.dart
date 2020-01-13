
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/Login/signin.dart';



class SideDrawer extends StatefulWidget {
  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {


  String stringValue;
  String finalID;
  String imageuRl;
  String name;
  String email;
  String mobile;
  bool check=false;




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


    if(finalID!=null)
    {
      Firestore.instance
          .collection('LoginUsers')
          .document(finalID)
          .get()
          .then((DocumentSnapshot ds) {
        setState(() {
          imageuRl=ds['image'];
          name=ds['name'];
          email=ds['email'];
          mobile=ds['mobile'];
          check=true;
        });



        print(imageuRl+"ffffffffffffffffffffffff");
        print(name+"ffffffffffffffffffffffff");
        print(email+"ffffffffffffffffffffffff");
        print(mobile);

        // use ds as a snapshot
      });
    }
    //Return bool

  }


  _alertDialog() {
   return showDialog(
      context: context,
      child: new AlertDialog(
        title: new Text('Logout?'),
        content: new Text('Are you sure you want to log out?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
            //  Navigator.of(context).pop();
              Navigator.of(context, rootNavigator: true).pop();

            },

            child: new Text(
              'No',
              style: TextStyle(fontSize: 20),
            ),
          ),
          new FlatButton(
            onPressed: () {

              Navigator.of(context, rootNavigator: true).pop();

              signOutWithGoogle();

            },
            child: new Text(
              'Yes',
              style: TextStyle(fontSize: 20),
            ),

          ),
        ],
      ),
    );
  }

  Future<Null> signOutWithGoogle() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signOut();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SignIn()));



  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
    child: SideDrawer()
    );
  }



  Widget SideDrawer()
  {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    TextStyle t=new TextStyle(fontSize: h/60);




    return  Drawer(

      elevation: 25,

      child: ListView(

        children: <Widget>[
          check==true ? Container(
            height: h/7,


            decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide( //                    <--- top side
                    color: Colors.black,
                    width: 1.0,
                  ),
                )
            ),
            child: Row(

              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                imageuRl!=null ? Expanded(
                  flex: 1,
                  child: Padding(
                    padding:  EdgeInsets.only(left: w/50,top: h/40),
                    child: new Container(
                      width: w/11,
                      height: h/11,
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image:  new NetworkImage(
                                imageuRl)
                        ),
                      ),
                    ),
                  ),
                ) : Container(),

                Expanded(
                  flex: 3,
                  child: Padding(
                    padding:  EdgeInsets.only(top:h/50,left: w/50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,


                      children: <Widget>[
                        Text(name,style: t,),
                        SizedBox(height: 10,),
                        Text(email.toString(),style: t,),
                        SizedBox(height: 10,),
                        mobile!=null ? Text(mobile.toString(),style: t,): Text("Click to edit profile"),
                        SizedBox(height: 10,),

                      ],
                    ),
                  ),
                )
                /*DrawerHeader(

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Valay Dighade"),
                        Text("valay.dighade@creaxt.com"),
                        Text("Profile details",style: TextStyle(color: Colors.blue),),
                      ],
                    ),
                  ),*/
              ],
            ),
          ) : Container(
            height: 150,
          ),

          Divider(),
          GestureDetector(
            onTap: (){
              _alertDialog();
            },
            child: ListTile(
              title: Text("Logout"),
            ),
          )





        ],
      ),


    );
  }

}


