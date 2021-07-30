# Airline Demo

This is a Flutter client for the Airline demo.

## Getting Started

Before this project will compile, you will need to create a credentials.dart file in the lib/util/ folder. The credentials.dart fle should look like the following:

```dart
class Credentials {
  static const String ASTRA_DB_ID = '<your ASTRA_D_ID>';
  static const String ASTRA_DB_REGION = '<your DB region>';
  static const String ASTRA_DB_KEYSPACE = 'airline';
  static const String APP_TOKEN =
      '<your app token>';
}
```

Be sure everything is enclosed with the single quotes. Once you have this file created, you can compile and run your own verdion of the Airline Demo.
