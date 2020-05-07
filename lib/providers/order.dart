import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime orderDate;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.orderDate,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Order(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> getOrders() async {
    final url = 'https://myshop-77a95.firebaseio.com/orders.json?auth=$authToken&orderBy="createdBy"&equalTo="$userId"';
    try {
      final response = await http.get(url);
      final decodedResponse =
          json.decode(response.body) as Map<String, dynamic>;
      if(decodedResponse == null) return;
      List<OrderItem> fetchedOrders = [];
      // print(decodedResponse);
      decodedResponse.forEach((key, order) => fetchedOrders.add(OrderItem(
          id: key,
          amount: order['amount'],
          products: (order['products'] as List<dynamic>).map((item) => CartItem(
            id: item['id'],
            title: item['title'],
            price: item['price'],
            quantity: item['quantity']
          )).toList(),
          orderDate: DateTime.parse(order['orderDate']))));
      _orders = fetchedOrders.reversed.toList();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double amount) async {
    final url = 'https://myshop-77a95.firebaseio.com/orders.json?auth=$authToken';

    final orderDate = DateTime.now();

    try {
      final response = await http.post(url, body: json.encode({
        'amount': amount,
        'createdBy': userId,
        'products': cartProducts.map((prod) => {
            'id': prod.id,
            'title': prod.title,
            'price': prod.price,
            'quantity': prod.quantity
        }).toList(),
        'orderDate': orderDate.toIso8601String(),
      }));

      _orders.insert(
          0,
          OrderItem(
            id: json.decode(response.body)['name'],
            amount: amount,
            products: cartProducts,
            orderDate: orderDate,
          ));
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
