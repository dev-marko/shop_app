import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// We could also move this class into the products_provider.dart file
// like we did with ShoppingCartItem
class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavoriteValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final Uri url = Uri.https(
      'shop-app-162ba-default-rtdb.europe-west1.firebasedatabase.app',
      '/userFavorites/$userId/products/$id.json',
      {
        'auth': token,
      },
    );
    
    try {
      final response = await http.put(
        url,
        body: json.encode(isFavorite),
      );

      if (response.statusCode >= 400) {
        _setFavoriteValue(oldStatus);
      }
    } catch (err) {
      _setFavoriteValue(oldStatus);
    }
  }
}
