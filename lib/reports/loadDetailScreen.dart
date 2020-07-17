import 'package:citypetro/constraints.dart';
import 'package:citypetro/reports/paperwork.dart';
import 'package:citypetro/reports/summaryScreen.dart';
import 'package:citypetro/services/Database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:citypetro/reports/LoadDetailObject.dart';
import 'package:provider/provider.dart';
import 'package:citypetro/auhenticate/user.dart';

class LoadDetailScreen extends StatelessWidget {
  final String documentID;
  final String uid;
  final LoadDetailObject load;

  LoadDetailScreen({@required this.load,this.documentID,this.uid});

  @override
  Widget build(BuildContext context) {
    final _kTabPages=<Widget>[
    SummaryScreen(load: load,),
      Paperwork(documentID: documentID,uid: uid,)

    ];
    final _kTabs=<Tab>[
      Tab(text: 'SUMMARY',),
      Tab(text: 'PAPERWORK',),


    ];
    final user = Provider.of<User>(context);
    var size = MediaQuery
        .of(context)
        .size;
    return DefaultTabController(
      length: _kTabPages.length,
      child: Scaffold(
                appBar: AppBar(
                  title: Text('Load Summary'),
                  bottom: TabBar(
                    tabs: _kTabs,
                  ),
                  actions:  <Widget>[
                FlatButton.icon(
                icon: Icon(Icons.settings,color: Colors.white,),
        label: Text('Edit',style: TextStyle(color: Colors.white),),
        onPressed: () {
//          showDialog(
//              context: context,
//              barrierDismissible: widget.load.uptLink==null,
//              builder: (_) {
//                return widget.load.uptLink!=null?MyDialog(docId: widget.load.documentID,uptLink: widget.load.uptLink,)
//                    :AlertDialog(
//                  title: Text('Sorry!'),
//                  content: SingleChildScrollView(
//                    child: ListBody(
//                      children: <Widget>[
//                        Text('UPT Link not avaialable '),
//                        Text('Please refer to UPT email for this load!'),
//                      ],
//                    ),
//                  ),
//                  actions: <Widget>[
//                    FlatButton(
//                      child: Text('OK'),
//                      onPressed: () {
//                        Navigator.of(context).pop();
//                      },
//                    ),
//                  ],
//                );
//              });
        },
      ),
      ],
                ),
        body: TabBarView(
          children: _kTabPages,
        ),
      )
    );
  }
}
