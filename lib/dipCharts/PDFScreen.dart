import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:flutter_share/flutter_share.dart';

class PDFScreen extends StatelessWidget {
  final String pathPDF ;
  final String fileName;

  PDFScreen(this.pathPDF,this.fileName);

  Future<void> shareFile() async {
    try {
      await FlutterShare.shareFile(
        title: 'SHARE',
        text: 'SHARE',
        filePath: this.pathPDF,
      );
    }catch(e){
      print("Oops! An error occured");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          title: Text('$fileName'),

          /*
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.share,color: Colors.white,),
              label: Text('',style: TextStyle(color: Colors.white),),
              onPressed: shareFile
            ),
          ],
          */

        ),

        path: pathPDF);
  }
}