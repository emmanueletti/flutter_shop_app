import 'package:flutter/material.dart';
import '../widgets/product_item.dart';
import '../models/product.dart';

class ProductsOverviewScreen extends StatelessWidget {
  ProductsOverviewScreen({Key key}) : super(key: key);

  final List<Product> loadedProducts = DUMMY_PRODUCTS;
  static const routeName = '/product-overview-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Shop')),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        // Grid delegate defines how the grid should be structured
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: loadedProducts.length,
        itemBuilder: (BuildContext context, int index) {
          return ProductItem(
            id: loadedProducts[index].id,
            title: loadedProducts[index].title,
            imageUrl: loadedProducts[index].imageUrl,
          );
        },
      ),
    );
  }
}
