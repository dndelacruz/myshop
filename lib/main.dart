import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview.dart';
import './screens/product_details.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './screens/cart_screen.dart';
import './providers/order.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
          providers: [
            ChangeNotifierProvider(
            create: (ctx) => Products()),
            ChangeNotifierProvider(
            create: (ctx) => Cart()),
            ChangeNotifierProvider(
            create: (ctx) => Order()),
          ],
          
            child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            
          ),
          home: ProductsOverview(),
          routes: {
            '/product-details': (ctx) => ProductDetails(),
            '/cart-screen': (ctx) => CartScreen(),
            '/orders-screen': (ctx) => OrdersScreen(),
            '/user-products': (ctx) => UserProductsScreen(),
            '/edit-product': (ctx) => EditProduct(),
          },
          
        ),
      
    );
  }
}

