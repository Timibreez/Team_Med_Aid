import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';


class AvailableSpecialist extends StatefulWidget {

  final String name;
  AvailableSpecialist({
    this.name
});

  @override
  _AvailableSpecialistState createState() => _AvailableSpecialistState();
}

class _AvailableSpecialistState extends State<AvailableSpecialist> {

  Future getpatients() async{
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("patient").getDocuments();

    return qn.documents;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Doctors FireStore"),),
        body: Container(

          child: FutureBuilder(
            future: getpatients(),
            builder: (context, snapshot){

              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(
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
                      if(snapshot.data[index].data["name"].toLowerCase().contains(widget.name.toLowerCase())) {
                        return ListTile(
                          leading: Image.network(snapshot.data[index]
                              .data["image"]),
                          title: Text(snapshot.data[index].data["status"]),
                          subtitle: Text(snapshot.data[index].data['hospital']),
                          trailing: Text(snapshot.data[index].data['name']),
                        );
                      }else{return Container();}
                    });
              }
            },
          ),
        )
    );
  }
}
