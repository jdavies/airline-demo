import 'package:flutter/material.dart';
import '../util/APIManager.dart';
import 'AppState.dart';
import 'entities/Flight.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CheckInPage extends StatefulWidget {
  @override
  _CheckInPageState createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  AppState appState = AppState();
  String? origin_city, destination_city;
  final passwordCtl = TextEditingController();
  late List<String> cityList;
  List<Flight> flightList = List<Flight>.empty(growable: true);
  Flight? selectedFlight = null;
  int numBags = 0; // Default to no bags being checked in

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
                  'Check-In',
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
                          Text(
                            "You are checking in for flight " +
                                appState.ticket!.flight_id,
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "How many bags are you checking?",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              flex: 5,
                              child: Text(
                                "Bags: ",
                                style: TextStyle(color: Colors.black),
                              )),
                          Expanded(
                            flex: 20,
                            child: DropdownButton<int>(
                              focusColor: Colors.white,
                              value: numBags,
                              //elevation: 5,
                              style: TextStyle(color: Colors.white),
                              iconEnabledColor: Colors.black,
                              items: <int>[0, 1, 2, 3, 4]
                                  .map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(
                                    value.toString(),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                );
                              }).toList(),
                              hint: Text(
                                "checking in?",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              onChanged: (int? value) {
                                setState(() {
                                  numBags = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                          onPressed: () {
                            // Buy a ticket for the selected flight
                            checkin(2);
                          },
                          child: Text("Check-In"))
                    ],
                  ),
                ),
              ));
        } else {
          return Scaffold(
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text("Check In"),
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

  checkin(int numBags) {
    print("checking in for flight: " + appState.ticket!.flight_id);
    APIManager.checkIn(appState.ticket!, numBags);
    Navigator.pop(context, true); // Pop this page with a checkin = true
    // Show a toast messge about the successful login.
    Fluttertoast.showToast(
        msg: "You're checked-in!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  // showLoaderDialog(BuildContext context) {
  //   AlertDialog alert = AlertDialog(
  //     content: new Row(
  //       children: [
  //         CircularProgressIndicator(),
  //         Container(
  //             margin: EdgeInsets.only(left: 7),
  //             child: Text("fetching flight information...")),
  //       ],
  //     ),
  //   );

  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }
}
