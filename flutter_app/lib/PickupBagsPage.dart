import 'package:flutter/material.dart';
import '../util/APIManager.dart';
import 'AppState.dart';
import 'entities/Baggage.dart';

class PickupBagsPage extends StatefulWidget {
  @override
  _PickupBagsPageState createState() => _PickupBagsPageState();
}

class _PickupBagsPageState extends State<PickupBagsPage> {
  AppState appState = AppState();
  late List<Baggage> baggageList;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: APIManager.getBaggageList(appState.userID!),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          baggageList = snapshot.data as List<Baggage>;
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Your Baggage',
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
                            appState.ticket!.flight_id,
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Carousel " + appState.ticket!.carousel.toString(),
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      Expanded(flex: 20, child: _buildListView()),
                      TextButton(
                          onPressed: () {
                            // Buy a ticket for the selected flight
                            Navigator.pop(context,
                                true); // Pop this page with a done = true
                          },
                          child: Text("Done"))
                    ],
                  ),
                ),
              ));
        } else {
          return Scaffold(
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text("Baggage Claim"),
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
          );
        } // else
      },
    );
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
        itemCount: baggageList.length,
        itemBuilder: (context, i) {
          return _buildRow(bag: baggageList[i]);
        });
  }

  /// Build a ListTile for the given product
  Widget _buildRow({required Baggage bag}) {
    return ListTile(
      contentPadding: const EdgeInsets.all(1.0),

      // leading: getItemStateIcon(item),
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                flex: 4,
                child: Text(bag.id,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ))),
            SizedBox(
              width: 2.0,
            ),
          ]),
      onTap: () {
        // Do nothing
      },
    );
  }
}
