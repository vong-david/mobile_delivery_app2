import 'dart:ffi';

class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final String discountPercentage;
  final double rating;
  final String stock;
  final String thumbnail;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: json['price'],
      discountPercentage: json['discountPercentage'].toString(),
      rating: (json['rating'] as num).toDouble(),
      stock: json['stock'].toString(),
      thumbnail: json['thumbnail'].toString() ?? '',
    );
  }
}