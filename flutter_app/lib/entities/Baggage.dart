class Baggage {
  late String id;
  late String ticket_id;
  late String destination_city;
  late String origin_city;
  late String flight_id;
  late String image = "";
  late String passenger_id;
  late String passenger_name;
  late String carousel;

  Baggage() {}

  Baggage.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String;
    ticket_id = json['ticket_id'] as String;
    destination_city = json['destination_city'] as String;
    origin_city = json['origin_city'] as String;
    flight_id = json['flight_id'] as String;
    image = json['image'] as String;
    passenger_id = json['passenger_id'] as String;
    passenger_name = json['passenger_name'] as String;
    carousel = json['carousel'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ticket_id'] = ticket_id;
    data['destination_city'] = destination_city;
    data['origin_city'] = origin_city;
    data['flight_id'] = flight_id;
    data['image'] = image;
    data['passenger_id'] = passenger_id;
    data['passenger_name'] = passenger_name;
    data['carousel'] = carousel;
    return data;
  }
}
