import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Paperwork extends StatefulWidget {
  final String documentID;
  final String uid;
  Paperwork({this.documentID,this.uid});
  @override
  _PaperworkState createState() => _PaperworkState();
}

class _PaperworkState extends State<Paperwork> {
  String _base64;
  Uint8List fBytes;
  QuerySnapshot paperWorks;
  bool fetched = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadImage(context, widget.uid,widget.documentID);
  }

  Future loadImage(BuildContext context,String uid,String documentID){
    Firestore.instance.collection('Users')
        .document(uid).collection('Loads')
        .document(documentID).collection('files').getDocuments()
        .then((results){
       setState(() {
         paperWorks=results;
         fetched=true;
       });
    });
  }


  @override
  Widget build(BuildContext context) {
    //Uint8List bytes = base64.decode(_base64);
    var size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: _loadsList(),
            )
          ],
        ),
      )
    );
  }

  Widget _buildImage(var image){

    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
        child: Image.network(image.data['URL']),

      ),
    );
  }

  Widget _loadsList(){
    if(paperWorks!=null){
      return ListView.builder(
        itemCount: paperWorks.documents.length,
        padding: EdgeInsets.all(8),
        itemBuilder: (context,i){
          var tempPaperwork=paperWorks.documents[i];
          print(tempPaperwork.data['URL']);
          //print('$i ${tempLoad.data['rate']} ${tempLoad.data['waiting']}');

          return _buildImage(tempPaperwork);
        },
      );
    }else{
      return Center(child: Text('Please Wait!'));
    }
  }
}
