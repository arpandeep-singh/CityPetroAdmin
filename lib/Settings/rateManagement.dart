
import 'package:citypetro/Settings/addSite.dart';
import 'package:citypetro/services/Database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class ChangeRate extends StatefulWidget {
  @override
  _ChangeRateState createState() => _ChangeRateState();
}

class _ChangeRateState extends State<ChangeRate> {
  TextEditingController controller = new TextEditingController();
  String filter;
  QuerySnapshot sites;
  bool fetched=false;

  @override
  void initState(){
    super.initState();
    loadSites(context);
    controller.addListener((){
      setState(() {
        filter=controller.text;
      });
    });

  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  void loadSites(BuildContext context){
    Firestore.instance.collection('Rates').getDocuments().then((results){
      setState(() {
        sites=results;
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
        actions: <Widget>[

          FlatButton.icon(
            icon: Icon(Icons.add,color: Colors.white,),
            label: Text('ADD',style: TextStyle(color: Colors.white),),
            onPressed: () {
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (_) {
                    return AddSite();

                  });
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[700]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                child: new TextField(
                  decoration: new InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter Station ID'
                  ),
                  controller: controller,
                ),
              ),
            ),
          ),
          Expanded(child: _loadSite()),
        ],
      ),

    );
  }

  Widget _buildSite(var site,index){


      return  (filter == null || filter == "") ?ListTile(
            leading: CircleAvatar(
              child: Text(site.data['city'].toString()[0]),
            ),
            title: Text(site.data['stationID'].toString(),style: TextStyle(fontSize: 18.0),),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(site.data['city'].toString().toUpperCase()),
                Text(" T: \$"+site.data['rateToronto']
                    +" O: \$"+site.data['rateOakville']+" H: \$"+site.data['rateHamilton']
                    +" N: \$"+site.data['rateNanticoke'])
              ],
            ), onTap: (){
        print(site.documentID);
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) {
              return MyDialog(  siteID: site.documentID,
                  city: site.data['city'],
                  rT: int.parse(site.data['rateToronto'].toString()),
                  rO:int.parse(site.data['rateOakville'].toString()),
                  rH:int.parse(site.data['rateHamilton'].toString()),
                  rN:int.parse(site.data['rateNanticoke'].toString())
              );

            });
      },
        ):sites.documents[index].documentID.startsWith(filter)?ListTile(
        leading: CircleAvatar(
          child: Text(site.data['city'].toString()[0]),
        ),
        title: Text(site.data['stationID'].toString(),style: TextStyle(fontSize: 18.0),),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(site.data['city'].toString().toUpperCase()),
            Text(" T: \$"+site.data['rateToronto']
                +" O: \$"+site.data['rateOakville']+" H: \$"+site.data['rateHamilton']
                +" N: \$"+site.data['rateNanticoke'])
          ],
        ),
        onLongPress: (){
          print(site.documentID);
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) {
                return MyDialog(
                  siteID: site.documentID,
                  city: site.data['city'],
                  rT: int.parse(site.data['rateToronto'].toString()),
                rO:int.parse(site.data['rateOakville'].toString()),
                rH:int.parse(site.data['rateHamilton'].toString()),
                rN:int.parse(site.data['rateNanticoke'].toString())
                    );

              });
        },
    ):new Container();
  }

  Widget _loadSite(){
    if(sites!=null){
      return ListView.builder(
        itemCount: sites.documents.length,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (BuildContext context,int i){
          //var tempUser=users.documents[i];
          //if(i.isOdd)return Divider();
          final index= i;
          var tempUser=sites.documents[index];
          return _buildSite(tempUser,index);
        },
      );
    }else{
      return Center(child: Text('Loading'));
    }
  }
}

class MyDialog extends StatefulWidget {
  final String siteID;
   String city;
  int rT;
  int rO;
  int rH;
  int rN;

  MyDialog({@required this.siteID,this.city,this.rT,this.rO,this.rH,this.rN});
  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {

  bool processing =false;
  bool  done=false;

  Future updateRate() async{
    var ratesData =({
      'city':widget.city.toString(),
      'toronto':widget.rT.toString(),
      'oakville':widget.rO.toString(),
      'hamilton':widget.rH.toString(),
      'nanticoke':widget.rN.toString(),

    });
    setState(() {
      processing=true;

    });
    bool response = await DatabaseService().updateRate(widget.siteID, ratesData);
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
            Text('UDATE SITE RATE #${widget.siteID}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.grey[700]),),
            SizedBox(height: 10,),

            TextFormField(
              decoration: InputDecoration(
                  labelText: "City",
              ),
              initialValue: widget.city,
              onChanged: (value){
                setState(() {
                  widget.city=value;
                });
              },

            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Rate from Toronto"
              ),
              keyboardType: TextInputType.number,
              initialValue: widget.rT.toString(),
              onChanged: (value){
                setState(() {
                  widget.rT=int.parse(value);
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: "Rate from Oakville"
              ),
              keyboardType: TextInputType.number,
              initialValue: widget.rO.toString(),
              onChanged: (value){
                setState(() {
                  widget.rO=int.parse(value);
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: "Rate from Hamilton"
              ),
              keyboardType: TextInputType.number,
              initialValue: widget.rH.toString(),
              onChanged: (value){
                setState(() {
                  widget.rH=int.parse(value);
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: "Rate from Nanticoke"
              ),
              keyboardType: TextInputType.number,
              initialValue: widget.rN.toString(),
              onChanged: (value){
                setState(() {
                  widget.rN=int.parse(value);
                });
              },
            ),

            SizedBox(height: 20,),
            ButtonTheme(
              minWidth: MediaQuery.of(context).size.width,

              child: RaisedButton(
                child: !processing?!done?Text('UPDATE',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
                    :
                Text('SUCCESSFULLY UPDATED',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),):
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

