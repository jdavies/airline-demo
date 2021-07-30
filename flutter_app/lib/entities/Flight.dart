/// Flight.dart
/// This class represents a single flight record in the flight_by_id or the
/// flight_by_city tables
class Flight {
  late String id;
  late String departure_gate;
  late String departure_time;
  late String destination_city;
  late String origin_city;
  late String carousel;

  Flight.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String;
    departure_gate = json['departure_gate'] as String;
    departure_time = json['departure_time'] as String;
    destination_city = json['destination_city'] as String;
    origin_city = json['origin_city'] as String;
    carousel = json['carousel'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['departure_gate'] = departure_gate;
    data['departure_time'] = departure_time;
    data['destination_city'] = destination_city;
    data['origin_city'] = origin_city;
    data['carousel'] = carousel;
    return data;
  }
}
