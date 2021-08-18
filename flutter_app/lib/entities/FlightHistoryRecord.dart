/// Flight.dart
/// This class represents a single flight record in the flight_by_id or the
/// flight_by_city tables
class FlightHistoryRecord {
  late int bags_checked = 0;
  late String flight_date;
  late String flight;
  late int miles_earned = 0;
  late String ticket; // UUID of  te ticket

  FlightHistoryRecord.fromJson(Map<String, dynamic> json) {
    bags_checked = json['bags_checked'] as int;
    flight_date = json['flight_date'] as String;
    flight = json['flight'] as String;
    miles_earned = json['miles_earned'] as int;
    ticket = json['ticket'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bags_checked'] = bags_checked;
    data['flight_date'] = flight_date;
    data['flight'] = flight;
    data['miles_earned'] = miles_earned;
    data['ticket'] = ticket;
    return data;
  }
}
