class LoadDetailObject{
  String order;
  String truck;
  String city;
  String stationID;
  int time;
  int rate;
  String date;
  int splits;
  double waitingCharge;
  String totalRate;
  String hst;
  String comments;
  String terminal;

  LoadDetailObject({this.totalRate,this.waitingCharge,this.rate,this.date,this.time,this.stationID,this.city,this.truck,this.order,this.splits,this.hst,this.comments,this.terminal});
}