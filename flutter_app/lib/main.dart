import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'AppState.dart';
import 'BuyTicketPage.dart';
import 'CheckInPage.dart';
import 'LoginPage.dart';
import 'PickupBagsPage.dart';
import 'entities/LoginResponse.dart';
import 'util/APIManager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application. It shows the "home" page for
  // users that may or may not be logged in.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Airline',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'My Airline'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AppState appState = AppState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'My Airline',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextButton(
                    onPressed: () async {
                      if (appState.isLoggedIn()) {
                        // Logout
                        setState(() {
                          appState.userID = null;
                        });
                      } else {
                        // Login
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                        setState(() {
                          LoginResponse info = result as LoginResponse;
                          appState.userID = info.userID;
                          appState.userName = info.name;
                        });
                      }
                    },
                    child:
                        appState.isLoggedIn() ? Text('Logout') : Text('Login')),
                TextButton(
                    onPressed: appState.isLoggedIn()
                        ? () async {
                            final ticket = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BuyTicketPage()));
                            setState(() {
                              appState.ticket = ticket;
                            });
                          }
                        : null,
                    child: Text('Buy Ticket')),
                TextButton(
                    onPressed: appState.ticket != null
                        ? () async {
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CheckInPage()));
                            setState(() {
                              appState = AppState();
                              appState.isCheckedIn = result;
                            });
                          }
                        : null,
                    child: Text('Checkin')),
                TextButton(
                    onPressed: appState.isCheckedIn
                        ? () {
                            Fluttertoast.showToast(
                                msg: "Enjoy your flight!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            setState(() {
                              appState = AppState();
                              appState.isCheckedIn = false;
                            });
                          }
                        : null,
                    child: Text('Fly!')),
                TextButton(
                    onPressed: appState.ticket != null
                        ? () async {
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PickupBagsPage()));
                            setState(() {
                              appState = AppState();
                              appState.isCheckedIn = result;
                            });
                          }
                        : null,
                    child: Text('Pickup Baggage')),
                TextButton(
                    onPressed: appState.isLoggedIn()
                        ? () async {
                            APIManager.resetData();
                            Fluttertoast.showToast(
                                msg: "Data reset!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        : null,
                    child: Text('Reset Data')),
              ],
            ),
          ),
        ));
  }
}
