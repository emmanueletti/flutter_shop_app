import 'package:flutter/material.dart';
import 'package:flutter_shop_app/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key key,
    @required this.id,
    @required this.title,
    @required this.imageUrl,
  }) : super(key: key);

  final String id;
  final String imageUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          ProductDetailScreen.routeName,
          arguments: {"productId": id},
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: Image.network(imageUrl, fit: BoxFit.cover),
          footer: GridTileBar(
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.black87,
            leading: IconButton(
              icon: Icon(Icons.favorite),
              color: Theme.of(context).accentColor,
              onPressed: () {},
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              color: Theme.of(context).accentColor,
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
  }
}
