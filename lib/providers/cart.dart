import 'package:flutter/foundation.dart';

class CartItem {
  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });

  final String id;
  final double price;
  int quantity;
  final String title;
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  double get totalPrice {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  // Counts the number of products in the cart, not the sum of thier quantities
  int get itemCount {
    return _items.length;
  }

  void addItem(String productId, double price, String title) {
    final itemAlreadyExists = _items.containsKey(productId);
    if (itemAlreadyExists) {
      _items.update(productId, (existingCartItem) {
        return CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            quantity: existingCartItem.quantity + 1,
            price: existingCartItem.price);
      });
    } else {
      _items.putIfAbsent(
        productId,
        () {
          return CartItem(
              id: DateTime.now().toString(),
              title: title,
              quantity: 1,
              price: price);
        },
      );
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleQuantity(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId].quantity > 1) {
      _items.update(productId, (existingCartItem) {
        return CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            quantity: existingCartItem.quantity - 1,
            price: existingCartItem.price);
      });
    }
    if (_items[productId].quantity == 1) {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
