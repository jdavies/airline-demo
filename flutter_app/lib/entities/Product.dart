// {
//   "image": "https://images-na.ssl-images-amazon.com/images/I/71v8Md%2BkzjL._AC_SL1500_.jpg",
//   "price": 569.99,
//   "name": "Samsung Galaxy Tab S6",
//   "id": "112e8a35-ab6f-4293-8739-eee1e997ec69",
//   "category": "electronics/tablets",
//   "create_date": "2021-06-06T00:04:40.273Z",
//   "seller_id": "e1e7e089-b449-4005-a452-663c3cabe525"
// }

class Product {
  late String id; // If = '0' then this is a new product to be inserted
  late String name;
  late String sellerId;
  late String category;
  late String description;
  late double price;
  late String image;
  late DateTime createDate;

  Product(
      {required this.id,
      required this.name,
      required this.sellerId,
      required this.category,
      required this.description,
      required this.price,
      required this.image}) {
    createDate = DateTime.now();
  }

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String;
    sellerId = json['seller_id'] as String;
    name = json['name'] as String;
    category = json['category'] as String;
    description = json['description'] as String;
    image = json['image'] as String;
    String priceStr = json['price'].toString();
    price = double.parse(priceStr);

    // create_date is returned as a Map
    Map<String, dynamic> createDateMap = json['create_date'];
    // Has 'nano' and 'epochseconds' field
    int epochSeconds = createDateMap['epochSecond'] as int;
    int milliseconds = epochSeconds * 1000;
    DateTime test = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    createDate = test;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['seller_id'] = sellerId;
    data['name'] = name;
    data['category'] = category;
    data['price'] = price;
    data['image'] = image;
    data['create_date'] = createDate;
    return data;
  }
}
