import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  Future<void> fetchOrders() async {
    final Uri url = Uri.https(
        'shop-app-162ba-default-rtdb.europe-west1.firebasedatabase.app',
        '/orders.json');

    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final resData = json.decode(response.body) as Map<String, dynamic>;

    if (resData == null) {
      return;
    }

    resData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map((item) => ShoppingCartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price'],
                  ))
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(
      List<ShoppingCartItem> shoppingCartItems, double total) async {
    final Uri url = Uri.https(
        'shop-app-162ba-default-rtdb.europe-west1.firebasedatabase.app',
        '/orders.json');

    final timestamp = DateTime.now();

    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': shoppingCartItems
            .map((item) => {
                  'id': item.id,
                  'title': item.title,
                  'quantity': item.quantity,
                  'price': item.price,
                })
            .toList(),
      }),
    );

    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: shoppingCartItems,
        dateTime: timestamp,
      ),
    );
    notifyListeners();
  }
}
