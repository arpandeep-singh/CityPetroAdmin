import 'package:citypetro/constraints.dart';
import 'package:citypetro/main.dart';
import 'package:citypetro/services/Database.dart';
import 'package:citypetro/siteMaps/PDFScreen.dart';
import 'package:citypetro/siteMaps/loadPDF.dart';
import 'package:citypetro/siteMaps/mobile_pdf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';



class DipCharts extends StatefulWidget {
  final String mainFolder;

  DipCharts({@required this.mainFolder});



  @override
  _DipChartsState createState() => _DipChartsState();
}

class _DipChartsState extends State<DipCharts> {
  TextEditingController controller = new TextEditingController();
  String filter;



  DatabaseService database = new DatabaseService() ;
  QuerySnapshot files;
  @override
  void initState(){
    super.initState();
    Firestore.instance.collection('DipCharts')
        .document(this.widget.mainFolder).collection('charts')
        .getDocuments().then((results) {
      setState(() {
        files = results;
      });
    }
    );
    controller.addListener((){
      setState(() {
        filter=controller.text;
      });
    });
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${this.widget.mainFolder}'),
        backgroundColor: Color(0xFF7e60e4),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[700]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                child: new TextField(
                  decoration: new InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter Tank Number'
                  ),
                  controller: controller,
                ),
              ),
            ),
          ),
          Expanded(child: _loadsLFiles())
        ],
      ),
    );
  }

  Widget _buildFile(int i){
    return  filter == null || filter == "" ?ListTile(
      leading: Icon(Icons.picture_as_pdf),
      title: Text('${files.documents[i].documentID}'),
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoadPDF(fileName:'${files.documents[i].documentID}',url: '${files.documents[i].data['URL']}',)),
        );
      },
    ):files.documents[i].documentID.contains(filter)?ListTile(
      leading: Icon(Icons.picture_as_pdf),
      title: Text('${files.documents[i].documentID}'),
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoadPDF(fileName:'${files.documents[i].documentID}',url: '${files.documents[i].data['URL']}',)),
        );
      },
    ):new Container();
  }
  Widget _loadsLFiles(){
    if(files!=null){
      return ListView.builder(
          itemCount: files.documents.length,
          padding: EdgeInsets.all(16.0),
          itemBuilder: (context,i){
            return _buildFile(i);
          }
      );
    }else{
      return Center(child: Text('Loading'));
    }
  }
}
