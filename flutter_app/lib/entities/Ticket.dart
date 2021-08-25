class Ticket {
  late String id;
  late String departure_gate;
  late String departure_time;
  late String destination_city;
  late String origin_city;
  late String checkin_time;
  late String flight_id;
  late String passenger_id;
  late String passenger_name;
  late String carousel;
  int bags_checked = 0;
  int miles_earned = 0;

  Ticket() {}

  Ticket.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String;
    departure_gate = json['departure_gate'] as String;
    departure_time = json['departure_time'] as String;
    destination_city = json['destination_city'] as String;
    origin_city = json['origin_city'] as String;
    checkin_time = json['checkin_time'] as String;
    flight_id = json['flight_id'] as String;
    passenger_id = json['passenger_id'] as String;
    passenger_name = json['passenger_name'] as String;
    carousel = json['carousel'] as String;
    if (json['bags_checked'] != null) {
      bags_checked = json['bags_checked'] as int;
    } else {
      bags_checked = 0;
    }

    if (json['miles_earned'] != null) {
      miles_earned = json['miles_earned'] as int;
    } else {
      miles_earned = 500;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['departure_gate'] = departure_gate;
    data['departure_time'] = departure_time;
    data['destination_city'] = destination_city;
    data['origin_city'] = origin_city;
    data['checkin_time'] = checkin_time;
    data['flight_id'] = flight_id;
    data['passenger_id'] = passenger_id;
    data['passenger_name'] = passenger_name;
    data['carousel'] = carousel;
    data['bags_checked'] = bags_checked;
    data['miles_earned'] = miles_earned;
    return data;
  }
}
