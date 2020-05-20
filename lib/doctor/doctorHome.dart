import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//page
import 'doctorProfile.dart';
import 'doctorUploadPatient.dart';
import 'package:team_med/custom/customwidgets.dart';
import 'package:team_med/general/homePage.dart';
import 'updatePatient.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;

class DoctorHomePage extends StatefulWidget {

  final String email;
  final String name;
  final String image;

  DoctorHomePage({
    this.email, this.name, this.image
});

  @override
  _DoctorHomePageState createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {

  Future _data;
  //QuerySnapshot qn;

  Future getPatientsList() async {
    //_auth.currentUser().then((doc) async{
      //var currentdocid= doc.uid.toString();
    final FirebaseUser doc = await _auth.currentUser();
    String docid = doc.uid.toString();
    var firestore = Firestore.instance;

     QuerySnapshot qn = await firestore.collection('doctor').document(docid).collection('patient').getDocuments();
      return qn.documents;
    //});


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _data = getPatientsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[

          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorProfilePage(image: widget.image, name: widget.name, email: widget.email,)));
              },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.image),
              ),
            ),
          ),
        ],
        title: Text('Home Page'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: Container(
                alignment: Alignment.center,
                height: 140.0,
                width: 340.0,
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: widget.image == null
                    ? new Text('')
                    : new Image.network(widget.image, fit: BoxFit.contain,),
              ),
              accountEmail: Text(widget.email),
              accountName: Text(widget.name),
            ),
            Container(
              padding:  EdgeInsets.only(left: 10.0, right: 10.0),
              child: Column(
                children: <Widget>[
                  //navOption(Text('Specialist'), Icons.person, DoctorHomePage(name: widget.name, email: widget.email, image: widget.image,), context),
                  navOption(Text('Settings'), Icons.settings, context),
                  navOption(Text('Complaints'), Icons.info, context),
                  Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: ListTile(
                        leading: Icon(Icons.arrow_forward),
                        title: Text('LOGOUT'),
                        onTap: (){
                          Navigator.pop(context);
                          _signOut();
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>HomePage(name: '', email: '',image: 'https://cdn1.iconfinder.com/data/icons/instagram-ui-glyph/48/Sed-10-512.png')), (Route<dynamic> route) => false);
                        },
                      ),
                      decoration: BoxDecoration(
                        boxShadow: [BoxShadow(
                          color: Color.fromRGBO(191,175,178, 3),
                          blurRadius: 5,
                        )],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0),
                      )
                  )
                ],
              ),
            ),
          ]
        )
      ),
      body: Container(
//        child: Column(
//          children: <Widget>[

          child: FutureBuilder(
            future: getPatientsList(),
            builder: (context, snapshot){

              if(snapshot.connectionState == ConnectionState.waiting){
                return Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height *0.5, left: MediaQuery.of(context).size.width *0.45
                    ),
                    child: Column(
                      children: <Widget>[
                        CircularProgressIndicator(),
                        Text("Loading...")
                      ],
                    )

                );
              }else{

                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index){
                      return  GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePatient(image:snapshot.data[index].data["image"], patientdoc: snapshot.data[index].documentID,)));
                        },
                        child: Card(
                            margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                            child: ListTile(
                              leading: Container(
                                width: 50.0,
                                height: 50.0,
                                child :Image.network(snapshot.data[index].data["image"], fit: BoxFit.contain,),

                              ),
                              title: Text(snapshot.data[index].data["name"]),
                              subtitle: Text(snapshot.data[index].data["status"]),
                            )
                        ),
                      );
                    });
              }
            },
          ),

//          ],
//        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => UploadPatientPage()));
        },
        child: Icon(Icons.image),
      ),

    );
  }

  //logout
  void _signOut() async {
    await _auth.signOut();
  }

}





