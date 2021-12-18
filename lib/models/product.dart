import 'package:flutter/foundation.dart';

/// Model definition (blueprint) for product objects

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  // Not final b/c will be changeable after a product has been instantiated
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });
}
