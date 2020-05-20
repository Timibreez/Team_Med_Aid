import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_auth/firebase_auth.dart';


//pages
import 'package:team_med/custom/customwidgets.dart';


class UpdatePatient extends StatefulWidget {
  final String image;
  final String patientdoc;
  UpdatePatient({
    this.image, this.patientdoc
  });

  @override
  _UpdatePatientState createState() => _UpdatePatientState();
}

class _UpdatePatientState extends State<UpdatePatient> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _patientname = TextEditingController();
  final TextEditingController _patientstatus = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final databaseReference = Firestore.instance;
  File galleryFile;
  String uploadedFileURL;
  bool _loading;

  Future<Widget> pickDoctorImage() async {

    galleryFile = await ImagePicker.pickImage(source: ImageSource.gallery, );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Information'),
      ),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    pickDoctorImage();
                    print(widget.patientdoc);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 140.0,
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: galleryFile == null
                        ? new Image.network(widget.image)
                        : new Image.file(galleryFile, fit: BoxFit.contain,),
                  ),
                ),

                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      forminput('Patient Name', _patientname),
                      forminput('status', _patientstatus),
                      GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState.validate()) {
                            _loading = true;
                            setState(() {
                            });
                            uploadFile();
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
                              'Update Record',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )
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
                      ? Text('', style: TextStyle(color: Colors.black),)
                      : CircularProgressIndicator(backgroundColor: Colors.white,),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('patient/${Path.basename(galleryFile.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(galleryFile);
    await uploadTask.onComplete;
    print('Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        String uploadedFileURL = fileURL;


        createPatientRecord(uploadedFileURL);

      });
    });
  }



  void createDoctorPatientRecord(String pimage, String duid) async {
    await databaseReference
        .collection('doctor')
        .document(duid)
        .collection('patient')
        .document(widget.patientdoc)
        .setData({
      'status': _patientstatus.text.trim(),
      'image':pimage,
      'name': _patientname.text.trim()
    });
  }

  void createPatientRecord(String imagename,) async {
    _auth.currentUser().then((current){
      if(current!= null){

        var doctoruid= current.uid.toString();

        Firestore.instance.document('doctor/$doctoruid').get().then((DocumentSnapshot) async {
          String doctorname = await DocumentSnapshot.data['name'].toString();
          String doctorhospital = await DocumentSnapshot.data['hospital'].toString();

          await databaseReference.collection("patient")
              .document(widget.patientdoc)
              .setData({
            'image': imagename,
            'doctorname': doctorname,
            'hospital': doctorhospital,
            'status': _patientstatus.text.trim(),
            'name': _patientname.text.trim(),
          });
          await createDoctorPatientRecord(imagename, doctoruid);


          Navigator.pop(context);
        });

      }});

  }



}



