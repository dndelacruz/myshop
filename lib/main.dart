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
import './screens/auth_screen.dart';
import './providers/auth.dart';
import './screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(create: (ctx) => Products(null, null, []), update: (ctx, auth, previousProducts) =>
            Products(auth.token, auth.userId, previousProducts.items)
          ),
          ChangeNotifierProxyProvider<Auth, Order>(create: (ctx) => Order(null, null, []), 
          update: (ctx, auth, prevOrders) => 
            Order(auth.token, auth.userId, prevOrders.orders)
          ),
          
          ChangeNotifierProvider(create: (ctx) => Cart()),
         
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
            ),
            initialRoute: '/',
            routes: {
              '/': (ctx) => auth.isAuthenticated ? ProductsOverview() : FutureBuilder(
                future: auth.tryAutoLogin(),
                builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting ?
                  SplashScreen() : AuthScreen(),
              ),
              '/auth-screen': (ctx) => AuthScreen(),
              '/products-overview': (ctx) => ProductsOverview(),
              '/product-details': (ctx) => ProductDetails(),
              '/cart-screen': (ctx) => CartScreen(),
              '/orders-screen': (ctx) => OrdersScreen(),
              '/user-products': (ctx) => UserProductsScreen(),
              '/edit-product': (ctx) => EditProduct(),
            },
          ),
        ));
  }
}
