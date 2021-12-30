import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/products_provider.dart';
import 'package:flutter_shop_app/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  const UserProductItem({
    Key key,
    @required this.id,
    @required this.title,
    @required this.imageUrl,
  }) : super(key: key);
  final String id;
  final String title;
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context, listen: false);
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, EditProductScreen.routeName,
                    arguments: id);
              },
              icon: Icon(Icons.edit),
              color: Theme.of(context).errorColor,
            ),
            IconButton(
              onPressed: () {
                products.deleteProduct(id);
              },
              icon: Icon(Icons.delete),
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
