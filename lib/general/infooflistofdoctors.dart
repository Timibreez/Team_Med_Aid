import 'package:flutter/material.dart';



class DoctorInfo extends StatefulWidget {

  final String image;
  final String name;
  final String hospital;
  final String email;

  DoctorInfo({
    this.image, this.name, this.hospital, this.email
  });

  @override
  _DoctorInfoState createState() => _DoctorInfoState();
}

class _DoctorInfoState extends State<DoctorInfo> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name +" Information"),
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
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 140.0,
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Image.network(widget.image, fit: BoxFit.contain,),
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
                    child: Text('Hospital', style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),),
                  ),

                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(widget.hospital, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
            ),
            Divider(
              indent: 30,
              endIndent: 30,
              color: Colors.grey,
            ),




            SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }



}




