import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/products_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';

import '../screens/shopping_cart_screen.dart';

import '../providers/shopping_cart_provider.dart';
import '../providers/product.dart';

enum FilterOptions { Favorites, All }

class ProductsOverwiewScreen extends StatefulWidget {
  @override
  State<ProductsOverwiewScreen> createState() => _ProductsOverwiewScreenState();
}

class _ProductsOverwiewScreenState extends State<ProductsOverwiewScreen> {
  bool _showOnlyFavorites = false;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Provider.of<Products>(context).fetchProducts(); WON'T WORK!
    // Hack:
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchProducts();
    // });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = false;
    }
  }

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
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductsGrid(_showOnlyFavorites),
    );
  }
}
