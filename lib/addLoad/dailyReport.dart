
import 'package:citypetro/constraints.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:citypetro/addLoad/load.dart';
import 'package:citypetro/addLoad/site.dart';
import 'package:citypetro/services/Database.dart';
import 'dart:io';
import 'package:citypetro/auhenticate/user.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

class DailyReport extends StatefulWidget {
  @override
  _DailyReportState createState() => _DailyReportState();
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

class _DailyReportState extends State<DailyReport> {


  TextEditingController _controller = new TextEditingController();

  QuerySnapshot sitesSnapshot;

  String filePath;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Load load= new Load(city:'',rate: -1,stationID:'',date: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,0,0,0,0,0),waiting: 0,splits: 0,terminal: 'TOR');

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
  void  _submitForm(BuildContext context,String uid,String name) async{
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      showMessage('Please fill out the missing details', Colors.red);
      print('Please fill out the missing details');
    }else if(load.stationID==''||load.city==''||load.rate==0||load.truck.toString().isEmpty||load.order.toString().isEmpty)
    {
      showMessage('Please select STATION ID',Colors.red);
    }
    else {
      form.save(); //This invokes each onSaved event
      print('Station ID: ${load.stationID}');
      print('City: ${load.city}');
      print('Rate: ${load.rate}');
      print('Date: ${load.date}');
      print('Order: ${load.order}');
      print('Truck: ${load.truck}');
      print('Waiting Time: ${load.waiting}');
      print('Waiting Cost: ${load.waitingCost}');
      print('Total Cost: ${load.totalCost}');
      print('Files: ${load.files}');
      print('Splits: ${load.splits}');
      print('Comments: ${load.comments}');
      print('Terminal: ${load.terminal}');

      Map<String,dynamic> loadData ={
        'stationID': load.stationID,
        'city':load.city,
        'rate':load.rate,
        'date':load.date,
        'order':load.order,
        'truck':load.truck,
        'waiting':load.waiting,
        'waitingCost':load.waitingCost,
        'totalRate':load.totalCost,
        'splitLoads':load.splits,
        'comments':load.comments,
        'terminal':load.terminal
      };
     // final List<String> linkList = await database.getLinks(documents, DateTime.now());
      showAlertDialog(context);
      bool done = await DatabaseService(uid: uid,name: name).submitLoad(loadData,documents,load.date);
      Navigator.pop(context);
      if(done==true){
        showMessage('Load Submitted Successfully!',Colors.green);
        print('Done!');
        form.reset();
        setState(() {
          fileURLs=[];
          load.stationID='';
          load.city='';
          load.rate=-1;
          documents=[];
          load.splits=0;
          load.date=null;
        });

      }else{
        showMessage('Oops! A problem occured',Colors.red);
      }

    }
  //_autoValidate=true;
  }


 // Future uploadImage(ImageSource source) async {

   // File  image = await ImagePicker.pickImage(source: source);

    //if(image!=null){
      //setState(() {
        //documents.add(image);
      //});
    //}


  //}


  Future pickDocument() async {

//    String path = await DocumentChooser.chooseDocument();
//    setState(()=>filePath=path);
  File file = await FilePicker.getFile(type: FileType.any);
  if(file!=null){
    setState(() {
      filePath=file.path;
      documents.add(file);
      print('${documents.length}');
    });
  }else{
    print('No file Selected');
  }

  }

  getDocuments() {
    //return List.generate(_documents.length, (i) => Text(_documents[i]));
    print('Path $filePath');
    database.uploadDocument(filePath, DateTime.now()).then((result){
      print('done');
    });
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
          sites.add(site);
//          Origin Toronto= new Origin(name: 'Toronto',rate: doc.data['rateToronto']);
//          Origin Oakville=new Origin(name:'Oakville')
        })
    );
    print(load.date);
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

        title: Text('Add Load'),
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
                                                                Text('${load.stationID}'.isEmpty?'SELECT':'${load.stationID}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.grey[700])),
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
                                                                    load.stationID = selected.stationID;
                                                                    load.city=selected.city;
                                                                    rateToronto=selected.rateToronto;
                                                                    rateOakville=selected.rateOakville;
                                                                    rateHamilton=selected.rateHamilton;
                                                                    rateNanticoke=selected.rateNanticoke;
                                                                    load.splits=0;
                                                                    load.rate=rateToronto;
                                                                    rate=selected.rateToronto;
                                                                    load.terminal='Toronto';
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
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Text('${load.city}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.grey[700]),),
                                                    load.rate==-1?Container():Text('\$${load.rate}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.grey[700]),),

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
                                            groupValue: load.rate-(load.splits*20),
                                            onChanged: (int value){
                                              if(value!=0){
                                                setState(() {
                                                  load.rate=value;
                                                  load.splits=0;
                                                  load.terminal='Toronto';
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

                                            value: rateOakville,
                                            groupValue: load.rate-(load.splits*20),
                                            onChanged: (int value){
                                              if(value!=0){
                                                setState(() {
                                                  load.rate=value;
                                                  load.splits=0;
                                                  load.terminal='Oakville';
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
                                            groupValue: load.rate-(load.splits*20),
                                            onChanged: (int value){
                                              if(value!=0){
                                                setState(() {
                                                  load.rate=value;
                                                  load.splits=0;
                                                  load.terminal='Hamilton';
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
                                            groupValue: load.rate-(load.splits*20),
                                            onChanged: (int value){
                                              if(value!=0){
                                                setState(() {
                                                  load.rate=value;
                                                  load.splits=0;
                                                  load.terminal='Nanticoke';
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
                                                                load.splits++;
                                                                load.rate+=20;
                                                                rate+=20;
                                                              });
                                                          },
                                                        ),

                                                        IconButton(
                                                          icon: Icon(Icons.remove_circle,color: Colors.green,),
                                                          onPressed: (){
                                                            setState(() {
                                                              if(load.splits!=0){
                                                                load.splits--;
                                                                load.rate-=20;
                                                                rate-=20;
                                                              }
                                                            });
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                    Text('${load.splits}',style: TextStyle(fontSize: 20,)),
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
                                                          Text('${load.date.toString()}'=='null'?'${DateTime.now()}'.split(' ')[0]:'${load.date}'.split(' ')[0]),
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
                                                          load.date = picked;
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
                                                decoration: InputDecoration(
                                                    labelText: 'ORDER NUMBER'
                                                ),
                                                validator: (val) => val.isEmpty ? 'Required*' : null,
                                                onSaved: (val) => load.order = val,
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
                                                decoration: InputDecoration(
                                                    labelText: 'TRUCK NUMBER'
                                                ),
                                                validator: (val) => val.isEmpty ? 'Required*' : null,
                                                onSaved: (val) => load.truck = val,
                                              ),
                                              TextFormField(
                                                  decoration: InputDecoration(
                                                      labelText: 'WAITING TIME',
                                                      hintText: 'Minutes past 1 Hour'
                                                  ),
                                                  keyboardType: TextInputType.number,
                                                  //validator: (val) => val.isEmpty ? 'Required*' : null,
                                                  onSaved: (val){
                                                    if(val.isNotEmpty || val.toString().isNotEmpty) {
                                                      load.waiting =
                                                          int.parse(val);
                                                      load.waitingCost = double.parse((load.waiting / 3).toStringAsFixed(2));
                                                      load.totalCost = (load.rate + load.waitingCost);
                                                    }else{
                                                      load.waiting = 0;
                                                      load.waitingCost = 0;
                                                      load.totalCost=load.rate+0.0;

                                                    }
                                                  }
                                              ),
                                              TextFormField(
                                                decoration: InputDecoration(
                                                    labelText: 'COMMENTS'
                                                ),
                                                maxLines: 1,
                                                onSaved: (val){
                                                  setState(() {
                                                    load.comments=val;
                                                  });
                                                },
                                              ),
                                              SizedBox(height: 15,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Text('PAPERWORK'),
                                                  documents.isEmpty?Text('0 Docuemnts'):Text('${documents.length} Document(s)')

                                                ],
                                              ),
//                                              Row(
//                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                children: <Widget>[
//                                                  FlatButton.icon(
//                                                      onPressed: uploadImage,
//                                                      icon: Icon(Icons.attach_file),
//                                                      //label: fileURLs.length==0?Text('Upload Paperwork'):Text('${documents.length} file(s) uploaded')),
//                                                     label: Text('${documents.length} file(s) uploaded')),
//                                                      //uploading?CircularProgressIndicator():Text('${fileURLs.length}')
//                                                ],
//                                              ),
                                             // _image!=null?_uploading?LinearProgressIndicator():Container():Container(),


                                              SizedBox(height: 25,),
                                              ButtonTheme(
                                                minWidth: MediaQuery.of(context).size.width,

                                                child: RaisedButton(
                                                    child: Text('UPLOAD PAPERWORK',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                                    elevation: 0,
                                                    color: Color(0xFF7e60e4),
                                                    onPressed: ()=>openBottomSheet(context)

                                                ),
                                              ),

                                              ButtonTheme(
                                                minWidth: MediaQuery.of(context).size.width,

                                                child: RaisedButton(
                                                    child: Text('SUBMIT',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                                    elevation: 0,
                                                    color: Color(0xFF7e60e4),
                                                    onPressed: ()=>_submitForm(context,user.uid,user.name)
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

  openBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera),
                title: Text("Camera"),
               // onTap: ()=>uploadImage(ImageSource.camera).then((result){
                 // Navigator.pop(context);
                //}),
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text("Photos"),
                 // onTap: ()=>uploadImage(ImageSource.gallery).then((result){
                   // Navigator.pop(context);
                  //}),
              ),

              ListTile(
                leading: Icon(Icons.insert_drive_file),
                title: Text("Pdf"),
                  onTap: ()=>pickDocument().then((result){
                    Navigator.pop(context);
                  })
              ),
              ListTile(
                  leading: Icon(Icons.link),
                  title: Text("Any"),
                  onTap: (){}
              ),
            ],
          );
        });
  }

}
class Origin{
  String name;
  int rate;
  Origin({this.name,this.rate});
}
