import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final selectedProduct = Provider.of<Products>(context, listen: false).getItem(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedProduct.title),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 500,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            child: Card(
              elevation: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Hero(tag: selectedProduct.id, child: Image.network(selectedProduct.imageUrl, fit: BoxFit.cover,)),
                ),
            ),
          ),
          Flexible(
            child: Text(selectedProduct.title,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                )),
          ),
          Flexible(
            child: Text('\$${selectedProduct.price}',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                )),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(selectedProduct.isFavorite ? Icons.favorite : Icons.favorite_border),
        backgroundColor: Theme.of(context).accentColor,
        onPressed: () {},
        ),
    );
  }
}
