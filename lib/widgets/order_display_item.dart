import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import '../providers/orders_provider.dart' as ordersProvider;

class OrderDisplayItem extends StatefulWidget {
  final ordersProvider.OrderItem order;

  OrderDisplayItem(this.order);

  @override
  State<OrderDisplayItem> createState() => _OrderDisplayItemState();
}

class _OrderDisplayItemState extends State<OrderDisplayItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                height: min(widget.order.products.length * 20.0 + 20, 150),
                child: ListView(
                  children: widget.order.products
                      .map((prod) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                prod.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${prod.quantity}x \$${prod.price}',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              )
                            ],
                          ))
                      .toList(),
                )),
        ],
      ),
    );
  }
}
