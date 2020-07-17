import 'package:citypetro/constraints.dart';
import 'package:citypetro/reports/editLoad.dart';
import 'package:citypetro/services/Database.dart';
import 'package:flutter/material.dart';
import 'package:citypetro/reports/LoadDetailObject.dart';
import 'package:provider/provider.dart';
import 'package:citypetro/auhenticate/user.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class SummaryScreen extends StatefulWidget {
  final LoadDetailObject load;
  final String documentID;
  final String driverID;
  SummaryScreen({@required this.load,this.documentID,this.driverID});

  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}


class _SummaryScreenState extends State<SummaryScreen> {

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
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.settings,color: Colors.white,),
            label: Text('EDIT',style: TextStyle(color: Colors.white),),
    onPressed: () {
              print(widget.load.date);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          //return demoList(uid: user.documentID,);
          return EditLoadScreen(loadID: widget.documentID,load: widget.load,driverID: widget.driverID,);
        }),
      );
    }
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: size.height * 0.3,
                    decoration: BoxDecoration(
                      color: Color(0xFF7e60e4),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(13),
                          //border: Border.all(),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 30),
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
                              child: Center(child: Text('CITY PETROLEUM',
                                style: TextStyle(fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700]),)),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(13)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: <Widget>[
//                                          Container(
//                                            child: Row(
//                                              children: <Widget>[
//                                                Text('Truck No: '),
//                                                Text('${widget.load.truck}')
//                                              ],
//                                            ),
//                                          ),
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Text('Date: '),
                                                Text('${widget.load.date}')
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 10,),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(13)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(Icons.location_city),
                                                Text('City'),
                                              ],
                                            ),
                                          ),
                                          Text('${widget.load.city}'.toUpperCase())
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(Icons.location_on),
                                                Text('Station'),
                                              ],
                                            ),
                                          ),
                                          Text('${widget.load.stationID}')
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(Icons.location_on),
                                                Text('Terminal'),
                                              ],
                                            ),
                                          ),
                                          Text('${widget.load.terminal}')
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(Icons.add_circle),
                                                Text('Split Loads'),
                                              ],
                                            ),
                                          ),
                                          Text('${widget.load.splits}')
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
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(13)
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(Icons.access_time),
                                                Text('Waiting Time'),
                                              ],
                                            ),
                                          ),
                                          Text('${widget.load.time} Min.')
                                        ],
                                      ),
                                    ),
                                    widget.load.comments.toString()!=null?Padding(
                                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(Icons.event_note),
                                                Text('Comments'),
                                              ],
                                            ),
                                          ),
                                          Text('${widget.load.comments}')
                                        ],
                                      ),
                                    ):Container(),
                                    SizedBox(height: 10,),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(13)
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 15, 15, 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: <Widget>[
                                          Container(),
                                          Container(),
                                          Container(
                                            child: Text('GROSS'),
                                          ),
                                          Container(
                                            //child: Text('\$${double.parse(rate).toStringAsFixed(2)}'),
                                            child: Text('\$${widget.load.rate}\.00'),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 15, 15, 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: <Widget>[
                                          Container(),
                                          Container(),
                                          Container(
                                            child: Text('Waiting Cost'),
                                          ),
                                          Container(
                                            child: Text(
                                                '\$${widget.load.waitingCharge}'),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 15, 15, 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: <Widget>[
                                          Container(),
                                          Container(),
                                          Container(
                                            child: Text('HST(13%)'),
                                          ),
                                          Container(
                                            child: Text('\$${widget.load.hst}'),
                                            //child: Text('demo3'),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 15, 15, 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: <Widget>[
                                          Container(),
                                          Container(),
                                          Container(
                                            child: Text('Total Pay'),
                                          ),
                                          Container(
                                            child: Text('\$${widget.load.totalRate}'),
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
      ),

    );
  }
}




