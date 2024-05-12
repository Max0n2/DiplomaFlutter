class ProductsModel {
  final String name;
  final double price;
  final double count;
  final double fullPrice;

  ProductsModel({
    required this.name,
    required this.price,
    required this.count,
    required this.fullPrice,
  });

  factory ProductsModel.fromFirestore(Map<String, dynamic> json) {
    return ProductsModel(
      name: json?['name'],
      price: json?['price'],
      count: json?['count'],
      fullPrice: json?['fullPrice'],
    );
  }
}