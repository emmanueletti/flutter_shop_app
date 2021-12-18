import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key key}) : super(key: key);

  static const routeName = '/product-detail-screen';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as Map;
    final Product product =
        DUMMY_PRODUCTS.firstWhere((product) => product.id == args['productId']);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
    );
  }
}
