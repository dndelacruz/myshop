import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String description;
  // final String imageUrl;

  // ProductItem({this.id, this.title, this.description, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () => Navigator.of(context)
            .pushNamed('/product-details', arguments: product.id),
        child: GridTile(
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
            footer: GridTileBar(
              backgroundColor: Colors.black87,
              leading: Consumer<Product>(
                builder: (_, product, __) => IconButton(
                  icon: Icon(product.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border),
                  onPressed: () async {
                    await product.toggleFavoriteStatus(auth.token, auth.userId);
                  },
                ),
              ),
              title: Text(
                product.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
              trailing: Consumer<Cart>(
                builder: (_, cart, __) => IconButton(
                    icon: Icon(Icons.add_shopping_cart),
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      cart.addItem(product.id, product.title, product.price);
                      Scaffold.of(context).hideCurrentSnackBar();
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('Item added to cart.'),
                          duration: Duration(seconds: 2),
                          action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                cart.removeSingleItem(product.id);
                              })));
                    }),
              ),
            )),
      ),
    );
  }
}
