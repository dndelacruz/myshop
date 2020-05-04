import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import '../providers/order.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem orderItem;

  OrderItem(this.orderItem);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: ListTile(
              title: Text('\$${widget.orderItem.amount.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              subtitle:
                  Text(DateFormat.yMMMMd().format(widget.orderItem.orderDate)),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() => _expanded = !_expanded);
                },
              )),
        ),
        if (_expanded)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            height: min(widget.orderItem.products.length * 20.0 + 10, 180),
            child: ListView(
              children: widget.orderItem.products
                  .map((prod) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(prod.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                          Text('\$${prod.price} x ${prod.quantity}',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey)),
                        ],
                      ))
                  .toList(),
            ),
          ),
      ],
    );
  }
}
