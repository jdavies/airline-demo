// APIManager
//
// This class manages the interactions with the Stargate APIs. It uses REST.
// Document, and GraphQL APIs as appropriate.
//
// Author: Jeff Davies (jeff.davies@datastax.com)

import 'dart:convert';
import 'dart:core';
import 'package:airline_demo/entities/Baggage.dart';
import 'package:airline_demo/entities/Flight.dart';
import 'package:airline_demo/entities/Ticket.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import '../AppState.dart';
import '../entities/LoginResponse.dart';
import 'package:uuid/uuid.dart';

import 'credentials.dart';

class APIManager {
  static String _baseURL = 'https://' +
      Credentials.ASTRA_DB_ID +
      '-' +
      Credentials.ASTRA_DB_REGION +
      '.apps.astra.datastax.com';

  /*************
   * REST APIs *
   *************/

  static Future<LoginResponse> doLogin(String username, String password) async {
    final LoginResponse loginResponse = LoginResponse();

    // Encrypt the password
    var bytes1 = utf8.encode(password); // data being hashed
    var digest1 = sha256.convert(bytes1); // Hashing Process
    String encodedPW = digest1.toString();
    // print("Digest as bytes: ${digest1.bytes}");   // Print Bytes
    // print("Digest as hex string: $digest1");      // Print After Hashing
    String url = _baseURL +
        '/api/rest/v2/keyspaces/' +
        Credentials.ASTRA_DB_KEYSPACE +
        '/login/' +
        Uri.encodeComponent(username) +
        '/' +
        encodedPW +
        '?fields=id,name';

    final response = await http.get(Uri.parse(url), headers: {
      'accept': 'application/json',
      'X-Cassandra-Token': Credentials.APP_TOKEN
    });

    if (response.statusCode == 200) {
      // print(response.body);
      final jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        int count = jsonResponse['count'] as int;
        if (count != 1) {
          // Login failed
          loginResponse.success = false;
          loginResponse.loginErrorMessage =
              'User name or password is incorrect';
        } else {
          // The login succeeded
          // Iterate over the returned list
          final List<dynamic> returnedArray = jsonResponse['data'] as List;
          Map<String, dynamic> data = returnedArray.first;
          loginResponse.success = true;
          loginResponse.userID = data['id'];
          loginResponse.name = data['name'];
        }
      } else {
        // Error on the GET request
        // print(response.body);
      } // jsonResponse == null
    }
    return Future.value(loginResponse);
  }

  /// Get a list of cities that our airline flies to/from
  static Future<List<String>> getCityList() async {
    // This loads the default preferences.
    final List<String> cityList = List<String>.empty(growable: true);

    // Now lets make a call to the Document API and get the uer preferences
    // for this specific user
    String url = _baseURL +
        '/api/rest/v2/keyspaces/' +
        Credentials.ASTRA_DB_KEYSPACE +
        '/city/rows';

    final response = await http.get(Uri.parse(url), headers: {
      'accept': 'application/json',
      'X-Cassandra-Token': Credentials.APP_TOKEN
    });

    if (response.statusCode == 200) {
      // A successful response looks like the following:
      // {
      //   "count": 65,
      //   "data": [
      //     {
      //       "name": "Chicago IL"
      //     },
      //     {
      //       "name": "Mobile AL"
      //     },
      //     ...
      //   ]
      // }
      final jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        // int count = jsonResponse['count'] as int;
        final List<dynamic> returnedArray = jsonResponse['data'] as List;

        for (final city in returnedArray) {
          cityList.add(city["name"]);
        }
      } else if (response.statusCode == 404) {
        // Document not found. Likely a new user. Create a default preferences
        // settings object, store it in the DB and return it to the caller
        // Do nothing
      } else {
        // Error on the GET request
        // print(response.body);
      } // jsonResponse == null
    }
    cityList.sort();
    return Future.value(cityList);
  }

  /// Get a list of cities that our airline flies to/from
  static Future<List<Flight>> getFlights(
      String origin_city, String destination_city) async {
    // This loads the default preferences.
    final List<Flight> flightList = List<Flight>.empty(growable: true);

    // Now lets make a call to the REST API and get the list of flights for these cities
    String url = _baseURL +
        '/api/rest/v2/keyspaces/' +
        Credentials.ASTRA_DB_KEYSPACE +
        '/flight_by_city?where=';

    String whereClause =
        '{"origin_city": {"\$eq": "$origin_city"}, "destination_city": {"\$eq": "$destination_city"}}';

    // URL encode the where clause
    whereClause = Uri.encodeComponent(whereClause);

    final response = await http.get(Uri.parse(url + whereClause), headers: {
      'accept': 'application/json',
      'X-Cassandra-Token': Credentials.APP_TOKEN
    });

    if (response.statusCode == 200) {
      // A successful response looks like the following:
      // {
      //   "count": 10,
      //   "data": [
      //     {
      //       "origin_city": "Akron OH",
      //       "departure_gate": "A 01",
      //       "id": "ABC0260",
      //       "destination_city": "Dallas TX",
      //       "departure_time": "6:00 AM"
      //     },
      //     {
      //       "origin_city": "Akron OH",
      //       "departure_gate": "A 02",
      //       "id": "ABC0261",
      //       "destination_city": "Dallas TX",
      //       "departure_time": "7:00 AM"
      //     },
      //     ...
      //   ]
      // }

      final jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        // int count = jsonResponse['count'] as int;
        final List<dynamic> returnedArray = jsonResponse['data'] as List;

        for (final flight in returnedArray) {
          flightList.add(Flight.fromJson(flight));
        }
      } else if (response.statusCode == 404) {
        // Document not found. Likely a new user. Create a default preferences
        // settings object, store it in the DB and return it to the caller
        // Do nothing
      } else {
        // Error on the GET request
        // print(response.body);
      } // jsonResponse == null
    }
    // flightList.sort();
    return Future.value(flightList);
  }

  /// Buy a ticket for a specific flight
  static Future<Ticket> buyTicket(
      Flight flight, String userID, String name) async {
    // Create a ticket
    var uuid = Uuid();
    Ticket ticket = Ticket();
    ticket.id = uuid.v4();
    ticket.flight_id = flight.id;
    ticket.origin_city = flight.origin_city;
    ticket.destination_city = flight.destination_city;
    ticket.departure_gate = flight.departure_gate;
    ticket.departure_time = flight.departure_time;
    ticket.checkin_time = "";
    ticket.carousel = flight.carousel;
    ticket.passenger_id = userID;
    ticket.passenger_name = name;

    // Now lets make a call to the REST API to write out this ticket
    String url = _baseURL +
        '/api/rest/v2/keyspaces/' +
        Credentials.ASTRA_DB_KEYSPACE +
        '/ticket';

    final response = await http.post(Uri.parse(url),
        headers: {
          'accept': 'application/json',
          'X-Cassandra-Token': Credentials.APP_TOKEN
        },
        body: jsonEncode(ticket.toJson()));

    if (response.statusCode == 200) {
      // A successful response looks like the following:
      // {
      //   "id": "33330000-1111-1111-1111-000011110000"
      // }

      final jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        // int count = jsonResponse['count'] as int;
        ticket.id = jsonResponse['id'] as String;
      } else {
        // Error on the GET request
        // print(response.body);
      } // jsonResponse == null
    }
    // flightList.sort();
    return ticket;
  }

  /// Buy a ticket for a specific flight
  static Future<bool> checkIn(Ticket ticket, int numBags) async {
    // check in for this flight
    // Get the current time as a string
    print("Checking in with " + numBags.toString());
    AppState appState = AppState();
    var now = DateTime.now();
    int hour = now.hour % 12;
    String AMPM = now.hour > 12 ? "PM" : "AM";
    String timeString = hour.toString().padLeft(2, '0') +
        ":" +
        now.minute.toString().padLeft(2, '0') +
        " " +
        AMPM;
    Map<String, dynamic> checkIn = <String, dynamic>{};
    checkIn["checkin_time"] = timeString;

    // Now lets make a call to the REST API to write out this ticket
    String url = _baseURL +
        '/api/rest/v2/keyspaces/' +
        Credentials.ASTRA_DB_KEYSPACE +
        '/ticket/' +
        ticket.id;

    // Update the ticket with the checkin time
    final response = await http.put(Uri.parse(url),
        headers: {
          'accept': 'application/json',
          'X-Cassandra-Token': Credentials.APP_TOKEN
        },
        body: jsonEncode(checkIn));

    if (response.statusCode == 200) {
      // A successful response looks like the following:
      // {
      //   "data": {
      //     "checkin_time": "07:15 AM"
      //   }
      // }

      final jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        // Ok, lets create the baggage records
        url = _baseURL +
            '/api/rest/v2/keyspaces/' +
            Credentials.ASTRA_DB_KEYSPACE +
            '/baggage';
        var uuid = Uuid();
        for (int x = 0; x < numBags; x++) {
          Baggage bag = Baggage();
          bag.id = uuid.v4();
          bag.carousel = appState.ticket!.carousel;
          bag.destination_city = appState.ticket!.destination_city;
          bag.flight_id = appState.ticket!.flight_id;
          bag.image = ""; // Unused for now
          bag.origin_city = appState.ticket!.origin_city;
          bag.passenger_id = appState.ticket!.passenger_id;
          bag.passenger_name = appState.ticket!.passenger_name;
          bag.ticket_id = appState.ticket!.id;
          print("Creating baggage record id = " + bag.id);
          print("on carousel " + bag.carousel.toString());
          // POST the bag to create the record.
          final bagResponse = await http.post(Uri.parse(url),
              headers: {
                'accept': 'application/json',
                'X-Cassandra-Token': Credentials.APP_TOKEN
              },
              body: jsonEncode(bag.toJson()));
          print("Bag status code = " + bagResponse.statusCode.toString());
        }
      } else {
        // Error on the GET request
        // print(response.body);
      } // jsonResponse == null
    }
    return true;
  }

  /// Get a list of cities that our airline flies to/from
  static Future<List<Baggage>> getBaggageList(String passenger_id) async {
    // This loads the default preferences.
    final List<Baggage> baggageList = List<Baggage>.empty(growable: true);

    // Now lets make a call to the REST API and get the list of flights for these cities
    String url = _baseURL +
        '/api/rest/v2/keyspaces/' +
        Credentials.ASTRA_DB_KEYSPACE +
        '/baggage?where=';

    String whereClause = '{"passenger_id": {"\$eq": "$passenger_id"}}';

    // URL encode the where clause
    whereClause = Uri.encodeComponent(whereClause);

    final response = await http.get(Uri.parse(url + whereClause), headers: {
      'accept': 'application/json',
      'X-Cassandra-Token': Credentials.APP_TOKEN
    });

    if (response.statusCode == 200) {
      // A successful response looks like the following:
      // { "count": 1,
      //   "data": [
      //     {
      //       "image": "",
      //       "origin_city": "Akron OH",
      //       "passenger_id": "33330000-1111-1111-1111-000011110000",
      //       "id": "33330000-1111-1111-1111-000011110000",
      //       "carousel": "A 01",
      //       "ticket_id": "33330000-1111-1111-1111-000011110000",
      //       "destination_city": "Dallas TX",
      //       "passenger_name": "Demo",
      //       "flight_id": "ABC0260"
      //     }]
      // }

      final jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        // int count = jsonResponse['count'] as int;
        final List<dynamic> returnedArray = jsonResponse['data'] as List;

        for (final baggage in returnedArray) {
          baggageList.add(Baggage.fromJson(baggage));
        }
      } else if (response.statusCode == 404) {
        // Document not found. Likely a new user. Create a default preferences
        // settings object, store it in the DB and return it to the caller
        // Do nothing
      } else {
        // Error on the GET request
        // print(response.body);
      } // jsonResponse == null
    }
    // flightList.sort();
    return Future.value(baggageList);
  }

  /// Resets (deletes) all data created for the currently loged in user
  static Future<bool> resetData() async {
    // check in for this flight
    // Get the current time as a string
    print("Reseting data... ");
    AppState appState = AppState();

    // Find all tickets for this passenger
    String url = _baseURL +
        '/api/rest/v2/keyspaces/' +
        Credentials.ASTRA_DB_KEYSPACE +
        '/ticket' +
        "?where=";

    String whereClause = '{"passenger_id": {"\$eq": "${appState.userID}"}}';

    // URL encode the where clause
    whereClause = Uri.encodeComponent(whereClause);

    // Update the ticket with the checkin time
    final response = await http.get(Uri.parse(url + whereClause), headers: {
      'accept': 'application/json',
      'X-Cassandra-Token': Credentials.APP_TOKEN
    });

    if (response.statusCode == 200) {
      // A successful response looks like the following:
      // {
      //   "count": 1,
      //   "data": [
      //     {
      //       "checkin_time": "06:44 PM",
      //       "origin_city": "Albuquerque NM",
      //       "passenger_id": "11110000-1111-1111-1111-111100001111",
      //       "departure_gate": "A 02",
      //       "id": "cc977481-85b7-4a33-937d-d262382a7d6b",
      //       "carousel": "C 06",
      //       "departure_time": "7:00 AM",
      //       "destination_city": "Austin TX",
      //       "passenger_name": "Jeff Davies",
      //       "flight_id": "ABC0791"
      //     }
      //   ]
      // }

      final jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        // Process each ticket
        final List<dynamic> returnedArray = jsonResponse['data'] as List;

        for (final ticketJSON in returnedArray) {
          Ticket ticket = Ticket.fromJson(ticketJSON);
          deleteTicket(ticket);
        }
      }
    }

    // Ok, lets find all baggage records for this passenger
    url = _baseURL +
        '/api/rest/v2/keyspaces/' +
        Credentials.ASTRA_DB_KEYSPACE +
        '/baggage?where=';

    whereClause = '{"passenger_id": {"\$eq": "${appState.userID}"}}';
    final bagResponse = await http.get(Uri.parse(url + whereClause), headers: {
      'accept': 'application/json',
      'X-Cassandra-Token': Credentials.APP_TOKEN
    });

    if (bagResponse.statusCode == 200) {
      // Process each bag
      final jsonResponse2 = json.decode(bagResponse.body);
      final List<dynamic> returnedArray = jsonResponse2['data'] as List;

      for (final bagJSON in returnedArray) {
        Baggage bag = Baggage.fromJson(bagJSON);
        deleteBaggage(bag);
      }
    } else {
      // Error on the GET request
      // print(response.body);
    } // jsonResponse == null

    return true;
  }

  // Delete a single ticket from the database
  static void deleteTicket(Ticket ticket) async {
    // Find all tickets for this passenger
    String url = _baseURL +
        '/api/rest/v2/keyspaces/' +
        Credentials.ASTRA_DB_KEYSPACE +
        '/ticket/' +
        ticket.id;

    print("DELETE ticket URL: " + url);
    final response = await http.delete(Uri.parse(url), headers: {
      'accept': 'application/json',
      'X-Cassandra-Token': Credentials.APP_TOKEN
    });

    if (response.statusCode == 204) {
      print("Successfuly deleted the ticket record: " + ticket.id);
    } else {
      print("Error " +
          response.statusCode.toString() +
          " while deletng the ticket record: " +
          ticket.id);
    }
  }

  // Delete a single ticket from the database
  static void deleteBaggage(Baggage bag) async {
    // Find all tickets for this passenger
    String url = _baseURL +
        '/api/rest/v2/keyspaces/' +
        Credentials.ASTRA_DB_KEYSPACE +
        '/baggage/' +
        bag.flight_id +
        "/" +
        bag.id;

    print("DELETE bag URL: " + url);
    final response = await http.delete(Uri.parse(url), headers: {
      'accept': 'application/json',
      'X-Cassandra-Token': Credentials.APP_TOKEN
    });

    if (response.statusCode == 204) {
      print("Successfuly deleted the ticket record: " + bag.id);
    } else {
      print("Error " +
          response.statusCode.toString() +
          " while deletng the ticket record: " +
          bag.id);
    }
  }
}
