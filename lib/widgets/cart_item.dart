import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String title;
  final double price;
  final int quantity;
  final String productId;

  CartItem(
      {@required this.productId,
      @required this.id,
      @required this.title,
      @required this.price,
      @required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 15),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: ListTile(
            leading: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                    child: CircleAvatar(
                  child: Text('\$$price', style: TextStyle(fontSize: 12)),
                ))),
            title: Text(title),
            subtitle: Text('\$${quantity * price}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) =>
          Provider.of<Cart>(context, listen: false).removeItem(productId),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Delete Item'),
            content: Text('Do you want to remove this item from cart?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Yes'),
                onPressed: () => Navigator.of(ctx).pop(true),
              ),
              FlatButton(
                child: Text('No'),
                onPressed: () => Navigator.of(ctx).pop(false),
              ),
            ],
          ),
        );
      },
    );
  }
}
