import 'package:flutter/material.dart';




Widget navOption(Text option, IconData icon, BuildContext context){
  return Container(
      margin: EdgeInsets.only(top: 20.0),
      child: ListTile(
        leading: Icon(icon),
        title: option,
        onTap: (){
          Navigator.pop((context));
          //Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
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
  );
}


TextEditingController _control = TextEditingController();

Widget forminput(String name, _control){

  return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      padding: EdgeInsets.fromLTRB(20.0, 0.0, 10.0, 0.0),
      child: TextFormField(
          controller: _control,
          decoration: InputDecoration(labelText: name, border: InputBorder.none),
          validator: (String value) {
            if (value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          }
      ),
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(
            color: Color.fromRGBO(191,175,178, 3),
            blurRadius: 5,
          )],
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0)
      )
  );
}






