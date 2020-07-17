import 'package:citypetro/reports/reports.dart';
import 'package:citypetro/reports/reportsHomePage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'WeeklyReport.dart';
import 'WeeklyReport.dart';

class AllUsers extends StatefulWidget {
  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  QuerySnapshot users;
  bool fetched=false;

  @override
  void initState(){
    super.initState();
    loadUsers(context);

  }
  void loadUsers(BuildContext context){
    Firestore.instance.collection('Users').orderBy('name',descending: false).getDocuments().then((results){
      setState(() {
        users=results;
        fetched=true;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Users'),
        backgroundColor: Color(0xFF7e60e4),
      ),
      body: _loadUsers(),

    );
  }

  Widget _buildUser(var user,index){
    return ListTile(
      leading: CircleAvatar(
        child: Text(user.data['name'].toString()[0]),
      ),
      title: Text(user.data['name'].toString().toUpperCase(),style: TextStyle(fontSize: 18.0),),
      subtitle: Text(user.data['role'].toString().toUpperCase()),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
           //return demoList(uid: user.documentID,);
            return ReportsInvoicesHomePage(uid: user.documentID);
          }),
        );
      }
        );


  }

  Widget _loadUsers(){
    if(users!=null){
      return ListView.builder(
        itemCount: users.documents.length,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (BuildContext context,int i){
          //var tempUser=users.documents[i];
          //if(i.isOdd)return Divider();
          final index= i;
          var tempUser=users.documents[index];
          return _buildUser(tempUser,index);
        },
      );
    }else{
      return Center(child: Text('Loading'));
    }
  }
}
