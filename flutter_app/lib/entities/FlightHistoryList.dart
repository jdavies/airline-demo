import 'FlightHistoryRecord.dart';

/// This class represents a single flight record the flight_history portion of the document.
class FlightHistoryList {
  late String name;
  List<FlightHistoryRecord> flightList =
      List<FlightHistoryRecord>.empty(growable: true);

  FlightHistoryList(String name) {
    this.name = name;
  }

  Map<String, dynamic> toJson() => {
        name: List<dynamic>.from(flightList.map((x) => x)),
      };

  addFlight(FlightHistoryRecord flight) {
    flightList.add(flight);
  }
}
