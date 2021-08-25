import 'package:flutter/material.dart';
import '../util/APIManager.dart';
import 'AppState.dart';
import 'entities/Flight.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'entities/Ticket.dart';

class BuyTicketPage extends StatefulWidget {
  @override
  _BuyTicketPageState createState() => _BuyTicketPageState();
}

class _BuyTicketPageState extends State<BuyTicketPage> {
  AppState appState = AppState();
  String? origin_city, destination_city;
  final passwordCtl = TextEditingController();
  late List<String> cityList;
  List<Flight> flightList = List<Flight>.empty(growable: true);
  Flight? selectedFlight = null;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: APIManager.getCityList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          cityList = snapshot.data as List<String>;
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Buy A Ticket',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              flex: 5,
                              child: Text(
                                "From: ",
                                style: TextStyle(color: Colors.black),
                              )),
                          Expanded(
                            flex: 20,
                            child: DropdownButton<String>(
                              focusColor: Colors.white,
                              value: origin_city,
                              //elevation: 5,
                              style: TextStyle(color: Colors.white),
                              iconEnabledColor: Colors.black,
                              items: cityList.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                );
                              }).toList(),
                              hint: Text(
                                "Choose a city",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              onChanged: (String? value) {
                                setState(() {
                                  origin_city = value!;
                                  if (destination_city != null) {
                                    refreshFlightList(context, origin_city!,
                                        destination_city!);
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              flex: 5,
                              child: Text(
                                "To: ",
                                style: TextStyle(color: Colors.black),
                              )),
                          Expanded(
                            flex: 20,
                            child: DropdownButton<String>(
                              focusColor: Colors.white,
                              value: destination_city,
                              //elevation: 5,
                              style: TextStyle(color: Colors.white),
                              iconEnabledColor: Colors.black,
                              items: cityList.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                );
                              }).toList(),
                              hint: Text(
                                "Choose a city",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              onChanged: (String? value) {
                                setState(() {
                                  destination_city = value!;
                                });
                                refreshFlightList(
                                    context, origin_city!, destination_city!);
                              },
                            ),
                          ),
                        ],
                      ),
                      // Header for the list
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                                flex: 4,
                                child: Text("Flight",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.italic,
                                    ))),
                            SizedBox(
                              width: 2.0,
                            ),
                            Expanded(
                              flex: 2,
                              child: Text("Gate",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.italic,
                                  )),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text("Departs",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.italic,
                                  )),
                            ),
                          ]),
                      Expanded(flex: 20, child: _buildListView()),
                      TextButton(
                          onPressed: () {
                            // Buy a ticket for the selected flight
                            buyTicket();
                          },
                          child: Text("Buy Ticket"))
                    ],
                  ),
                ),
              ));
        } else {
          return Scaffold(
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text("Buy A Ticket"),
            ),
            body: Center(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/images/icon.png'),
                  Text(
                    'Loading...',
                    style: TextStyle(color: Colors.blue, fontSize: 18),
                  ),
                ],
              ),
            ),
            // floatingActionButton: FloatingActionButton(
            //   onPressed: _incrementCounter,
            //   tooltip: 'Increment',
            //   child: Icon(Icons.add),
            // ), // This trailing comma makes auto-formatting nicer for build methods.
          );
        } // else
      },
    );
  }

  buyTicket() {
    print("Buying a ticket for flight: " + selectedFlight!.id);
    Future<Ticket> ticket = APIManager.buyTicket(
        selectedFlight!, appState.userID!, appState.userName!);
    ticket.then((value) => handleTicketResponse(value));
  }

  void handleTicketResponse(Ticket ticket) {
    print("Purchased ticket ID: " + ticket.id);
    print("Carousel: " + ticket.carousel.toString());
    Navigator.pop(context, ticket); // Pop the login page
    // Show a toast messge about the successful login.
    Fluttertoast.showToast(
        msg: "Ticket puchased!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  // Build a ListView to show a list of products.
  Widget _buildListView() {
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(
              color: Colors.black,
              height: 1,
            ),
        shrinkWrap: true,
        padding: const EdgeInsets.all(2.0),
        itemCount: flightList.length,
        itemBuilder: (context, i) {
          return _buildRow(flight: flightList[i]);
        });
  }

  /// Build a ListTile for the given product
  Widget _buildRow({required Flight flight}) {
    return ListTile(
      contentPadding: const EdgeInsets.all(1.0),
      focusColor: Colors.amber,
      autofocus: true,
      tileColor: (selectedFlight == flight) ? Colors.amber : Colors.white,
      // leading: getItemStateIcon(item),
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                flex: 4,
                child: Text(flight.id,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ))),
            SizedBox(
              width: 2.0,
            ),
            Expanded(
              flex: 2,
              child: Text(flight.departure_gate,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                  )),
            ),
            Expanded(
              flex: 4,
              child: Text(flight.departure_time,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                  )),
            ),
          ]),
      onTap: () {
        setState(() {
          selectedFlight = flight;
        });
      },
    );
  }

  refreshFlightList(
      BuildContext context, String origin_city, String destination_city) {
    // First ensure that an origin and a destination are selected
    // if (origin_city != null && origin_city != 'Choose a city...') {
    //   if (destination_city != null && destination_city != 'Choose a city...') {
    showLoaderDialog(context);
    selectedFlight =
        null; // Can't have a selected flight if we are building the list!
    Future<List<Flight>> fList =
        APIManager.getFlights(origin_city, destination_city);
    fList.then((value) => {flightList = value});
    setState(() {});
    Navigator.pop(context); // Dismiss the loader dialog
    //   }
    // }
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: Text("fetching flight information...")),
        ],
      ),
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
