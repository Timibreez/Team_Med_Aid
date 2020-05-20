import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:team_med/custom/customwidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path ;


import 'package:team_med/general/homePage.dart';



final databaseReference = Firestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class DoctorRegistration extends StatefulWidget {
  @override
  _DoctorRegistrationState createState() => _DoctorRegistrationState();
}

class _DoctorRegistrationState extends State<DoctorRegistration> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _token = TextEditingController();
  final TextEditingController _hospital = TextEditingController();
  final TextEditingController _fullname = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _specialty = TextEditingController();

  File galleryFile;
  String errorMessage='';
  bool _success;
  bool monday = false;
  bool tuesday = false;
  bool wednesday = false;
  bool thursday = false;
  bool friday = false;
  bool saturday = false;
  bool sunday = false;
  bool _loading;
  String message='';



  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("Doctor Registration"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.only(left: 120.0, right: 120.0),
              child: Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap:(){




                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 140.0,
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: galleryFile == null
                          ? new Text('')
                          : new Image.file(galleryFile, fit: BoxFit.contain,),
                    ),
                  ),

                  GestureDetector(
                    onTap:(){
                      pickDoctorImage();
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 110),
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 29,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    forminput('Fullname', _fullname),
                    forminput('TOKEN', _token),
                    forminput('Email', _email),
                    forminput('Password', _password),
                    forminput('Hospital', _hospital),
                    forminput('Specialty', _specialty),
                    SizedBox(
                      height: 10,
                    ),

                    Text('Oncall Days', style: TextStyle(fontWeight: FontWeight.bold),),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 80,
                            height:80,
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  sunday == true ? sunday = false : sunday = true;
                                });
                              },
                              child: sunday == false ? Card(
                                elevation: 5,
                                color: Colors.white,
                                child: Center(child: Text('Sunday')),
                              ) : Card(
                                elevation: 5,
                                color: Colors.purple,
                                child: Center(child: Text('Sunday', style: TextStyle(color: Colors.white),)),
                              ),
                            ),
                          ),
                          Container(
                            width: 80,
                            height:80,
                              child: GestureDetector(
                                onTap: (){
                                  setState(() {
                                    monday == true ? monday = false : monday = true;
                                  });
                                },
                                child: monday == false ? Card(
                                  elevation: 5,
                                  color: Colors.white,
                                  child: Center(child: Text('Monday')),
                                ) : Card(
                                  elevation: 5,
                                  color: Colors.purple,
                                  child: Center(child: Text('Monday', style: TextStyle(color: Colors.white),)),
                                ),
                              )
                          ),
                          Container(
                            width: 80,
                            height:80,
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  tuesday == true ? tuesday = false : tuesday = true;
                                });
                              },
                              child: tuesday == false ? Card(
                                elevation: 5,
                                color: Colors.white,
                                child: Center(child: Text('Tuesday')),
                              ) : Card(
                            elevation: 5,
                            color: Colors.purple,
                            child: Center(child: Text('Tuesday', style: TextStyle(color: Colors.white),)),
                              ),
                            ),
                          ),
                          Container(
                            width: 90,
                            height:80,
                              child: GestureDetector(
                                onTap: (){
                                  setState(() {
                                    wednesday == true ? wednesday = false : wednesday = true;
                                  });
                                },
                                child: wednesday == false ? Card(
                                  elevation: 5,
                                  color: Colors.white,
                                  child: Center(child: Text('Wednesday')),
                                ) : Card(
                                  elevation: 5,
                                  color: Colors.purple,
                                  child: Center(child: Text('Wednesday', style: TextStyle(color: Colors.white),)),
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 80),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 80,
                            height:80,
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  thursday == true ? thursday = false : thursday = true;
                                });
                              },
                              child: thursday == false ? Card(
                                elevation: 5,
                                color: Colors.white,
                                child: Center(child: Text('Thursday')),
                              ) : Card(
                                elevation: 5,
                                color: Colors.blue,
                                child: Center(child: Text('Thursday', style: TextStyle(color: Colors.white),)),
                              ),
                            ),
                          ),
                          Container(
                            width: 80,
                            height:80,
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  friday == true ? friday = false : friday = true;
                                });
                              },
                              child: friday == false ? Card(
                                elevation: 5,
                                color: Colors.white,
                                child: Center(child: Text('Friday')),
                              ) : Card(
                                elevation: 5,
                                color: Colors.blue,
                                child: Center(child: Text('Friday', style: TextStyle(color: Colors.white),)),
                              ),
                            ),
                          ),

                          Container(
                            width: 80,
                            height:80,
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  saturday == true ? saturday = false : saturday = true;
                                });
                              },
                              child: saturday == false ? Card(
                                elevation: 5,
                                color: Colors.white,
                                child: Center(child: Text('Saturday')),
                              ) : Card(
                                elevation: 5,
                                color: Colors.purple,
                                child: Center(child: Text('Saturday', style: TextStyle(color: Colors.white),)),
                              ),
                            ),
                          ),


                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            errorMessage='';
                            _loading =true;
                            message='';
                          });

                          String doctoken = _token.text.trim();
                          checktoken(doctoken);
//                            _register();
                        }
                      },
                      child: Container(
                          alignment: Alignment.center,
                          height: 60.0,
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 5.0),
                          decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              boxShadow: [BoxShadow(
                                color: Color.fromRGBO(191,175,178, 3),
                                blurRadius: 5,
                              )],
                              borderRadius: BorderRadius.circular(30.0)
                          ),
                          child: Text(
                                'LOGIN',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
            ),

            SizedBox(
              height: 5,
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child:
              _loading == null
                  ? Text('')
                  : CircularProgressIndicator(),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(message, style: TextStyle(color: Colors.red),)
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(errorMessage)
            ),
            SizedBox(
              height: 5,
            ),

          ],
        ),
      ),
    );
  }

  checktoken(String token) async{
    List tokens = [];
    QuerySnapshot snapshoot = await databaseReference.collection('tokens').getDocuments();
    tokens = snapshoot.documents.map((docSnapshot){
      return docSnapshot.documentID;
    }).toList();
    if(tokens.contains(token)){
      _register();
    }else{
      setState(() {
        message = "Token not authorized";
        _loading = null;
      })
      ;}
  }

  pushdoctorhome()  {
    _auth.currentUser().then((current){
      if(current!= null){

        var currentuserid= current.uid.toString();

        Firestore.instance.document('doctor/$currentuserid').get().then((DocumentSnapshot) async {
          String name = await DocumentSnapshot.data['name'].toString();
          String email = await DocumentSnapshot.data['email'].toString();
          String image = await DocumentSnapshot.data['image'].toString();

          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>HomePage(name: name, email: email, image: image)), (Route<dynamic> route) => false);
        });

      }});

  }



  Future<Widget> pickDoctorImage() async {

    galleryFile = await ImagePicker.pickImage(source: ImageSource.gallery, );
  }


  void createDoctorRecord(String doctoruid, String doctorimage) async {


      await databaseReference.collection('doctor')
          .document(doctoruid)
          .setData({
        'name': _fullname.text.trim(),
        'token': _token.text.trim(),
        'email': _email.text.trim(),
        'password':_password.text.trim(),
        'hospital': _hospital.text.trim(),
        'specialty': _specialty.text.trim(),
        'image': doctorimage,

    });
      String specialty = _specialty.text.trim().toString();

      if(sunday){
        await databaseReference.collection('specialty')
            .document(specialty)
            .collection('Sunday')
            .document(doctoruid)
            .setData({
          'name': _fullname.text.trim(),
          'token': _token.text.trim(),
          'email': _email.text.trim(),
          'password':_password.text.trim(),
          'hospital': _hospital.text.trim(),
          'specialty': _specialty.text.trim(),
          'image': doctorimage,

        });
      }

      if(monday){
        await databaseReference.collection('specialty')
            .document(specialty)
            .collection('Monday')
            .document(doctoruid)
            .setData({
          'name': _fullname.text.trim(),
          'token': _token.text.trim(),
          'email': _email.text.trim(),
          'password':_password.text.trim(),
          'hospital': _hospital.text.trim(),
          'specialty': _specialty.text.trim(),
          'image': doctorimage,

        });
      }

      if(tuesday){
        await databaseReference.collection('specialty')
            .document(specialty)
            .collection('Tuesday')
            .document(doctoruid)
            .setData({
          'name': _fullname.text.trim(),
          'token': _token.text.trim(),
          'email': _email.text.trim(),
          'password':_password.text.trim(),
          'hospital': _hospital.text.trim(),
          'specialty': _specialty.text.trim(),
          'image': doctorimage,

        });
      }

      if(wednesday){
        await databaseReference.collection('specialty')
            .document(specialty)
            .collection('Wednesday')
            .document(doctoruid)
            .setData({
          'name': _fullname.text.trim(),
          'token': _token.text.trim(),
          'email': _email.text.trim(),
          'password':_password.text.trim(),
          'hospital': _hospital.text.trim(),
          'specialty': _specialty.text.trim(),
          'image': doctorimage,

        });
      }

      if(thursday){
        await databaseReference.collection('specialty')
            .document(specialty)
            .collection('Thursday')
            .document(doctoruid)
            .setData({
          'name': _fullname.text.trim(),
          'token': _token.text.trim(),
          'email': _email.text.trim(),
          'password':_password.text.trim(),
          'hospital': _hospital.text.trim(),
          'specialty': _specialty.text.trim(),
          'image': doctorimage,

        });
      }

      if(friday){
        await databaseReference.collection('specialty')
            .document(specialty)
            .collection('Friday')
            .document(doctoruid)
            .setData({
          'name': _fullname.text.trim(),
          'token': _token.text.trim(),
          'email': _email.text.trim(),
          'password':_password.text.trim(),
          'hospital': _hospital.text.trim(),
          'specialty': _specialty.text.trim(),
          'image': doctorimage,

        });
      }

      if(saturday){
        await databaseReference.collection('specialty')
            .document(specialty)
            .collection('Saturday')
            .document(doctoruid)
            .setData({
          'name': _fullname.text.trim(),
          'token': _token.text.trim(),
          'email': _email.text.trim(),
          'password':_password.text.trim(),
          'hospital': _hospital.text.trim(),
          'specialty': _specialty.text.trim(),
          'image': doctorimage,

        });
      }





      pushdoctorhome();


  }

  Future uploadFile(String doctoruid) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('doctor/${Path.basename(galleryFile.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(galleryFile);
    await uploadTask.onComplete;
    print('Uploaded');
    storageReference.getDownloadURL().then((fileURL) async {

        String uploadedFileURL = fileURL;
        print(uploadedFileURL);
        await createDoctorRecord(doctoruid, uploadedFileURL);



    });
  }


  void _register() async {
    try{
        final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text.trim(),
        )).user;
      if (user != null) {
        setState(() {
          _success = true;

        });
        _signInWithEmailAndPassword();
      } else {
        _success = false;
      }
    }catch(e) {
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

  void _signInWithEmailAndPassword() async {
    try {
      final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text.trim(),
      )).user;


      if (user != null) {

        _auth.currentUser().then((current) async {

          if(current.uid != null){

            setState(() {
              _success = true;
            });

            await uploadFile(current.uid.toString());
          }
        });


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



