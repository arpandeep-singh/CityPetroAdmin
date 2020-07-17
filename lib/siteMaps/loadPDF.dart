
import 'package:citypetro/siteMaps/PDFScreen.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

// ignore: must_be_immutable
class LoadPDF extends StatefulWidget {
  String url;
  String fileName;
  LoadPDF({@required this.url,this.fileName});
  @override
  _LoadPDFState createState() => _LoadPDFState();
}

class _LoadPDFState extends State<LoadPDF> {
  String path;
  String name;
  bool pathLoaded=false;
  @override
  void initState(){
    super.initState();
    createFileOfPdfUrl(this.widget.fileName,this.widget.url).then((f) {
      setState(() {
        path = f.path;
        name= this.widget.fileName;
        pathLoaded=true;
        print(path);
      });
    });

  }
  Future<File> createFileOfPdfUrl(String NAME,String URL) async {
    String url = URL;
    String filename = NAME;
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }
  @override
  Widget build(BuildContext context) {
    return pathLoaded?PDFScreen(path,name)
        :
        Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF7e60e4),
          ),
          body: Center(
            child: CircularProgressIndicator(
            ),
          ),
    );
  }
}
