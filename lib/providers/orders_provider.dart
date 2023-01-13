import 'package:flutter/material.dart';

import './shopping_cart_provider.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<ShoppingCartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<ShoppingCartItem> shoppingCartItems, double total) {
    _orders.insert(
        0,
        OrderItem(
          id: DateTime.now().toString(),
          amount: total,
          products: shoppingCartItems,
          dateTime: DateTime.now(),
        ));
    notifyListeners();
  }
}
