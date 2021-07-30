import 'package:flutter/material.dart';

import 'entities/Preferences.dart';
import 'entities/Ticket.dart';

class AppState extends ChangeNotifier {
  String? userID = null; // Default to not logged in
  String? userName;
  bool _isLoaded = false;
  Ticket? ticket = null;
  bool isCheckedIn = false;
  bool hasFlown = false;
  Preferences preferences = Preferences();

  /// If [true], then show all times in the 24 hour format. Else show the 12 hour format
  bool _use24HourFormat = false;

  /// The format string to use when displaying dates
  // String _dateFormatString = "y/M/d";
  // static const String _timeFormatName = 'timeFormat';
  // static const String _dateFormatName = 'dateFormat';

  static final AppState _singleton = AppState._internal();

  bool isLoggedIn() {
    bool result = false; // Default to false
    if (userID != null && userID != '') {
      result = true;
    }
    return result;
  }

  // Log the user out of the session.
  void logout() {
    userID = null;
    userName = '';
  }

  void setUserInfo(String userID, String firstName) {
    this.userID = userID;
    this.userName = firstName;
  }

  /// Gets the users preference for displaying time in 24 hours or not
  bool get use24HourFormat => _use24HourFormat;

  /// Sets the users preference for displaying time in 24 hours or not
  set use24HourFormat(bool newVal) {
    _use24HourFormat = newVal;
    // _prefs.setBool(_timeFormatName, newVal);
  }

  factory AppState() {
    _singleton._loadPrefs();
    return _singleton;
  }

  /// Load the [SharedPrefences] for this app
  Future<bool> _loadPrefs() async {
    if (!_isLoaded) {
      // _prefs = await SharedPreferences.getInstance();
      // bool temp = _prefs.getBool(_timeFormatName);
      // if (temp != null) _use24HourFormat = temp;

      // final String tempStr = _prefs.getString(_dateFormatName);
      // if (tempStr != null) _dateFormatString = tempStr;

      _isLoaded = true;
    }
    return _isLoaded;
  }

  AppState._internal();
}
