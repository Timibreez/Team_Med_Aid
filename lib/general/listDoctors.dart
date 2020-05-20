import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


//pages
import 'infooflistofdoctors.dart';


class ListDoctorsPage extends StatefulWidget {

  final String specialty;

  ListDoctorsPage({
    this.specialty
});

  @override
  _ListDoctorsPageState createState() => _ListDoctorsPageState();
}

class _ListDoctorsPageState extends State<ListDoctorsPage> {

//  GoogleMapController mapController;
//
//  final LatLng center = const LatLng(45.521563, -122.677433);
//
//  void onMapCreated(GoogleMapController controller){
//    mapController = controller;
//  }

  Future getdoctors() async{
    var firestore = Firestore.instance;
    String specialty = widget.specialty;
    var date = DateTime.now();
    String day = DateFormat('EEEE').format(date);
    QuerySnapshot qn = await firestore.collection("specialty").document(specialty).collection(day).getDocuments();

    return qn.documents;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: Text("Doctors Detail"),
          ),
          body: Container(
            padding: EdgeInsets.only(top: 5, left: 15, right: 15),
            child: FutureBuilder(
              future: getdoctors(),
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
                }else if(snapshot.hasError){
                  return Container(child: Text('No data, an error occured!', style: TextStyle(fontWeight: FontWeight.bold),),);
                  }else {

                  return GridView.builder(
                    itemCount: snapshot.data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    itemBuilder: (BuildContext context, int index) {
                      String docimage = snapshot.data[index].data["image"];
                      String docname = snapshot.data[index].data["name"];
                      String docemail = snapshot.data[index].data["email"];
                      String dochospital = snapshot.data[index].data["hospital"];
                      return  GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorInfo(image: docimage, name: docname, email: docemail, hospital: dochospital,)));
                        },
                        child: Container(
                          child: Stack(
                            children: [

                              Container(
                                margin: const EdgeInsets.fromLTRB(0,10.0,0,10.0),
                                width: (MediaQuery.of(context).size.width *0.5 )-30,
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                  ),
                                child: Image.network(docimage,
                                  fit: BoxFit.contain,
                                )
                               ),
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  padding: EdgeInsets.only(bottom: 25.0, left: 5.0),
                                    child: Container(
                                      child: Text(
                                        docname+'\n'+dochospital,
                                        style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold,),
                                      ),
                                    ),
                                ),
                              ],
                          ),
                    ),
                      );
                  });
                }
              })
          )
    );
  }
}

//GoogleMap(
//onMapCreated: onMapCreated,
//initialCameraPosition: CameraPosition(
//target: center,
//zoom: 11.0
//),
//),