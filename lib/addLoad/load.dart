class Load{
  String stationID='';
  String city;
  int rate;
  DateTime date;
  String order;
  String truck;
  int waiting;
  double waitingCost;
  double totalCost;
  String comments;
  List<String>files;
  int splits;
  String terminal;
  Load({this.stationID,this.city,this.rate,this.date,this.order,this.truck,this.waiting,this.comments,this.files,this.splits,this.terminal});
}