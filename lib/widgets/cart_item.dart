import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/cart.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    Key key,
    @required this.id,
    @required this.productId,
    @required this.price,
    @required this.quanity,
    @required this.title,
  }) : super(key: key);

  final String id;
  final String productId;
  final double price;
  final int quanity;
  final String title;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);

    return Dismissible(
      // Super important for dismissible to be given a key - to prevent state bugs
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      // confirmdismiss wants a bool at the end
      confirmDismiss: (direction) {
        // ShowDialog returns a future who's value we can configure
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Are you sure?'),
                content: Text('Do you want to remove the item from the cart'),
                actions: [
                  FlatButton(
                      onPressed: () {
                        // Remember .pop takes the value it can pass to a
                        // reciever - here a bool result is specified
                        Navigator.of(context).pop(false);
                      },
                      child: Text('No')),
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text('Yes'))
                ],
              );
            });
      },
      onDismissed: (direction) => cart.removeItem(productId),
      child: Card(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                child: FittedBox(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('\$${price}'),
                )),
              ),
              title: Text(title),
              subtitle: Text('Total: \$${price * quanity}'),
              trailing: Text('$quanity x'),
            ),
          )),
    );
  }
}
