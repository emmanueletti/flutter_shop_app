import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/cart.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../screens/cart_screen.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';

enum FilterOptions {
  Favourites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  ProductsOverviewScreen({Key key}) : super(key: key);

  static const routeName = '/product-overview-screen';

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  // great example of where one would use a local state vs tapping into provider
  // global state - the show only favourite only matters for this widget
  var _showFavouritesOnly = false;

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.All) {
                  _showFavouritesOnly = false;
                } else {
                  _showFavouritesOnly = true;
                }
              });
            },
            itemBuilder: (_) {
              return [
                PopupMenuItem(
                    child: Text('Only Favourites'),
                    value: FilterOptions.Favourites),
                PopupMenuItem(
                    child: Text('Show All'), value: FilterOptions.All),
              ];
            },
            icon: Icon(Icons.more_vert),
          ),
          // Using the Consumer pattern b/c only this small part of the widget
          // needs access to the provided cart. If one used the provider.of
          // method, then the whole widget would rebuild whenever cart changes
          // here only the part of the widget "Consuming" the provided objects
          // data needs to be rebuilt
          // "child" property is advanced magic (Lesson 203)
          Consumer<Cart>(
            builder: (context, cartData, child) {
              return Badge(
                child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, CartScreen.routeName);
                  },
                  icon: Icon(Icons.shopping_cart),
                ),
                value: cartData.itemCount.toString(),
              );
            },
          )
        ],
      ),
      body: ProductsGrid(_showFavouritesOnly),
    );
  }
}
