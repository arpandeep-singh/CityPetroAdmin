import 'package:citypetro/services/Database.dart';
import 'package:citypetro/siteMaps/loadPDF.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';



class SiteMaps extends StatefulWidget {
  String mainFolder='';

  SiteMaps({@required this.mainFolder});



  @override
  _SiteMapsState createState() => _SiteMapsState();
}

class _SiteMapsState extends State<SiteMaps> {
  TextEditingController controller = new TextEditingController();
  String filter;
 


  DatabaseService database = new DatabaseService() ;
  QuerySnapshot files;
  @override
  void initState(){
    super.initState();
    Firestore.instance.collection('SiteMaps')
        .document(this.widget.mainFolder).collection('maps')
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
                      hintText: 'Enter Station ID'
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
