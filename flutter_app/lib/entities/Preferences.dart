import 'dart:convert';

// Preferences
//
// These are the users preferences for the applcation.
// They are stored using the Document API in Astra DB
// Author: Jeff Davies (jeff.davies@datastax.com)
//
// Example JSON
// { "useMetric" : true }

class Preferences {
  // Use metric unit? If false, then Imperial units should be used
  bool useMetric = false;

  // Default to a 12 hour clock (AP/PM)
  bool use24HourClock = false;

  Preferences() {}

  fromJson(Map<String, dynamic> json) {
    useMetric = json['useMetric'] as bool;
    use24HourClock = json['use24HourClock'] as bool;
    // sellerId = json['seller_id'] as String;
    // name = json['name'] as String;
    // category = json['category'] as String;
    // description = json['description'] as String;
    // image = json['image'] as String;
    // price = double.parse(json['price'].toString());

    // String createDateStr = json['create_date'] as String;
    // createDate = DateTime.parse(createDateStr);

    // final DateFormat formatter = DateFormat('yyyy-MM-dd');
    // final String formatted = formatter.format(createDate);
    // print(formatted); // something like 2013-04-20
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['useMetric'] = useMetric;
    data['use24HourClock'] = use24HourClock;
    // data['seller_id'] = sellerId;
    // data['name'] = name;
    // data['category'] = category;
    // data['price'] = price;
    // data['image'] = image;
    // data['createDate'] = createDate;
    return data;
  }

  String toJsonString() {
    Map<String, dynamic> data = toJson();
    String result;
    result = json.encode(data);
    return result;
  }
}
