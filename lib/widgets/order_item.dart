import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// as flag to add a prefix to avoid name clashes since we do need both orderItems
import '../providers/orders.dart' as ordProv;

class OrderItem extends StatefulWidget {
  const OrderItem(this.orderData, {Key key}) : super(key: key);

  final ordProv.OrderItem orderData;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            trailing: IconButton(
              icon:
                  _expanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
              onPressed: () {
                setState(() => _expanded = !_expanded);
              },
            ),
            title: Text('\$${widget.orderData.amount}'),
            subtitle: Text(DateFormat('dd/MM/yyyy hh:mm')
                .format(widget.orderData.dateTime)),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              // min takes the smallest of the 2 options
              height: min(
                  (widget.orderData.products.length * 20 + 10).toDouble(), 100),
              // listView is scrollable
              child: ListView(
                children: widget.orderData.products.map((product) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${product.quantity}x \$${product.price}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  );
                }).toList(),
              ),
            )
        ],
      ),
    );
  }
}
