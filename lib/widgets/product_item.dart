import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/cart.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key key,
    // @required this.id,
    // @required this.title,
    // @required this.imageUrl,
  }) : super(key: key);

  // final String id;
  // final String imageUrl;
  // final String title;

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    // Listen is false b/c we dont want to rebuild widget on changes to cart
    // only want to dispatch changes to the cart
    final cart = Provider.of<Cart>(context, listen: false);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          ProductDetailScreen.routeName,
          arguments: {"productId": product.id},
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: Image.network(product.imageUrl, fit: BoxFit.cover),
          footer: GridTileBar(
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.black87,
            leading: IconButton(
              icon: Icon(
                product.isFavourite ? Icons.favorite : Icons.favorite_border,
              ),
              color: Theme.of(context).accentColor,
              onPressed: () => product.toggleFavouriteStatus(),
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              color: Theme.of(context).accentColor,
              onPressed: () =>
                  cart.addItem(product.id, product.price, product.title),
            ),
          ),
        ),
      ),
    );
  }
}
