import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


//pages
import 'package:team_med/custom/customwidgets.dart';
import 'package:team_med/doctor/doctorHome.dart';
import 'package:team_med/session/doctorReg.dart';
import 'package:team_med/general/homePage.dart';


final databaseReference = Firestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class SignPage extends StatefulWidget {
  @override
  _SignState createState() => _SignState();
}

class _SignState extends State<SignPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _success;
  String _userEmail;
  String errorMessage='';
  bool _loading;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LOGIN'),
      ),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[

                      forminput('Email Address', _email),
                      forminput('Password', _password),

                      GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState.validate()) {
                            _loading = true;
                            setState(() {
                              errorMessage='';
                              _signInWithEmailAndPassword();

                            });
                          }
                        },
                        child: Container(
                            alignment: Alignment.center,
                            height: 60.0,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 5.0),
                            decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                boxShadow: [BoxShadow(
                                  color: Color.fromRGBO(191, 175, 178, 3),
                                  blurRadius: 5,
                                )
                                ],
                                borderRadius: BorderRadius.circular(30.0)
                            ),
                            child: Text(
                              'SIGNIN',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(errorMessage),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child:
                        _loading == null
                            ? Text('', style: TextStyle(color: Colors.black),)
                            : CircularProgressIndicator(backgroundColor: Colors.white,),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>  DoctorRegistration()));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Not yet registered!?',

                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                //patientInfo()
              ],
            ),
          ),
        ),
      ),
    );
  }

  pushdoctorhome()  {
    _auth.currentUser().then((current){
      if(current!= null){

        var currentuserid= current.uid.toString();

        Firestore.instance.document('doctor/$currentuserid').get().then((DocumentSnapshot) async {
          String name = await DocumentSnapshot.data['name'].toString();
          String email = await DocumentSnapshot.data['email'].toString();
          String image = await DocumentSnapshot.data['image'].toString();

          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>DoctorHomePage(name: name, email: email, image: image)));
        });

      }});

  }


  void _signInWithEmailAndPassword() async {
    try {
      final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text.trim(),
      )).user;

      if (user != null) {

        setState(() {
          _success = true;
          _userEmail=user.email;
        });
        pushdoctorhome();
      }
    }catch (e) {
      _success = false;
      print(e.code);
      switch (e.code) {
        case "ERROR_INVALID_EMAIL":
          setState(() {errorMessage = "Your email address appears to be malformed.";_loading=null;});
          break;
        case "ERROR_WRONG_PASSWORD":
          setState(() {errorMessage = "Your password is wrong.";_loading=null;});
          break;
        case "ERROR_USER_NOT_FOUND":
          setState(() {
            errorMessage = "User with this email doesn't exist.";_loading=null;});
          break;
        case "ERROR_USER_DISABLED":
          setState(() {errorMessage = "User with this email has been disabled.";_loading=null;});
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          setState(() {errorMessage = "Too many requests. Try again later.";_loading=null;});
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          setState(() {errorMessage = "Signing in with Email and Password is not enabled.";_loading=null;});
          break;
        default:
          setState((){errorMessage = "An undefined Error happened.";_loading=null;});
      }
    }


  }



}



