class LoginResponse {
  // Was the user's login successful?
  bool success = false;

  // The userID of the person that has logged in.
  String? userID = null;

  // Any message that goes with a failed login attempt.
  // NULL if the login succeeded
  String? loginErrorMessage;

  // The user's common name
  String? name;
}
