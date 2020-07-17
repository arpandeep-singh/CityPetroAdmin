class Station {
  final String stationID;
  final String city;
  final int rate;


  Station({this.stationID, this.city, this.rate});

  factory Station.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Station(
      stationID: json["id"],
      city: json["city"],
      rate: json["rate"],

    );
  }
  static List<Station> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => Station.fromJson(item)).toList();
  }

  @override
  String toString() => stationID;

  @override
  operator ==(o) => o is Station && o.stationID == stationID;

  @override
  int get hashCode => stationID.hashCode ^ city.hashCode ^ rate.hashCode;
}