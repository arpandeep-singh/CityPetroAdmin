import 'package:cloud_firestore/cloud_firestore.dart';

class Site{
  String stationID;
  String city;
  int rateToronto;
  int rateOakville;
  int rateHamilton;
  int rateNanticoke;
  Site({this.stationID,this.city,this.rateToronto,this.rateHamilton,this.rateOakville,this.rateNanticoke});

  @override
  String toString() => stationID;

  @override
  operator ==(o) => o is Site && o.stationID == stationID;


}