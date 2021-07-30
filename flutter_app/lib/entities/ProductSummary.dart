///
/// ProductSmmary
///
/// Provide a summary view of a product. This is mainly for use in lists.
/// Here is an exampke JSON format of a ProductSummary
/// {
///   "image": "https://images-na.ssl-images-amazon.com/images/I/71v8Md%2BkzjL._AC_SL1500_.jpg",
///   "price": 569.99,
///   "name": "Samsung Galaxy Tab S6",
///   "id": "112e8a35-ab6f-4293-8739-eee1e997ec69",
///   "category": "electronics/tablets",
/// }

class ProductSummary {
  /// If = '0' then this is a new product to be inserted
  late String id;
  late String name;
  late String category;

  /// All prices are stored in USD value
  late double price;

  /// A URL to an image of this product
  late String image;

  ProductSummary(
      {required this.id,
      required this.name,
      required this.category,
      required this.price,
      required this.image}) {}

  /// Named constructor for parsing an object from JSON
  ProductSummary.fromJson(Map<String, dynamic> json) {
    this.id = json['id'] as String;
    this.name = json['name'] as String;
    this.category = json['category'] as String;
    this.image = json['image'] as String;
    String priceStr = json['price'].toString();
    this.price = double.parse(priceStr);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    // data['seller_id'] = sellerId;
    data['name'] = name;
    data['category'] = category;
    data['price'] = price;
    data['image'] = image;
    // data['create_date'] = createDate;
    return data;
  }
}
