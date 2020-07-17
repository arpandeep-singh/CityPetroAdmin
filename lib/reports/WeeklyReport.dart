import 'package:citypetro/constraints.dart';
import 'package:citypetro/reports/fetchLoadDetail.dart';

import 'package:citypetro/services/Database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:citypetro/auhenticate/user.dart';

class demoList extends StatefulWidget {
  final String uid;
  demoList({this.uid});
  @override
  _demoListState createState() => _demoListState();
}

class _demoListState extends State<demoList> {

  DatabaseService database = new DatabaseService() ;
  QuerySnapshot loads;
  var loadCount = 0 ;

  static int  getFromDate(){
    //int day = DateTime.now().day;
    //return (day>=1 && day<=31)?1:15;
    return 1;
  }


  DateTime now = DateTime.now();
  DateTime dateTo = new DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,0,0,0,0,0);


  DateTime dateFrom=new DateTime(DateTime.now().year,
      DateTime.now().month,
      getFromDate(),0,0,0,0,0);

  double totalRate;
  double waitingCost;
  bool fetched=false;

  @override
  void initState() {
    super.initState();
    loadResults(context,widget.uid);
    print(dateFrom);
    print(dateTo);

  }

  void loadResults(BuildContext context,String uid)async{

    totalRate=0.0;
    waitingCost=0.0;
    loadCount=0;

    Firestore.instance.collection('Users').document(uid).collection('Loads')
        .orderBy("date",descending: true)
        .where('date',isGreaterThanOrEqualTo: dateFrom)
        .where('date',isLessThanOrEqualTo: dateTo)
        .getDocuments().then((results){
      setState(() {
        loads=results;
        loadCount=loads.documents.length;
        fetched=true;
        print('Length: ${loads.documents.length}');
        for(var i=0;i<loads.documents.length;i++){
          totalRate+=((loads.documents[i].data['totalRate'])*1.13);
          waitingCost+=loads.documents[i].data['waitingCost'];
        }

      });
    });

  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    var size = MediaQuery
        .of(context)
        .size;
    return Scaffold(

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
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
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
                                Center(child: Text('\$${double.parse(totalRate.toStringAsFixed(2))}',style: TextStyle(fontSize: 24,fontWeight: FontWeight.w900,color: Colors.green),)),
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
                                        Text('\$${double.parse(waitingCost.toStringAsFixed(2))}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)
                                      ],
                                    ),
                                    SizedBox(height: 15,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text('HST 13%',style: TextStyle(fontSize: 14),),
                                        Text('\$${double.parse(((totalRate/1.13)*0.13).toStringAsFixed(2))}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)
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
                              FlatButton(
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.calendar_today),
                                    SizedBox(width: 6,),
                                    Text("${dateFrom.toLocal()}".split(' ')[0]),
                                  ],
                                ),
                                onPressed: ()async{
                                  DateTime picked = await showDatePicker(
                                    context: context,
                                    initialDate: dateFrom,
                                    firstDate: DateTime(2015, 8),
                                    lastDate: DateTime(2101),

                                  );
                                  if (picked != null)
                                    setState(() {
                                      dateFrom = picked;
                                    });
                                  print(dateFrom);
                                  print(dateTo);
                                  loadResults(context,widget.uid);
                                },
                              ),

                              //Text('-'),
                              FlatButton(
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.calendar_today),
                                    SizedBox(width: 6,),
                                    Text("${dateTo.toLocal()}".split(' ')[0]),
                                  ],
                                ),
                                onPressed: ()async{
                                  final DateTime picked = await showDatePicker(
                                      context: context,
                                      initialDate: dateTo,
                                      firstDate: DateTime(2015, 8),
                                      lastDate: DateTime(2101));
                                  if (picked != null)
                                    setState(() {
                                      dateTo = picked;
                                    });
                                  print(dateFrom.toLocal());
                                  print(dateTo.toLocal());
                                  loadResults(context,widget.uid);
                                },
                              ),
                            ],
                          ),

                          SizedBox(height: 5,),

                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            fetched==false?Center(child: Container(child: CircularProgressIndicator(strokeWidth: 1,))):
            Expanded(child: _loadsList()),
          ],
        ),
      ),

    );
  }

  Widget _buildRow(var load){

    return ListTile(
      title: Text(load.data['city'].toString().toUpperCase()+" - # "+load.data['stationID'].toString().toUpperCase()+" - s"+load.data['splitLoads'].toString()),
      subtitle: Align(
        alignment: Alignment.topLeft,
        child: Column(
          children: <Widget>[
            // Text(loads.documents[i].data['order']),
            Text(new DateFormat.yMMMd().format((load.data['date'] as Timestamp).toDate())),
          ],
        ),
      ),
      trailing: Text('\$${load.data['rate']}'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FetchDetail(documentID: '${load.documentID}',uid: this.widget.uid,),
          ),
        );
      },
    );
  }
  Widget _loadsList(){
    if(loads!=null){
      return ListView.builder(
        itemCount: loadCount,
        padding: EdgeInsets.all(8),
        itemBuilder: (context,i){
          var tempLoad=loads.documents[i];
          print('$i ${tempLoad.data['rate']} ${tempLoad.data['waiting']}');
          return _buildRow(tempLoad);
        },
      );
    }else{
      return Center(child: Text('Loading'));
    }
  }

}
