import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductsOverviewScreen extends StatelessWidget {
  ProductsOverviewScreen({Key key}) : super(key: key);

  final List<Product> loadedProducts = DUMMY_PRODUCTS;

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
