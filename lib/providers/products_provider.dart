// Mixins == Java Interfaces

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import './product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // bool _showFavoritesOnly = false;

  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items]; // returning a copy of the list.
    // we have to return a copy, because we don't want to return a reference
    // to the original list.
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Future<void> fetchProducts() async {
    Uri url = Uri.https(
      'shop-app-162ba-default-rtdb.europe-west1.firebasedatabase.app',
      '/products.json',
      {
        "auth": authToken,
      },
    );

    try {
      final response = await http.get(url);
      final resData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];

      if (resData == null) {
        return;
      }

      url = Uri.https(
        'shop-app-162ba-default-rtdb.europe-west1.firebasedatabase.app',
        '/userFavorites/$userId.json',
        {
          'auth': authToken,
        },
      );

      final favoriteResponse = await http.get(url);
      final favoritesData = json.decode(favoriteResponse.body);

      resData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            isFavorite:
                favoritesData == null ? false : favoritesData[prodId] ?? false,
            imageUrl: prodData['imageUrl'],
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (err) {
      throw (err);
    }
  }

  Future<void> addProduct(Product product) async {
    final Uri url = Uri.https(
      'shop-app-162ba-default-rtdb.europe-west1.firebasedatabase.app',
      '/products.json',
      {
        "auth": authToken,
      },
    );

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userId,
        }),
      );

      var resData = json.decode(response.body);

      final newProduct = Product(
          id: resData['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);

      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  void updateProduct(String id, Product editedProduct) async {
    final int prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final Uri url = Uri.https(
        'shop-app-162ba-default-rtdb.europe-west1.firebasedatabase.app',
        '/products/$id.json',
        {
          'auth': authToken,
        },
      );
      await http.patch(
        url,
        body: json.encode({
          'title': editedProduct.title,
          'description': editedProduct.description,
          'imageUrl': editedProduct.imageUrl,
          'price': editedProduct.price,
        }),
      );
      _items[prodIndex] = editedProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    // Optimistic Updating - re-add product if we fail
    final Uri url = Uri.https(
      'shop-app-162ba-default-rtdb.europe-west1.firebasedatabase.app',
      '/products/$id.json',
      {
        'auth': authToken,
      },
    );

    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }

    existingProduct = null;
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }
}
