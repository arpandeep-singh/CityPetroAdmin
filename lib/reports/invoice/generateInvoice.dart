import 'package:citypetro/constraints.dart';
import 'package:citypetro/reports/invoice/driver.dart';
import 'package:citypetro/reports/invoice/invoiceTemplate.dart';
import 'package:citypetro/services/Database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class CreateInvoice extends StatefulWidget {
  final String uid;
  CreateInvoice({@required this.uid});
  @override
  _CreateInvoiceState createState() => _CreateInvoiceState();
}

class _CreateInvoiceState extends State<CreateInvoice> {
  File invoiceFile;
  QuerySnapshot loads;
  String generatedPdfFilePath='';
  bool _processing=false;
  double adjustment=0;
  String company='CITY PETROLEUM INC.';
  double rate=0;
  double waitingCost=0;
  String fileName='';
  String period='';

  bool invoiceSubmitting=false;


  DateTime now = DateTime.now();
  DateTime dateTo=DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,0,0,0,0,0);
  int day = DateTime.now().day;
//    if(day>=1 && day<=15){
//      dateTo=DateTime(DateTime.now().year,DateTime.now().month,0,0,0,0,0,0);
//    }else if(day>15){
//      dateTo=DateTime(DateTime.now().year,DateTime.now().month,0,15,0,0,0,0);
//    }
  DateTime dateFrom=new DateTime(DateTime.now().subtract(new Duration(days: 15)).year,
      DateTime.now().subtract(new Duration(days: 15)).month,
      DateTime.now().subtract(new Duration(days: 15)).day,0,0,0,0,0);

  Future<void> openFile() async {
    await pdfAsset(generatedPdfFilePath).then((file){

      OpenFile.open(file.path);});
  }

  Future<File> pdfAsset(String path) async {
    File tempFile = File(path);
    ByteData bd = await rootBundle.load(tempFile.path.toString());
    await tempFile.writeAsBytes(bd.buffer.asUint8List(), flush: true);
    return tempFile;
  }

  void showMessage(String message, MaterialColor color) {
    Scaffold.of(context)
        .showSnackBar(new SnackBar(backgroundColor: color, content: new Text(message)));
  }

  Future submitInvoice() async{
    setState(() {
     invoiceSubmitting=true;
    });
    Driver driver = await DatabaseService().getDriver(widget.uid);
    String invoiceURL = await DatabaseService(uid: widget.uid).uploadInvoiceAndGetURL(invoiceFile, driver.name, fileName);
      bool invoiceSubmitStatus = await DatabaseService(uid: widget.uid).submitInvoice(invoiceURL, period);
    if(invoiceSubmitStatus==true){
      setState(() {
        invoiceSubmitting=false;
      });
     showMessage('Load Submitted Successfully', Colors.green);
    }else{
     showMessage('A problem occured, please try again !', Colors.red);
    }

  }



  @override
  void initState() {
    super.initState();
    print('Invoice rebuilt');
   // generateExampleDocument();
  }

  Future<bool> loadResults() async{
    setState(() {
      waitingCost=0;
      rate=0;

    });
     print(widget.uid);
    bool loaded = await Firestore.instance.collection('Users').document(this.widget.uid).collection('Loads')
        .orderBy("date",descending: true)
        .where('date',isGreaterThanOrEqualTo: dateFrom)
        .where('date',isLessThanOrEqualTo: dateTo)
        .getDocuments().then((results){
          print(results.toString());
      setState(() {
        loads=results;
        for(var i=0;i<loads.documents.length;i++){
          rate+=((loads.documents[i].data['rate']));
          waitingCost+=loads.documents[i].data['waitingCost'];
        }
      });
      print('$rate $waitingCost ');
      return true;
    }

    );
    return loaded;

  }
  Future<void> generateExampleDocument() async {
     setState(() {
       _processing=true;
     });
     bool loaded = await loadResults();
     if(loaded){
       print('Load: $loads');
     }else{
       print('error');
     }
    Driver driver = await DatabaseService().getDriver(widget.uid);
    HtmlFile html = new HtmlFile(
        driver: driver,company:company,
        load: loads,
        dateFrom: new DateFormat('dd-MM-yyyy').format(dateFrom),
        dateTo: new DateFormat('dd-MM-yyy').format(dateTo),
        rate: rate,
        waitingCost: waitingCost,
        adjustment: adjustment
    );
    setState(() {
      period='${DateFormat.yMMMd().format(dateFrom)}-${DateFormat.yMMMd().format(dateTo)}';
      fileName='${driver.name.toUpperCase()}-($period)';
    });
   String htmlContent = await html.invoiceHtml();


    Directory appDocDir = await getApplicationDocumentsDirectory();
    var targetPath = appDocDir.path;
    var targetFileName = DateTime.now().toString();

    var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
        htmlContent, targetPath, targetFileName);
    setState(() {
      _processing=false;
      generatedPdfFilePath = generatedPdfFile.path;
      invoiceFile=generatedPdfFile;

    });

  }



  @override
  Widget build(BuildContext context) {

    var size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(13),
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
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
                                if (picked != null && picked!=dateFrom)
                                  setState(() {
                                    dateFrom = picked;
                                  });
                                print(dateFrom);
                                print(dateTo);
                                //loadResults(context,user.uid);
                              },
                            ),

                            Text('TO'),
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
                                if (picked != null && picked!=dateTo)
                                  setState(() {
                                    dateTo = picked;
                                  });
                                print(dateFrom.toLocal());
                                print(dateTo.toLocal());
                                //loadResults(context,user.uid);
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('COMPANY: '),
                    DropdownButton<String>(
                      value: company,
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          company = newValue;
                        });
                      },
                      items: <String>['CITY PETROLEUM INC.', '2408612 ONTARIO INC.']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                          ],
                        ),
                        TextField(
                          decoration: InputDecoration(
                            labelText: "Adjustment in \$",
                            suffixText: '\$',

                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (val){
                            setState(() {
                              adjustment=double.parse(val);
                            });
                          },

                        ),
                        ButtonTheme(
                          minWidth: MediaQuery.of(context).size.width,

                          child: RaisedButton(
                              child: Text('GENERATE INVOICE',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                              elevation: 0,
                              color: Color(0xFF7e60e4),
                              onPressed: generateExampleDocument

                          ),
                        ),

                        _processing?LinearProgressIndicator():Container(),
                        generatedPdfFilePath.isEmpty?Container():ButtonTheme(
                          minWidth: MediaQuery.of(context).size.width,

                              child: OutlineButton(
                              child: Text('VIEW INVOICE',style: TextStyle(color: Color(0xFF7e60e4),fontWeight: FontWeight.bold),),
                              color: Color(0xFF7e60e4),
                              disabledBorderColor: Color(0xFF7e60e4),
                              highlightedBorderColor: Color(0xFF7e60e4),
                              borderSide: BorderSide(color: Color(0xFF7e60e4),width: 2),
                              onPressed: (){
                                openFile();
                              }
                          ),
                        ),
                        SizedBox(height: 30,),
                        generatedPdfFilePath.isEmpty?Container():ButtonTheme(
                          minWidth: MediaQuery.of(context).size.width,

                          child: RaisedButton(
                              child: Text('SUBMIT',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                              elevation: 0,
                              color: Color(0xFF7e60e4),
                              onPressed: submitInvoice

                          ),
                        ),
                        invoiceSubmitting==true?LinearProgressIndicator():Container()
//                        generatedPdfFilePath.isEmpty?Container():ConfirmationSlider(
//                          onConfirmation: (){},
//                          width: size.width,
//                          text: 'SLIDE TO SUBMIT',
//                          textStyle: TextStyle(color: Color(0xFF7e60e4),fontWeight: FontWeight.bold),
//                          foregroundColor: Color(0xFF7e60e4),
//                          height: 60,
//                        )

                        //LinearProgressIndicator()
                      ],
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),


    );

  }
}
