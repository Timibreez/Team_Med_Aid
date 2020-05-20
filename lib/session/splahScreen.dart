import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//pages
import 'package:team_med/general/homePage.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {



  pushdoctorhome()  {
    _auth.currentUser().then((current){
      if(current!= null){

        var currentuserid= current.uid.toString();

        Firestore.instance.document('doctor/$currentuserid').get().then((DocumentSnapshot) async {
          String name = await DocumentSnapshot.data['name'].toString();
          String email = await DocumentSnapshot.data['email'].toString();
          String image = await DocumentSnapshot.data['image'].toString();


          Timer(Duration(seconds: 3), () {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>HomePage(name: name, email: email,image: image,)), (Route<dynamic> route) => false);
          });

        });

      }});

  }

  pushuserhome(){
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>HomePage(name: '', email: '', image: 'https://cdn1.iconfinder.com/data/icons/instagram-ui-glyph/48/Sed-10-512.png',)), (Route<dynamic> route) => false);
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth.currentUser().then((current){
      if(current!= null){

        pushdoctorhome();


      }else {

        Timer(Duration(seconds: 3), () => pushuserhome());
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.blueAccent),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.local_hospital,
                        color: Colors.white,
                        size: 70.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),

                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(backgroundColor: Colors.white,),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),

                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}



