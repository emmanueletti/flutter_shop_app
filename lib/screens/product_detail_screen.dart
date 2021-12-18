import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/products_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key key}) : super(key: key);

  static const routeName = '/product-detail-screen';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as Map;
    // Listen set to false, tells provider not to rebuild this widget if the
    // productsProvider's data changes - this widget is thus not an active
    // listener - it just gest built on its initial render and doesn't change
    // till user comes back to the screen.
    // This is done for optimization - do this when you only want to get data once
    // on build but not interested in updates
    final productsData = Provider.of<ProductsProvider>(context, listen: false);
    final product = productsData.findById(args['productId']);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
    );
  }
}
