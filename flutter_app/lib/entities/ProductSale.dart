// {
//   "image": "https://images-na.ssl-images-amazon.com/images/I/71v8Md%2BkzjL._AC_SL1500_.jpg",
//   "price": 569.99,
//   "name": "Samsung Galaxy Tab S6",
//   "id": "112e8a35-ab6f-4293-8739-eee1e997ec69",
//   "category": "electronics/tablets",
//   "create_date": "2021-06-06T00:04:40.273Z",
//   "seller_id": "e1e7e089-b449-4005-a452-663c3cabe525"
// }

class ProductSale {
  late String product_id; // If = '0' then this is a new product to be inserted
  late String seller_id;
  late double salePrice;
  late DateTime saleDate;

  ProductSale(
      {required this.product_id,
      required this.seller_id,
      required this.salePrice}) {
    saleDate = DateTime.now();
  }

  ProductSale.fromJson(Map<String, dynamic> json) {
    product_id = json['product_id'] as String;
    seller_id = json['seller_id'] as String;
    String priceStr = json['sale_price'].toString();
    salePrice = double.parse(priceStr);

    // create_date is returned as a Map
    Map<String, dynamic> saleDateMap = json['sale_date'];
    // Has 'nano' and 'epochseconds' field
    int epochSeconds = saleDateMap['epochSecond'] as int;
    int milliseconds = epochSeconds * 1000;
    DateTime test = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    saleDate = test;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = product_id;
    data['seller_id'] = seller_id;
    data['price'] = salePrice;
    data['sale_date'] = saleDate;
    return data;
  }
}
