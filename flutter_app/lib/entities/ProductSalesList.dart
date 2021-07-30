///
/// This contains a list of individual sale records for a specific product,
/// as well as some of the product information suitable for display.
import 'ProductSale.dart';

class ProductSalesList {
  String id;
  late String name;
  late String imageURL;
  List<ProductSale> productSales = [];

  ProductSalesList(this.id) {}
}
