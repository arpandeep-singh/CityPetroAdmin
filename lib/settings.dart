import 'package:citypetro/Settings/rateManagement.dart';
import 'package:flutter/material.dart';
class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const listTiles=<Widget>[
      ListTile(leading: Icon(Icons.supervised_user_circle),title: Text('Add Driver',),trailing: Icon(Icons.arrow_forward_ios),),
      Divider(),
      ListTile(leading: Icon(Icons.monetization_on),title: Text('Modify Rates',),trailing: Icon(Icons.arrow_forward_ios),
         ),
      Divider(),

    ];
   // return ListView(children: listTiles,);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF7e60e4),
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(leading: Icon(Icons.supervised_user_circle),title: Text('Add Driver',),trailing: Icon(Icons.arrow_forward_ios),),
            Divider(),
            ListTile(leading: Icon(Icons.monetization_on),title: Text('Modify Rates',),trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      //return demoList(uid: user.documentID,);
                      return ChangeRate();
                    }),
                  );
                }),
            Divider(),

          ],
        ),
      ),
    );
  }
}
