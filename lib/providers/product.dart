import 'package:flutter/foundation.dart';

/// Model definition (blueprint) for product objects

// Product now has changenotifier mixed in and can use the notifylistners
// method to let any widget that is listening to it (VIA PROVIDER PACKAGE
// as the middle-person) that state/data has changed
class Product with ChangeNotifier {
  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });

  final String description;
  final String id;
  final String imageUrl;
  final double price;
  final String title;
  // Not final b/c will be changeable after a product has been instantiated
  bool isFavourite;

  void toggleFavouriteStatus() {
    isFavourite = !isFavourite;

    // Equivalent of setState - this broadcasts that something has changed and
    // will alert Provider to mark widgets that listen to this object as dirty/
    // in need of calling build method
    notifyListeners();
  }
}
