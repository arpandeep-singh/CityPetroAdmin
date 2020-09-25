
import 'package:citypetro/reports/LoadDetailObject.dart';
import 'package:citypetro/reports/summaryScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class FetchDetail extends StatefulWidget {
  final String documentID;
  final String uid;
  FetchDetail({@required this.documentID,this.uid});

  @override
  _FetchDetailState createState() => _FetchDetailState();
}

class _FetchDetailState extends State<FetchDetail> {
  String order='Empty';
  String truck='Empty';
  String city='Empty';
  String stationID='Empty';
  String time='Empty';
  String rate;
  String date;
  String type='Empty';
  String waitingCharge='Empty';
  String splits;
  bool dataFetched=false;
  LoadDetailObject load= new LoadDetailObject(

      stationID: '',
      city: '',
      order: '',
      date: '',
      time: 0,
      truck: '',
      splits: 0,
      totalRate: '',
      hst: '',
      rate: 0,
      waitingCharge: 0,
      comments: '',
  );

  @override
  void initState(){
    super.initState();
    getData(this.widget.documentID,this.widget.uid);
  }

  void getData(String id,String uid){
    Firestore.instance.collection('Users').document(uid).collection('Loads').document(id).get().then((doc){
      setState(() {
            load=new LoadDetailObject(
            stationID: doc.data['stationID'],
            city: doc.data['city'],
            order: doc.data['order'],
            date: new DateFormat.yMMMd().format((doc.data['date'] as Timestamp).toDate()),
                //date:DateTime.parse(new DateFormat.yMMMd().format((doc.data['date'] as Timestamp).toDate()),),
            time: int.parse((doc.data['waiting']).toString()),
            truck: doc.data['truck'],
            splits: int.parse(doc.data['splitLoads'].toString()),
            totalRate: ((double.parse((doc.data['totalRate']).toString()))*1.13).toStringAsFixed(2),
            hst: ((double.parse((doc.data['totalRate']).toString()))*0.13).toStringAsFixed(2),
            rate: int.parse((doc.data['rate']).toString()),
            terminal: (doc.data['terminal']),
            waitingCharge: double.parse((doc.data['waitingCost']).toStringAsFixed(2)),
              comments: doc.data['comments']
        );
        dataFetched=true;
      }
      );

    });
  }
  @override
  Widget build(BuildContext context) {
    return dataFetched?SummaryScreen(load: load,documentID: widget.documentID,driverID: widget.uid,)
        :
    SummaryScreen(load: load,);

  }
}
