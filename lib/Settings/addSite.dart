import 'package:citypetro/addLoad/site.dart';
import 'package:citypetro/services/Database.dart';
import 'package:flutter/material.dart';
class AddSite extends StatefulWidget {

  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<AddSite> {
  Site site = new Site();


  bool processing =false;
  bool  done=false;

  Future updateRate() async{
    var ratesData =({
      'stationID':site.stationID.toString(),
      'city':site.city,
      'toronto':site.rateToronto.toString(),
      'oakville':site.rateOakville.toString(),
      'hamilton':site.rateHamilton.toString(),
      'nanticoke':site.rateNanticoke.toString(),

    });
    setState(() {
      processing=true;

    });
    bool response = await DatabaseService().addSite(site.stationID, ratesData);
    if(response){
      setState(() {

        done=true;
      });
      setState(() {
        processing=false;
      });
    }
//    Future.delayed(const Duration(seconds: 3), () {
//    Navigator.pop(context);
//    });
  }
  @override
  Widget build(BuildContext context) {

    return AlertDialog(

      content: SingleChildScrollView(
        child: new  Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('ADD SITE',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.grey[700]),),
            SizedBox(height: 10,),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Station ID",
              ),

              onChanged: (value){
                setState(() {
                  site.stationID=value;
                });
              },

            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "City",
              ),

              onChanged: (value){
                setState(() {
                  site.city=value;
                });
              },

            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: "Rate from Toronto"
              ),
              keyboardType: TextInputType.number,

              onChanged: (value){
                setState(() {
                  site.rateToronto=int.parse(value);
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: "Rate from Oakville"
              ),
              keyboardType: TextInputType.number,

              onChanged: (value){
                setState(() {
                  site.rateOakville=int.parse(value);
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: "Rate from Hamilton"
              ),
              keyboardType: TextInputType.number,

              onChanged: (value){
                setState(() {
                  site.rateHamilton=int.parse(value);
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: "Rate from Nanticoke"
              ),
              keyboardType: TextInputType.number,

              onChanged: (value){
                setState(() {
                  site.rateNanticoke=int.parse(value);
                });
              },
            ),

            SizedBox(height: 20,),
            ButtonTheme(
              minWidth: MediaQuery.of(context).size.width,

              child: RaisedButton(
                  child: !processing?!done?Text('ADD',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
                      :
                  Text('SUCCESSFULLY ADDED',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),):
                  Text('PROCESSING...',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
                  elevation: 0,
                  color: Color(0xFF7e60e4),
                  disabledColor: !done?Color(0xFF7e60e4):Color(0xFF5cb85c),
                  onPressed: !processing?!done?updateRate:null:null

              ),

            ),
            processing?LinearProgressIndicator():Container(),
            !processing?!done?ButtonTheme(
              minWidth: MediaQuery.of(context).size.width,
              child: OutlineButton(
                  child: Text('CANCEL',style: TextStyle(color: Color(0xFF7e60e4),fontWeight: FontWeight.bold),),
                  color: Color(0xFF7e60e4),
                  disabledBorderColor: Color(0xFF7e60e4),
                  highlightedBorderColor: Color(0xFF7e60e4),
                  borderSide: BorderSide(color: Color(0xFF7e60e4),width: 2),
                  onPressed: !processing?(){
                    setState(() {

                    });
                    Navigator.pop(context);
                  }:null
              ),
            ):ButtonTheme(
              minWidth: MediaQuery.of(context).size.width,

              child: OutlineButton(
                  child: Text('OK',style: TextStyle(color: Color(0xFF5cb85c),fontWeight: FontWeight.bold),),
                  color: Color(0xFF5cb85c),
                  disabledBorderColor: Color(0xFF7e60e4),
                  highlightedBorderColor: Color(0xFF5cb85c),
                  borderSide: BorderSide(color: Color(0xFF5cb85c),width: 2),
                  onPressed: (){
                    Navigator.pop(context);
                  }
              ),
            ):Container(),

          ],
        ),
      ),

    );
  }
}

