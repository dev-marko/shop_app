import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/shopping_cart_provider.dart';
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
                  OrderButton(
                    shoppingCartContext: shoppingCartContext,
                    shoppingCartValues: shoppingCartValues,
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.shoppingCartContext,
    @required this.shoppingCartValues,
  }) : super(key: key);

  final ShoppingCart shoppingCartContext;
  final List<ShoppingCartItem> shoppingCartValues;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.shoppingCartContext.total <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.shoppingCartValues,
                widget.shoppingCartContext.total,
              );
              setState(() {
                _isLoading = false;
              });
              widget.shoppingCartContext.clear();
            },
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER'),
      style: ButtonStyle(
        foregroundColor: MaterialStatePropertyAll<Color>(
            Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
