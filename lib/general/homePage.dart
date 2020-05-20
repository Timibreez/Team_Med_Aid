import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


//pages
import 'package:team_med/doctor/doctorHome.dart';
import 'package:team_med/general/availableSpacialists.dart';
import 'package:team_med/custom/customwidgets.dart';
import 'listDoctors.dart';
import 'package:team_med/session/doctorSigin.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;


class HomePage extends StatefulWidget {

  final String email;
  final String name;
  final String image;

  HomePage({
    this.email, this.name, this.image
  });


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  Future getpatients() async{
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("patient").getDocuments();

    return qn.documents;
  }


  bool enablecard = false;

  void visCard(){
    setState(() {
      enablecard=true;
    });
  }

  void hideCard(){
    setState(() {
      enablecard=false;
    });
  }

  bool enabledoctorcarousel = false;

  void visDoctorCarousel(){
    setState(() {
      enabledoctorcarousel=true;
    });
  }

  void hideDoctorCarousel(){
    setState(() {
      enabledoctorcarousel=false;
    });
  }

  Future _data;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _data = getpatients();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: ListTile(
                        leading: Icon(Icons.person),
                        title: Text('Specialist'),
                        onTap: (){
                          _auth.currentUser().then((current){
                            if(current != null){
                              Navigator.pop((context));
                              Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorHomePage(name: widget.name, image: widget.image, email: widget.email,)));
                            }else{
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SignPage()));
                            }
                          });

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
                  ),
                  navOption(Text('Settings'), Icons.settings,  context),
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
            )

          ],
        ),
      ),
      body: SafeArea(
          child:Container(
              child:Center(child: SingleChildScrollView(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[200],
                    child: Column(
                      children: <Widget>[

                        Container(
                          padding: EdgeInsets.only(top: 80, left: 15, right: 15),
                          color: Colors.blueAccent[500],
                          child: Column(
                            children: <Widget>[
                              appLogoName(),
                              inputField('Search Patients'),
                            ],
                          ),
                        ),
                        Stack(
                          children: <Widget>[
                            displaypatients(),
                            Visibility(
                              visible: enablecard,
                              child: emergencyCard(),
                            )
                          ],
                        )

                      ],
                    )
                ),)))

      ),
      floatingActionButton: FloatingActionButton(

        onPressed: () {
          callEmergency();
          hideDoctorCarousel();
        },
        child: Icon(Icons.add_circle_outline),
        backgroundColor: Colors.blue,
      ),
      appBar: AppBar(),
    );
  }




  ////////////WIDGETS ///////////////
  ///
  Widget appLogoName(){
    return Container(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text('TEAM MED',
          style: TextStyle(fontSize:27.0, fontWeight: FontWeight.bold, color: Color(0xFF010b13)),
        ),
      ),
    );
  }

  var _controller = TextEditingController();
  Widget inputField(String hint){
    return Container(
        margin: EdgeInsets.only(top: 20.0, bottom: 30),
        padding: EdgeInsets.fromLTRB(20.0, 0, 10.0, 0),
        child: TextField(
          controller: _controller,
          onSubmitted: (val) {
            _controller.clear();
            Navigator.push(context, MaterialPageRoute(builder: (context) => AvailableSpecialist(name: val,)));
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
          ),
        ),
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(
            color: Color.fromRGBO(191,175,178, 3),
            blurRadius: 5,
          )],
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
        )
    );
  }

  Widget emergencyCardField(String hint){
    return Container(
        margin: EdgeInsets.only(top: 20.0, bottom: 30),
        padding: EdgeInsets.fromLTRB(20.0, 0, 10.0, 0),
        child: TextField(
          onSubmitted: (val) {
            print(val);
            //visDoctorCarousel();

            callEmergency();
            Navigator.push(context, MaterialPageRoute(builder: (context) => ListDoctorsPage(specialty: val.trim(),)));

          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
          ),
        ),
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(
            color: Color.fromRGBO(191,175,178, 3),
            blurRadius: 5,
          )],
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
        )
    );
  }





  displaypatients(){
    return Container(
      padding: EdgeInsets.only(top: 5, left: 15, right: 15),
      height: MediaQuery.of(context).size.height - 250,
      child: FutureBuilder(
        future: getpatients(),
        builder: (context, snapshot){

          if(snapshot.connectionState ==ConnectionState.waiting){
            return Center(
              child: Column(
                children: <Widget>[
                  CircularProgressIndicator(),
                  Text('Loading')
                ],
              ),
            );
          }else {
            return GridView.builder(
                itemCount: snapshot.data.length,
                gridDelegate:
                new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  return  Container(
                    child: Stack(
                      children: [

                        Container(
                            margin: const EdgeInsets.fromLTRB(0,10.0,0,10.0),
                            width: (MediaQuery.of(context).size.width *0.5 )-30,
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Image.network(snapshot.data[index].data["image"],
                              fit: BoxFit.contain,
                            )
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding: EdgeInsets.only(bottom: 25.0, left: 5.0),
                          child: Container(
                            child: Text(
                              snapshot.data[index].data["name"]+'\n'+snapshot.data[index].data["hospital"],
                              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold,),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                });
          }
        })
    );
  }


  Widget emergencyCard(){
    return Stack(children: <Widget>[
      Container(
        margin: EdgeInsets.only(top: 300),
        height: 300.0,
        width: MediaQuery.of(context).size.width,
        child: Center(
            child: Container(
              padding: EdgeInsets.all(30.0),
              child: emergencyCardField('Specialty'),
            )
        ),
        decoration: BoxDecoration(
            boxShadow: [BoxShadow(
              color: Color.fromRGBO(191,175,178, 3),
              blurRadius: 2,
            )],
            borderRadius: BorderRadius.only(topLeft: Radius.circular(100)),
            color: Colors.blueAccent[300]
        ),
      ),


      GestureDetector(
        onTap: (){
          callEmergency();
        },
        child: Container(
            margin: EdgeInsets.only(top: 300, left: 20),
            child: closeEmergencyCard()
        ),
      )
    ],
    );
  }

  Widget closeEmergencyCard(){
    return Card(
        elevation: 14.0,
        child: CircleAvatar(

          backgroundColor: Colors.white,
          child: Icon(
            Icons.arrow_downward,
            color: Colors.blueAccent,
          ),
        )
    );
  }




  //logout
  void _signOut() async {
    await _auth.signOut();
  }


  ////////////  FUNCTIONS ////////////

  callEmergency(){
    enablecard == false ? visCard() : hideCard();

  }




}

