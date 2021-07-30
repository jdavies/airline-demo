import 'package:flutter/material.dart';
import '../util/APIManager.dart';
import 'AppState.dart';
import 'entities/LoginResponse.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'entities/Preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameCtl = TextEditingController();
  final passwordCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    decoration: BoxDecoration(
                        border: Border(),
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.circular(40.0)),
                    child: Image.asset(
                      'assets/images/icon.png',
                    )),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: usernameCtl,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: passwordCtl,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            TextButton(
              child: Text('Forgot Password',
                  style: TextStyle(color: Colors.blue, fontSize: 15)),
              onPressed: () {
                // Navigator.push(
                //     context, MaterialPageRoute(builder: (_) => HomePage()));
              },
            ),
            Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  child: Text('Login',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  onPressed: () {
                    showLoaderDialog(context);
                    Future<LoginResponse> loginResponse = APIManager.doLogin(
                        usernameCtl.text.toLowerCase(), passwordCtl.text);
                    loginResponse.then((value) => {handleLoginResponse(value)});
                  },
                )),
            SizedBox(
              height: 130,
            ),
            Text('New User? Create Account')
          ],
        ),
      ),
    );
  }

  void handleLoginResponse(LoginResponse response) {
    AppState appState = AppState();
    Navigator.pop(context); // Pop the progress dialog
    if (response.success) {
      print('Login success! userID = ' + response.userID!);
      Navigator.pop(context, response); // Pop the login page

      // Show a toast messge about the successful login.
      Fluttertoast.showToast(
          msg: "Login succeeded",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {});
      // showLoaderDialog(context); // Wait while we do the next REST call
    } else {
      // Login failed. Allow the user to try again.
      print('Login failed! userID = ' + response.loginErrorMessage!);
      appState.userID = null;
      appState.userName = null;
      Fluttertoast.showToast(
          msg: "Login failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  // Handle the response to our REST call to load the user preferences.
  void handlePreferencesResponse(Preferences response) {
    AppState appState = AppState();
    appState.preferences = response;
    // Navigator.pop(context); // Pop the drawer closed
    // Navigator.pop(context); // Pop the progress dialog
    print('Preferences loaded!');
    // Show a toast message about the successful login.
    Fluttertoast.showToast(
        msg: "Preferences loaded",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("logging in...")),
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
