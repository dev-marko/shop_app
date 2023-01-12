import 'package:flutter/material.dart';

import '../widgets/products_grid.dart';

class ProductsOverwiewScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MS Shop'),
      ),
      body: ProductsGrid(),
    );
  }
}
