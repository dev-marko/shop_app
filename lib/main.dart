import 'package:flutter/material.dart';

import './screens/products_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyShop',
      theme: ThemeData(
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Colors.red,
              secondary: Colors.amber,
            ),
        fontFamily: 'Lato',
      ),
      home: ProductsOverwiewScreen(),
    );
  }
}
