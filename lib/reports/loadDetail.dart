import 'package:citypetro/constraints.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:citypetro/auhenticate/user.dart';

class LoadDetail extends StatefulWidget {

  final String documentID;

  LoadDetail({@required this.documentID});

  @override
  _LoadDetailState createState() => _LoadDetailState();
}

class _LoadDetailState extends State<LoadDetail> {
    String order='Empty';
    String truck='Empty';
    String city='Empty';
    String stationID='Empty';
    String time='Empty';
    String rate;
    String date;
    String type='Empty';
    String waitingCharge='Empty';
    String terminal = 'Empty';

  @override
  void initState(){
    super.initState();
    Firestore.instance.collection('Loads').document(this.widget.documentID).get().then((doc){
         setState(() {
           this.order=doc.data['order'];
           this.truck=doc.data['truck'];
           this.city=doc.data['city'];
           this.stationID=doc.data['stationID'];
           this.time=(doc.data['waiting']).toString();
           this.rate=(doc.data['rate']).toString();
           this.waitingCharge=(doc.data['waitingCost']).toStringAsFixed(2);
           this.date=new DateFormat.yMMMd().format((doc.data['date'] as Timestamp).toDate());
           this.terminal=(doc.data['terminal']);


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
      appBar: AppBar(
        title: Text('REPORT DETAIL'),
        backgroundColor: Color(0xFF7e60e4),
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: size.height*0.3,
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
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: Center(child: Text('CITY PETROLEUM',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.grey[700]),)),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey,width: 1),
                                borderRadius: BorderRadius.circular(13)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Text('Truck No: '),
                                              Text('$truck')
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Text('Date: '),
                                              Text('$date')
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      children: <Widget>[
                                        Text('Driver: '),
                                        Text('ARPANDEEP SINGH')
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey,width: 1),
                                  borderRadius: BorderRadius.circular(13)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  children: <Widget>[
                                Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.location_city),
                                          Text('City'),
                                        ],
                                      ),
                                    ),
                                    Text('$city'.toUpperCase())
                                  ],
                                ),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Icon(Icons.location_on),
                                              Text('Station'),
                                            ],
                                          ),
                                        ),
                                        Text('$stationID')
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Icon(Icons.collections_bookmark),
                                              Text('Terminal'),
                                            ],
                                          ),
                                        ),
                                        Text('$terminal')
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey,width: 1),
                                  borderRadius: BorderRadius.circular(13)
                              ),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Icon(Icons.access_time),
                                              Text('Waiting Time'),
                                            ],
                                          ),
                                        ),
                                        Text('$time Min.')
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey,width: 1),
                                  borderRadius: BorderRadius.circular(13)
                              ),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 15, 15, 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(),
                                        Container(),
                                        Container(
                                          child: Text('GROSS'),
                                        ),
                                        Container(
                                          //child: Text('\$${double.parse(rate).toStringAsFixed(2)}'),
                                          child: Text('\$$rate\.00'),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 15, 15, 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(),
                                        Container(),
                                        Container(
                                          child: Text('Waiting Cost'),
                                        ),
                                        Container(
                                          child: Text('\$$waitingCharge'),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 15, 15, 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(),
                                        Container(),
                                        Container(
                                          child: Text('HST(13%)'),
                                        ),
                                        Container(
                                          child: Text('\$${
                                               ((double.parse(rate)+double.parse(waitingCharge))*0.13).toStringAsFixed(2)
                                          }'),
                                        //child: Text('demo3'),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 15, 15, 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(),
                                        Container(),
                                        Container(
                                          child: Text('Total Pay'),
                                        ),
                                        Container(
                                          child: Text('\$${
                                             ((double.parse(rate)+double.parse(waitingCharge))*1.13).toStringAsFixed(2)
                                          }'),
                                        //child: Text('demo4'),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 5,),

                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            //Expanded(child: _loadsList()),
          ],
        ),
      ),

    );
  }
}
