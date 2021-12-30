import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shop_app/models/http_exception.dart';
import './product.dart';
// Using the 'as' to avoid name clashes as the http package exposes alot of
// other functions
import 'package:http/http.dart' as http;

// ChangeNotifier is a class built in to Flutter which is related to the
// magical "InheritedWidget" that is used in conjuction with the context object
// to establish communication tunnels between the widgets.
// Provider package uses "InheritedWidget" behind the scenes through the
// ChangeNotifier

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<Product> get items {
    return [..._items];
  }

  // Can centralize logic for working with data found in the provider object
  // for maximum code re-useability and cleanliness - OOP
  Product findById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  List<Product> get favouriteItems {
    return _items.where((item) => item.isFavourite).toList();
  }

  Future<void> addProduct(Product product) {
    // http update to firebase
    final url = Uri.parse(
        'https://flutter-shop-app-ef265-default-rtdb.firebaseio.com/products.json');
    return http
        .post(
      url,
      body: jsonEncode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'isFavourite': product.isFavourite,
      }),
    )
        .then((resp) {
      // local update
      final newProduct = Product(
        id: jsonDecode(resp.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    }).catchError((err) {
      throw err;
    });
  }

  Future<void> updateProduct(Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == newProduct.id);
    if (prodIndex < 0) return;
    final url = Uri.parse(
        'https://flutter-shop-app-ef265-default-rtdb.firebaseio.com/products/${newProduct.id}.json');
    await http.patch(url,
        body: jsonEncode({
          'title': newProduct.title,
          'description': newProduct.description,
          'price': newProduct.price,
          'imageUrl': newProduct.imageUrl,
        }));
    _items[prodIndex] = newProduct;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://flutter-shop-app-ef265-default-rtdb.firebaseio.com/products/${id}.json');

    // Optimistic Updating Pattern in delete operations:
    // First store a pointer to the data before deleting from database.
    // Then delete update the local data with the deletion
    // if error occurs in the database deletion operation, we can roll back
    // deletion using the saved pointer.
    // Since existingProduct is still pointing to the data in memory
    // dart does not garbage collect it when it is removed from the _items array
    //
    // Optimistic Updating basically means - make the change locally right away
    // and only roll back if the network update failed
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    await http.delete(url).then((resp) {
      // Have to manually throw an error b/c http.delete does not automaticaly
      // throw an error like the other methods do
      if (resp.statusCode >= 400) {
        // Throwing a custom error which will be cught by catchError
        throw HttpException('Could not delete product');
      }
      // If everything goes well then remove the pointer and let Dart garbage
      // collect the product
      existingProduct = null;
    }).catchError((_) {
      _items.insert(existingProductIndex, existingProduct);
    });
    notifyListeners();
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
        'https://flutter-shop-app-ef265-default-rtdb.firebaseio.com/products.json');
    try {
      final resp = await http.get(url);
      // print(jsonDecode(resp.body)); // can see shape of response data
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      // Transforming data loaded from the server
      final List<Product> loadedProducts = [];
      data.forEach((key, value) {
        loadedProducts.add(Product(
          id: key,
          title: value['title'],
          description: value['description'],
          price: value['price'],
          imageUrl: value['imageUrl'],
          isFavourite: value['isFavourite'],
        ));
      });

      _items = loadedProducts;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }
}
