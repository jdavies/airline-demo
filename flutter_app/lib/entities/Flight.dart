import 'Ticket.dart';

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

  // Document API specific fields
  late String flight_date;
  int bags_checked = 0;
  int miles_earned = 0;
  late String ticket;

  Flight(Ticket ticket) {
    this.id = ticket.flight_id;
    this.departure_gate = ticket.departure_gate;
    this.departure_time = ticket.departure_time;
    this.destination_city = ticket.destination_city;
    this.origin_city = ticket.origin_city;
    this.carousel = ticket.carousel;
    this.ticket = ticket.id;
    this.bags_checked = ticket.bags_checked;
    this.miles_earned = ticket.miles_earned;
  }

  Flight.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String;
    departure_gate = json['departure_gate'] as String;
    departure_time = json['departure_time'] as String;
    destination_city = json['destination_city'] as String;
    origin_city = json['origin_city'] as String;
    carousel = json['carousel'] as String;
  }

  Flight.fromJsonDocumentAPI(Map<String, dynamic> json) {
    id = json['flight'] as String;
    flight_date = json['flight_date'] as String;
    bags_checked = json['bags_checked'] as int;
    miles_earned = json['miles_earned'] as int;
    ticket = json['ticket'] as String;
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

  Map<String, dynamic> toJsonDocumentAPI() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['flight'] = id;
    data['flight_date'] = flight_date;
    data['bags_checked'] = bags_checked;
    data['miles_earned'] = miles_earned;
    data['ticket'] = ticket;
    return data;
  }
}
