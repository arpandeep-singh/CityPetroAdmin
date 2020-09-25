
import 'package:citypetro/constraints.dart';
import 'package:citypetro/reports/LoadDetailObject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:citypetro/addLoad/load.dart';
import 'package:citypetro/addLoad/site.dart';
import 'package:citypetro/services/Database.dart';
import 'dart:io';
import 'package:citypetro/auhenticate/user.dart';
import 'package:flutter/services.dart';


class EditLoadScreen extends StatefulWidget {
  LoadDetailObject load;
  final String loadID;
  final String driverID;
  EditLoadScreen({this.loadID,this.load,this.driverID});
  @override
  _EditLoadScreenState createState() => _EditLoadScreenState();
}
showAlertDialog(BuildContext context){
  AlertDialog alert=AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 12),child:Text("Submitting Data" )),
      ],),
  );
  showDialog(barrierDismissible: false,
    context:context,
    builder:(BuildContext context){
      return alert;
    },
  );
}

class _EditLoadScreenState extends State<EditLoadScreen> {

  int totalRate=0;
  DateTime loadDate;
  int waitingTime =0;
  double waitingCost=0.0;
  int adjustment5=0;
  int adjustment1=0;



  TextEditingController _controller = new TextEditingController();

  QuerySnapshot sitesSnapshot;

  String filePath;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //widget.load widget.load= new widget.load(city:"",rate: -1,stationID:'',date: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,0,0,0,0,0),waiting: 0,splits: 0,terminal: 'TOR');

  List<Site> sites=[];
  List<String> fileURLs=[];
  List<File> documents=[];


  DatabaseService database = new DatabaseService();

  int tempRate=0;
  int cityRate=0;
  int rateToronto=0;
  int rateOakville=0;
  int rateHamilton=0;
  int rateNanticoke=0;
  int rate=-1;
  bool _autoValidate = false;
  void showMessage(String message, MaterialColor color) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(backgroundColor: color, content: new Text(message)));
  }
  void  _submitForm(BuildContext context,String uid) async{
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      showMessage('Please fill out the missing details', Colors.red);
      print('Please fill out the missing details');
    }else if(widget.load.stationID==''||widget.load.city==''||widget.load.rate==0||widget.load.truck.toString().isEmpty||widget.load.order.toString().isEmpty)
    {
      showMessage('Please select STATION ID',Colors.red);
    }
    else {
      form.save(); //This invokes each onSaved event
      print('Station ID: ${widget.load.stationID}');
      print('City: ${widget.load.city}');
      print('Rate: ${widget.load.rate-widget.load.splits*20}');
      print('Date: ${widget.load.date}');
      print('Order: ${widget.load.order}');
      print('Truck: ${widget.load.truck}');
      print('Waiting Time: ${widget.load.time}');
      print('Waiting Cost: ${widget.load.waitingCharge}');
      print('Total Cost: ${widget.load.rate+widget.load.waitingCharge}');
      print('Splits: ${widget.load.splits}');
      print('Comments: ${widget.load.comments}');
      print('Terminal: ${widget.load.terminal}');
      setState(() {
        widget.load.totalRate=((double.parse((widget.load.rate+widget.load.waitingCharge).toString()))*1.13).toStringAsFixed(2);
      });


       var loadData =({
        'stationID': widget.load.stationID,
        'city':widget.load.city,
        'rate':widget.load.rate,
        'date':widget.load.date,
        'order':widget.load.order,
        'truck':widget.load.truck,
        'waiting':widget.load.time,
        'waitingCost':widget.load.waitingCharge,
        'totalRate':widget.load.rate+widget.load.waitingCharge,
        'splitLoads':widget.load.splits,
        'comments':widget.load.comments,
        'terminal':widget.load.terminal
      });
      // final List<String> linkList = await database.getLinks(documents, DateTime.now());
      showAlertDialog(context);
      bool done = await DatabaseService(uid: uid).modifyLoad(loadData, uid, widget.loadID,);
      Navigator.pop(context);
      if(done){
        showMessage('Load updated Successfully!',Colors.green);
        print('Done!');
//        form.reset();
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context);
        });
      }else{
        showMessage('Oops! A problem occured',Colors.red);
      }

    }
    //_autoValidate=true;
  }

  @override
  void initState(){
    super.initState();
    sites=[];
    Firestore.instance.collection('Rates').snapshots().listen((data)=>
        data.documents.forEach((doc){
          Site site = new Site(
              stationID: doc.data['stationID'],
              city: doc.data['city'],
              rateToronto: int.parse(doc.data['rateToronto']),
              rateHamilton: int.parse(doc.data['rateHamilton']),
              rateOakville: int.parse(doc.data['rateOakville']),
              rateNanticoke: int.parse(doc.data['rateNanticoke']));
          if(site.stationID==widget.load.stationID){
            setState(() {
              this.rateToronto= site.rateToronto;
              this.rateHamilton= site.rateHamilton;
              this.rateOakville= site.rateOakville;
              this.rateNanticoke= site.rateNanticoke;
              print("T: $rateToronto O: $rateOakville H: $rateHamilton N: $rateNanticoke");
            });
          }
          sites.add(site);
//          Origin Toronto= new Origin(name: 'Toronto',rate: doc.data['rateToronto']);
//          Origin Oakville=new Origin(name:'Oakville')
        })
    );
    print(widget.load.date);
    // _controller.addListener(() => _extension = _controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);


    var size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(

        title: Text('MODIFY LOAD'),
        elevation: 0,
        backgroundColor: Color(0xFF7e60e4),
      ),


      body: Stack(
        children: <Widget>[
          Container(
            height: size.height,
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      autovalidate: _autoValidate,
                      child: Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                height: size.height*0.16,
                                decoration: BoxDecoration(
                                  color: Color(0xFF7e60e4),
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
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text('STATION ID',style: TextStyle(fontSize: 20,)),
                                                Container(
                                                  child: Material(
                                                    child: InkWell(
                                                      child: Row(
                                                        children: <Widget>[
                                                          Icon(Icons.arrow_drop_down),
                                                          Text('${widget.load.stationID}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.grey[700])),
                                                        ],
                                                      ),
                                                      onTap: (){
                                                        SelectDialog.showModal<Site>(
                                                          context,
                                                          label: "Select Station",
                                                          titleStyle: TextStyle(color: Colors.black),
                                                          showSearchBox: true,
                                                          searchBoxDecoration: InputDecoration(
                                                            hintText: 'Search',
                                                            prefixIcon: Icon(Icons.search),

                                                          ),
                                                          backgroundColor: Colors.white,
                                                          items: sites,
                                                          onChange: (Site selected) {
                                                            setState(() {
                                                              widget.load.stationID = selected.stationID;
                                                              widget.load.city=selected.city;
                                                              rateToronto=selected.rateToronto;
                                                              rateOakville=selected.rateOakville;
                                                              rateHamilton=selected.rateHamilton;
                                                              rateNanticoke=selected.rateNanticoke;
                                                             // widget.load.splits=0;
                                                              widget.load.rate=rateToronto+(widget.load.splits*20);
                                                              rate=selected.rateToronto;
                                                              widget.load.terminal='Toronto';
                                                            });
                                                          },
                                                        );
                                                      },
                                                    ),

                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 10,),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text('CITY',style: TextStyle(fontSize: 20,)),
                                              Text('RATE',style: TextStyle(fontSize: 20,)),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                          child: Column(
                                            children: <Widget>[
                                              SizedBox(height: 10,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Text('${widget.load.city}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.grey[700]),),
                                                  Text('\$${widget.load.rate-widget.load.splits*20}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.grey[700]),),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Container(),
                                                  Text('\+\$${widget.load.splits*20}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.green),),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                          child: Row(
                                            children: <Widget>[
                                              Text('TERMINAL',style: TextStyle(fontSize: 20,)),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            new Radio(
                                              value: rateToronto,
                                              groupValue: widget.load.rate-widget.load.splits*20,

                                              onChanged: (int value){
                                                print("T: $rateToronto O: $rateOakville H: $rateHamilton N: $rateNanticoke");
                                                if(value!=0){
                                                  setState(() {
                                                    widget.load.rate=value+widget.load.splits*20;
                                                    //widget.load.splits=0;
                                                    widget.load.terminal='Toronto';

                                                  }
                                                  );
                                                }
                                              },
                                            ),
                                            new Text(
                                              'TOR',
                                              style: new TextStyle(fontSize: 16.0,color: Colors.grey[600]),

                                            ),
                                            new Radio(
                                              value: this.rateOakville,
                                              groupValue: widget.load.rate-widget.load.splits*20,

                                              onChanged: (int value){
                                                print("T: $rateToronto O: $rateOakville H: $rateHamilton N: $rateNanticoke");
                                                if(value!=0){
                                                  setState(() {
                                                    widget.load.rate=value+widget.load.splits*20;
                                                    //widget.load.splits=0;
                                                    widget.load.terminal='Oakville';
                                                  }
                                                  );
                                                }
                                              },
                                            ),
                                            new Text(
                                              'OAK',
                                              style: new TextStyle(fontSize: 16.0,color: Colors.grey[600]),
                                            ),
                                            new Radio(

                                              value: rateHamilton,
                                              groupValue: widget.load.rate-widget.load.splits*20,
                                              onChanged: (int value){
                                                print("T: $rateToronto O: $rateOakville H: $rateHamilton N: $rateNanticoke");
                                                if(value!=0){
                                                  setState(() {
                                                    widget.load.rate=value+widget.load.splits*20;
                                                    //widget.load.splits=0;
                                                    widget.load.terminal='Hamilton';
                                                  }
                                                  );
                                                }
                                              },
                                            ),
                                            new Text(
                                              'HAM',
                                              style: new TextStyle(fontSize: 16.0,color: Colors.grey[600]),
                                            ),
                                            new Radio(

                                              value: rateNanticoke,
                                              groupValue: widget.load.rate-widget.load.splits*20,
                                              onChanged: (int value){
                                                print("T: $rateToronto O: $rateOakville H: $rateHamilton N: $rateNanticoke");
                                                if(value!=0){
                                                  setState(() {
                                                    widget.load.rate=value+widget.load.splits*20;
                                                    //widget.load.splits=0;
                                                    widget.load.terminal='Nanticoke';
                                                  }
                                                  );
                                                }
                                              },
                                            ),
                                            new Text(
                                              'NAN',
                                              style: new TextStyle(fontSize: 16.0,color: Colors.grey[600]),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5,),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                //mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text('Split Loads',style: TextStyle(fontSize: 20,)),
                                                  SizedBox(width: 10,),
                                                  IconButton(
                                                    icon: Icon(Icons.add_circle,color: Colors.green,),
                                                    onPressed: (){
                                                      setState(() {
                                                        widget.load.splits++;
                                                        widget.load.rate+=20;
                                                        rate+=20;
                                                      });
                                                    },
                                                  ),

                                                  IconButton(
                                                    icon: Icon(Icons.remove_circle,color: Colors.green,),
                                                    onPressed: (){
                                                      setState(() {
                                                        if(widget.load.splits!=0){
                                                          widget.load.splits--;
                                                          widget.load.rate-=20;
                                                          rate-=20;
                                                        }
                                                      });
                                                    },
                                                  )
                                                ],
                                              ),
                                              Text('${widget.load.splits}',style: TextStyle(fontSize: 20,)),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                //mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text('\$5',style: TextStyle(fontSize: 20,)),
                                                  SizedBox(width: 10,),
                                                  IconButton(
                                                    icon: Icon(Icons.add_circle,color: Colors.green,),
                                                    onPressed: (){
                                                      setState(() {
                                                        //widget.load.splits++;
                                                        widget.load.rate+=5;
                                                        rate+=5;
                                                        adjustment5+=5;
                                                      });
                                                    },
                                                  ),

                                                  IconButton(
                                                    icon: Icon(Icons.remove_circle,color: Colors.green,),
                                                    onPressed: (){
                                                      setState(() {
                                                        widget.load.rate-=5;
                                                        rate-=5;
                                                        adjustment5-=5;
                                                      });
                                                    },
                                                  )
                                                ],
                                              ),
                                              Text('\$$adjustment5',style: TextStyle(fontSize: 20,)),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                //mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text('\$1',style: TextStyle(fontSize: 20,)),
                                                  SizedBox(width: 10,),
                                                  IconButton(
                                                    icon: Icon(Icons.add_circle,color: Colors.green,),
                                                    onPressed: (){
                                                      setState(() {
                                                        //widget.load.splits++;
                                                        widget.load.rate+=1;
                                                        rate+=1;
                                                        adjustment1+=1;
                                                      });
                                                    },
                                                  ),

                                                  IconButton(
                                                    icon: Icon(Icons.remove_circle,color: Colors.green,),
                                                    onPressed: (){
                                                      setState(() {
                                                        widget.load.rate-=1;
                                                        rate-=1;
                                                        adjustment1-=1;
                                                      });
                                                    },
                                                  )
                                                ],
                                              ),
                                              Text('\$$adjustment1',style: TextStyle(fontSize: 20,)),
                                            ],
                                          ),
                                        )

                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: <Widget>[

                                Container(
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
                                    padding: const EdgeInsets.all(30.0),
                                    child: Column(
                                      children: <Widget>[
                                        Align(
                                            alignment: Alignment.topLeft,
                                            child: Text('DATE')),
                                        SizedBox(height: 10,),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              child: Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(Icons.calendar_today),
                                                    SizedBox(width: 6,),
                                                    Text('${loadDate.toString()}'=='null'?'${widget.load.date}':'${loadDate}'.split(' ')[0]),
                                                  ],
                                                ),
                                              ),
                                              onTap : ()async{
                                                final DateTime picked = await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(2015, 8),
                                                    lastDate: DateTime(2101));
                                                if (picked != null && picked != DateTime.now())
                                                  setState(() {
                                                    loadDate = picked;
                                                  });
                                              },
                                            ),
                                          ),
                                        ),
//                                              FlatButton(
//                                                child: Row(
//                                                  children: <Widget>[
//                                                    Icon(Icons.calendar_today),
//                                                    SizedBox(width: 6,),
//                                                    Text('${load.date.toString()}'=='null'?'${DateTime.now()}'.split(' ')[0]:'${load.date}'.split(' ')[0]),
//                                                    //Text("${load.date.toLocal()}".split(' ')[0]),
//                                                  ],
//                                                ),
//                                                onPressed: ()async{
//                                                  final DateTime picked = await showDatePicker(
//                                                      context: context,
//                                                      initialDate: DateTime.now(),
//                                                      firstDate: DateTime(2015, 8),
//                                                      lastDate: DateTime(2101));
//                                                  if (picked != null && picked != DateTime.now())
//                                                    setState(() {
//                                                      load.date = picked;
//                                                    });
//                                                },
//                                              ),
//
                                        SizedBox(height: 10,),
                                        TextFormField(
                                          initialValue: widget.load.order,
                                          decoration: InputDecoration(
                                              labelText: 'ORDER NUMBER'
                                          ),
                                          //validator: (val) => val.isEmpty ? 'Required*' : null,
                                          onSaved: (val) => widget.load.order = val,
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Container(
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
                                    padding: const EdgeInsets.all(30.0),
                                    child: Column(
                                      children: <Widget>[

                                        TextFormField(
                                          initialValue: widget.load.truck,
                                          decoration: InputDecoration(
                                              labelText: 'TRUCK NUMBER'
                                          ),
                                          validator: (val) => val.isEmpty ? 'Required*' : null,
                                          onSaved: (val) => widget.load.truck = val,
                                        ),
                                        TextFormField(
                                            initialValue: (widget.load.time).toString(),
                                            decoration: InputDecoration(
                                                labelText: 'WAITING TIME',
                                                hintText: 'Minutes past 1 Hour',
                                              suffixText: '\$${widget.load.waitingCharge}'
                                            ),
                                            keyboardType: TextInputType.number,
                                            //validator: (val) => val.isEmpty ? 'Required*' : null,
                                            onSaved: (val){
                                              if(val.isNotEmpty || val.toString().isNotEmpty) {
                                                widget.load.time =
                                                    int.parse(val);
                                                widget.load.waitingCharge= double.parse((widget.load.time / 3).toStringAsFixed(2));
                                                //totalRate = (totalRate + waitingCost);
                                                //widget.load.totalRate+=
                                              }else{
                                                widget.load.time= 0;
                                                widget.load.waitingCharge= 0;
                                               // widget.load.totalCost=widget.load.rate+0.0;

                                              }
                                            }
                                        ),
                                        TextFormField(
                                          initialValue: widget.load.comments,
                                          decoration: InputDecoration(
                                              labelText: 'COMMENTS'
                                          ),
                                          maxLines: 1,
                                          onSaved: (val){
                                            setState(() {
                                              widget.load.comments=val;
                                            });
                                          },
                                        ),





                                        SizedBox(height: 25,),


                                        ButtonTheme(
                                          minWidth: MediaQuery.of(context).size.width,

                                          child: RaisedButton(
                                              child: Text('SAVE CHANGES',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                              elevation: 0,
                                              color: Color(0xFF7e60e4),
                                              onPressed: ()=>_submitForm(context,widget.driverID)
                                            //onPressed: (){},
                                          ),
                                        ),
                                      ],
                                    ),

                                  ),
                                ),
                                SizedBox(height: 30,),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      //bottomNavigationBar: BottomNavBar(),

    );
  }



}
class Origin{
  String name;
  int rate;
  Origin({this.name,this.rate});
}
