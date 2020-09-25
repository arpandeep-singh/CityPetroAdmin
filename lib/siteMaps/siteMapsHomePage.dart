
import 'package:citypetro/services/Database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:citypetro/siteMaps/siteMaps.dart';



class SiteMapsHomePage extends StatefulWidget {
  @override
  _SiteMapsHomePageState createState() => _SiteMapsHomePageState();
}

class _SiteMapsHomePageState extends State<SiteMapsHomePage> {
  DatabaseService database = new DatabaseService() ;
  QuerySnapshot folders;

  @override
  void initState() {
    super.initState();
    Firestore.instance.collection('SiteMaps')
        .getDocuments().then((results){
         setState(() {
        folders=results;
      });
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
   return Scaffold(
     appBar: AppBar(
       title: Text('SITE MAPS'),
       elevation: 0,
       backgroundColor: Color(0xFF7e60e4),
     ),
     body: _loadsLFolders(),
     );

  }
  Widget _buildFolder(int i){
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SiteMaps(mainFolder: '${folders.documents[i].documentID}',),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Container(
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.grey,width: 3),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Expanded(child: FittedBox(child: Icon(Icons.folder,color: Colors.grey[600],))),
                  Container(
                    child: Center(child: Text('${folders.documents[i].documentID}')),
                  )
                ],
              )
          ),
        ),
      ),
    );


  }

  Widget _loadsLFolders(){
    if(folders!=null){
     return GridView.builder(
         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
           crossAxisCount: 3,
           childAspectRatio: 1,
           crossAxisSpacing: 20,
           mainAxisSpacing: 15,
         ),
         itemCount: folders.documents.length,
         itemBuilder: (context,i){
           return _buildFolder(i);
         }
     );
    }else{
      return Center(child: Text('Loading'));
    }
  }

}

