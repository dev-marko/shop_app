import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';

import '../screens/shopping_cart_screen.dart';

import '../providers/shopping_cart_provider.dart';

enum FilterOptions { Favorites, All }

class ProductsOverwiewScreen extends StatefulWidget {
  @override
  State<ProductsOverwiewScreen> createState() => _ProductsOverwiewScreenState();
}

class _ProductsOverwiewScreenState extends State<ProductsOverwiewScreen> {
  bool _showOnlyFavorites = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MS Shop'),
        actions: [
          Consumer<ShoppingCart>(
            builder: (_, shoppingCartContext, ch) => Badge(
              child: ch,
              value: shoppingCartContext.itemCount.toString(),
            ),
            // this child will not get rebuilt
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(ShoppingCartScreen.routeName);
              },
              icon: Icon(
                Icons.shopping_cart,
              ),
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
        ],
      ),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
