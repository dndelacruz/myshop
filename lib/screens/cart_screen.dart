import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/total_amount.dart';
import '../widgets/cart_item.dart';
import '../providers/cart.dart' show Cart;
import '../providers/order.dart';
import '../widgets/app_drawer.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    
    void addOrder() async {
      await Provider.of<Order>(context, listen: false).addOrder(cart.items.values.toList(), cart.totalAmount);
      cart.clearCart();
      
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: <Widget>[
          TotalAmount(cart.totalAmount, addOrder),
          Expanded(
            child: ListView.builder(
              itemCount: cart.numberOfItems,
              itemBuilder: (ctx, i) => CartItem(
                productId: cart.items.keys.toList()[i],
                id: cart.items.values.toList()[i].id,
                price: cart.items.values.toList()[i].price,
                title: cart.items.values.toList()[i].title,
                quantity: cart.items.values.toList()[i].quantity,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


