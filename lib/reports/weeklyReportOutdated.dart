import 'package:citypetro/constraints.dart';
import 'package:citypetro/services/Database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class WeeklyReport extends StatefulWidget {
  @override
  _WeeklyReportState createState() => _WeeklyReportState();
}

class _WeeklyReportState extends State<WeeklyReport> {

  DatabaseService database = new DatabaseService() ;
  QuerySnapshot loads;

  DateTime dateFrom = DateTime.now();
  DateTime dateTo=DateTime.now().subtract(new Duration(days: 6));

@override
void initState(){
  Firestore.instance.collection('Loads').getDocuments().then((results){
     setState(() {
       loads=results;
     });
  });
}
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar:  AppBar(
        title: Text('REPORTS'),
        elevation: 0,
        backgroundColor:  Color(0xFF7e60e4),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: (){},
          )
        ],
      ),


      body: Container(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: size.height*0.18,
                  decoration: BoxDecoration(
                    color:  Color(0xFF7e60e4),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(13),
                        //border: Border.all(),
                        boxShadow:[
                          BoxShadow(
                              offset: Offset(0,30),
                              blurRadius: 10,
                              spreadRadius: -20,
                              color: kShadowColor
                          )
                        ]
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: <Widget>[

                          ExpansionTile(

                            title: Column(
                              children: <Widget>[
                                SizedBox(height: 10,),
                                Center(child: Text('TOTAL EARNINGS',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.grey[700]),)),
                                SizedBox(height: 5,),
                                Center(child: Text('\$34,567',style: TextStyle(fontSize: 24,fontWeight: FontWeight.w900,color: Colors.green),)),
                              ],
                            ),

                            children: <Widget>[
                              SizedBox(height: 10,),
                              ListTile(
                                title: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text('WAITING COST',style: TextStyle(fontSize: 14),),
                                        Text('\$25.66',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)
                                      ],
                                    ),
                                    SizedBox(height: 15,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text('HST 13%',style: TextStyle(fontSize: 14),),
                                        Text('\$3909.52',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
//                               FlatButton(
//                                 child: Row(
//                                   children: <Widget>[
//                                     Icon(Icons.calendar_today),
//                                     SizedBox(width: 6,),
//                                     Text("${dateFrom.toLocal()}".split(' ')[0]),
//                                   ],
//                                 ),
//                                 onPressed: ()async{
//                                   final DateTime picked = await showDatePicker(
//                                       context: context,
//                                       initialDate: dateFrom,
//                                       firstDate: DateTime(2015, 8),
//                                       lastDate: DateTime(2101));
//                                   if (picked != null && picked != dateFrom)
//                                     setState(() {
//                                       dateFrom = picked;
//                                     });
//                                 },
//                               ),
//
                              Text('TO'),
//                               FlatButton(
//                                 child: Row(
//                                   children: <Widget>[
//                                     Icon(Icons.calendar_today),
//                                     SizedBox(width: 6,),
//                                     Text("${dateTo.toLocal()}".split(' ')[0]),
//                                   ],
//                                 ),
//                                 onPressed: ()async{
//                                   final DateTime picked = await showDatePicker(
//                                       context: context,
//                                       initialDate: dateTo,
//                                       firstDate: DateTime(2015, 8),
//                                       lastDate: DateTime(2101));
//                                   if (picked != null && picked != dateTo)
//                                     setState(() {
//                                       dateTo = picked;
//                                     });
//                                 },
//                               ),
                            ],
                          ),

//                                  Row(
//                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                    children: <Widget>[
//                                      Container(
//                                        child: Column(
//                                          children: <Widget>[
//                                          Text('TOTAL LOADS',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey[700]),),
//                                            SizedBox(height: 5,),
//                                            Text('23',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900,color: Colors.green),)
//                                          ],
//                                        ),
//                                      ),
//                                      Container(
//                                        child: Column(
//                                          children: <Widget>[
//                                            Text('WAITING TIME',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey[700]),),
//                                            SizedBox(height: 5,),
//                                            Text('13 Hr',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900,color: Colors.green),)
//                                          ],
//                                        ),
//                                      )
//                                    ],
//
//                                  ),
                          SizedBox(height: 5,),

                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(child: _loadsList()),
          ],
        ),
      ),
      //bottomNavigationBar: BottomNavBar(),

    );
  }

  Widget _loadsList(){
        if(loads!=null){
          return ListView.builder(
            itemCount: loads.documents.length,
            padding: EdgeInsets.all(8),
            itemBuilder: (context,i){
              return
                ListTile(
                  title: Text(loads.documents[i].data['city'].toString().toUpperCase()),
                  subtitle: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      children: <Widget>[
                        Text(loads.documents[i].data['order']),
                      ],
                    ),
                  ),
                  trailing: Text('\$85'),
                  onTap: (){

                  },
                );
            },
          );

    }
  }
}

