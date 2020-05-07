import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context, listen: false);

    void deleteProduct(String productId, BuildContext ctx) async {
      try {
        await Provider.of<Products>(context, listen: false)
            .deleteItem(productId);

        // Scaffold.of(ctx).hideCurrentSnackBar();
        // Scaffold.of(ctx).showSnackBar(SnackBar(
        //   content: Text('Product deleted'),
        //   duration: Duration(seconds: 2),
        // ));
      } catch (e) {
        //   Scaffold.of(ctx).showSnackBar(SnackBar(
        //   content: Text('Delete Failed', textAlign: TextAlign.center,),
        //   duration: Duration(seconds: 2),
        // ));
        print(e.toString());
      }
    }

    Future<void> refreshProducts() async {
      await Provider.of<Products>(context, listen: false)
          .getAndRefreshProducts(true);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.of(context).pushNamed('/edit-product'),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: refreshProducts(),
        builder: (ctx, snapshot) => 
        
         snapshot.connectionState == ConnectionState.waiting ? 
          Center(child: CircularProgressIndicator(),)
          : RefreshIndicator(
          onRefresh: refreshProducts,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Consumer<Products>(
              builder: (_, products, __) => ListView.builder(
                itemCount: products.items.length,
                itemBuilder: (ctx, i) => UserProductItem(
                  id: products.items[i].id,
                  title: products.items[i].title,
                  imageUrl: products.items[i].imageUrl,
                  deleteHandler: deleteProduct,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
