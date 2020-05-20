import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_auth/firebase_auth.dart';


//pages
import 'package:team_med/custom/customwidgets.dart';


class UploadPatientPage extends StatefulWidget {
  @override
  _UploadPatientPageState createState() => _UploadPatientPageState();
}

class _UploadPatientPageState extends State<UploadPatientPage> {


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _patientname = TextEditingController();
  final TextEditingController _patientstatus = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final databaseReference = Firestore.instance;

  //save the result of gallery file
  File galleryFile;
  String uploadedFileURL;
  bool _success;
  bool _loading;


  @override
  void initState() {
    imageSelectorGallery();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Unidentified'),
      ),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  height: 140.0,
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: galleryFile == null
                      ? new Text('')
                      : new Image.file(galleryFile, fit: BoxFit.contain,),
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
                            print('pressed');
                            uploadFile();
                          }
                        },
                        child: Container(
                            alignment: Alignment.center,
                            height: 60.0,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 5.0),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                boxShadow: [BoxShadow(
                                  color: Color.fromRGBO(191,175,178, 3),
                                  blurRadius: 5,
                                )],
                                borderRadius: BorderRadius.circular(30.0)
                            ),
                            child: Text(
                              'Upload Record',
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


  imageSelectorGallery() async {
    galleryFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      // maxHeight: 50.0,
      // maxWidth: 50.0,
    );
    //print("You selected gallery image : " + galleryFile.path);
    setState(() {});
  }

  Future<Widget> pickPatientImage() async {
    galleryFile = await ImagePicker.pickImage(source: ImageSource.gallery, );


    }

  
  Future<Widget> showpatientImage() async{
    galleryFile = await ImagePicker.pickImage(source: ImageSource.gallery, );
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      child: new SizedBox(
        height: 200.0,
        width: 200.0,
        child: galleryFile == null
            ? new Text('Please, select an image!!')
            : new Image.file(galleryFile),
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
   return storageReference;
 }



  void createDoctorPatientRecord(String pimage, String pid, String duid) async {
    await databaseReference
        .collection('doctor')
        .document(duid)
        .collection('patient')
        .document(pid)
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

          DocumentReference ref = await databaseReference.collection("patient")
              .add({
            'image': imagename,
            'doctorname': doctorname,
            'hospital': doctorhospital,
            'status': _patientstatus.text.trim(),
            'name': _patientname.text.trim(),
          });
          String patientuid = ref.documentID.toString();
          print("patient record id " + patientuid);
          await createDoctorPatientRecord(imagename, patientuid, doctoruid);


          Navigator.pop(context);
        });

      }});

  }




}
