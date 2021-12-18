import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid(this.showFavs, {Key key}) : super(key: key);
  final bool showFavs;
  @override
  Widget build(BuildContext context) {
    // Here we want listen property to remain default true b/c we want to rebuild
    // the grid when a new product is added or removed aka the products provider
    // object changes
    final productsData = Provider.of<ProductsProvider>(context);
    final products =
        showFavs ? productsData.favouriteItems : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      // Grid delegate defines how the grid should be structured
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) {
        return ChangeNotifierProvider.value(
          // SUPER IMPORTANT CONCEPT: Lesson 197
          // ANOTHER IMPORTANT CONCEPT: Lesson 198
          // - using .value constructor for changenotifierprovider for list / grid
          // builders is better - as avoids bugs caused with Flutter keeping tracking
          // of state when removing/adding/re-arranging widgets in a list/grid
          value: products[index],
          child: ProductItem(
              // Instead of passing constructor arguments, since
              // the single product is being "Provided" - can tap into
              // provider for the necesarry info needed by ProductItem

              // id: products[index].id,
              // title: products[index].title,
              // imageUrl: products[index].imageUrl,
              ),
        );
      },
    );
  }
}
