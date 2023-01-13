import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/shopping_cart_provider.dart' show ShoppingCart;
import '../providers/orders_provider.dart';

import '../widgets/shopping_cart_display_item.dart';

class ShoppingCartScreen extends StatelessWidget {
  static const String routeName = '/shopping-cart';

  @override
  Widget build(BuildContext context) {
    final shoppingCartContext = Provider.of<ShoppingCart>(context);
    final shoppingCartKeys = shoppingCartContext.items.keys.toList();
    final shoppingCartValues = shoppingCartContext.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${shoppingCartContext.total.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context)
                            .primaryTextTheme
                            .titleMedium
                            .color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false).addOrder(
                          shoppingCartValues, shoppingCartContext.total);
                      shoppingCartContext.clear();
                    },
                    child: Text('ORDER'),
                    style: ButtonStyle(
                      foregroundColor: MaterialStatePropertyAll<Color>(
                          Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) => ShoppingCartDisplayItem(
                id: shoppingCartValues[index].id,
                productId: shoppingCartKeys[index],
                title: shoppingCartValues[index].title,
                price: shoppingCartValues[index].price,
                quantity: shoppingCartValues[index].quantity,
              ),
              itemCount: shoppingCartContext.itemCount,
            ),
          ),
        ],
      ),
    );
  }
}
