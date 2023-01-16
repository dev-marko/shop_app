import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class ShoppingCartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  ShoppingCartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class ShoppingCart with ChangeNotifier {
  Map<String, ShoppingCartItem> _items = {}; // the key is a product id

  Map<String, ShoppingCartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get total {
    double totalPrice = 0.0;
    _items.forEach((key, value) {
      totalPrice += value.quantity * value.price;
    });
    return totalPrice;
  }

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      // change quantity...
      _items.update(
        productId,
        (value) => ShoppingCartItem(
          id: value.id,
          title: value.title,
          quantity: value.quantity + 1,
          price: value.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => ShoppingCartItem(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeItemById(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (value) => ShoppingCartItem(
              id: value.id,
              title: value.title,
              quantity: value.quantity - 1,
              price: value.price));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
