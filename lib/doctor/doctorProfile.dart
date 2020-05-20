import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';


//pages
import 'package:team_med/custom/customwidgets.dart';

final databaseReference = Firestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class DoctorProfilePage extends StatefulWidget {
  final String email;
  final String name;
  final String image;

  DoctorProfilePage({
    this.email, this.name, this.image
  });

  @override
  _DoctorProfilePageState createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _hospital = TextEditingController();
  String token;
  String hospital;
  String specialty;
  String currentuserid;
  bool edit;
  bool monday = false;
  bool tuesday = false;
  bool wednesday = false;
  bool thursday = false;
  bool friday = false;
  bool saturday = false;
  bool sunday = false;

  update() async{
    String newhospital = _hospital.text.toString();

    if(hospital != newhospital){
      await databaseReference.collection('doctor')
          .document(currentuserid)
          .setData({
        'hospital': newhospital,
      }, merge: true);
    }

    List days = ['Sunday','Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    List vardays = [sunday, monday, tuesday, wednesday, thursday, friday, saturday];
    for(var i=0;i<days.length;i++){
      String day = days[i];
      QuerySnapshot querySnapshot = await Firestore.instance.collection("specialty").document(specialty).collection(day).getDocuments();
      var list = querySnapshot.documents;
      if(!(list.isEmpty)){Firestore.instance.collection("specialty").document(specialty).collection(day).document(currentuserid).delete();}
    }

    for(var i=0;i<vardays.length;i++){
      bool active = vardays[i];
      if(active){
        await databaseReference.collection('specialty')
            .document(specialty)
            .collection(days[i])
            .document(currentuserid)
            .setData({
          'name': widget.name,
          'token': token,
          'email': widget.email,
          'hospital': newhospital,
          'specialty': specialty,
          'image': widget.image,

        });
      }
    }

    setState(() {
      hospital = newhospital;
    });
  }

  getdoctorinfo() async{
    final FirebaseUser user = await _auth.currentUser();
    currentuserid = user.uid;

    final DocumentSnapshot database =  await Firestore.instance.document('doctor/$currentuserid').get();
    token = await database.data['token'].toString();
    hospital = await database.data['hospital'].toString();
    specialty = await database.data['specialty'].toString();
    setState(() {});
  }

  Future<Widget> pickDoctorImage() async {
    File galleryFile = await ImagePicker.pickImage(source: ImageSource.gallery,);
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdoctorinfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Stack(
              children: <Widget>[
                Transform.scale(
                  scale: 230.0,
                  child: Container(
                    height: 2.0,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap:(){
                    pickDoctorImage();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 140.0,
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Image.network(widget.image, fit: BoxFit.contain,),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 120,
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30, bottom: 10, top: 10),
              child: Stack(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text('Fullname', style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(widget.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
            ),
            Divider(
              indent: 30,
              endIndent: 30,
              color: Colors.grey,
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30, bottom: 10, top: 10),
              child: Stack(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text('Email', style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(widget.email, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
            ),
            Divider(
              indent: 30,
              endIndent: 30,
              color: Colors.grey,
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30, bottom: 10, top: 10),
              child: Stack(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text('Token', style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),),
                  ),

                  token==null ?
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text('Loading...', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  ) :
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(token, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
            ),
            Divider(
              indent: 30,
              endIndent: 30,
              color: Colors.grey,
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30, bottom: 10, top: 10),
              child: Stack(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text('Specialty', style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),),
                  ),

                  token==null ?
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text('Loading...', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  ) :
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(specialty, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
            ),
            Divider(
              indent: 30,
              endIndent: 30,
              color: Colors.grey,
            ),
            edit==true?forminput('Hospital', _hospital):Padding(
              padding: EdgeInsets.only(left: 30, right: 30, bottom: 10, top: 10),
              child: Stack(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text('Hospital', style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),),
                  ),

                  token==null ?
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text('Loading...', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  ) :
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(hospital, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
            ),
            edit==true?Container():Divider(
              indent: 30,
              endIndent: 30,
              color: Colors.grey,
            ),


            edit == null?Container():Text('Oncall Days', style: TextStyle(fontWeight: FontWeight.bold),),
            edit==null ? Container():
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
            edit==null ?Container():Container(
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
                        color: Colors.blueAccent,
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
                        color: Colors.purple,
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
                        color: Colors.blueAccent,
                        child: Center(child: Text('Saturday', style: TextStyle(color: Colors.white),)),
                      ),
                    ),
                  ),
                ],
              ),
            ),


            GestureDetector(
              onTap: (){
                setState(() {
                  edit ==true?edit=null:edit=true;
                  edit ==true?print('Startediting!'):update();
                });
              },
              child: Container(
                  alignment: Alignment.center,
                  height: 60.0,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.25,
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
                  child: edit==true?
                  Text(
                    'DONE',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ):Text(
                    'EDIT',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
              ),
            ),
            SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }
}
