import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './product.dart';
import '../models/http_exception.dart';

enum FilTerOptions { Favorites, All }

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  Future<void> getAndRefreshProducts() async {
    const url = 'https://myshop-77a95.firebaseio.com/products.json';
    
      final response = await http.get(url);
      final decodedResponse =
          json.decode(response.body) as Map<String, dynamic>;
      if(decodedResponse == null) return;
      final List<Product> fetchedProducts = [];
      decodedResponse.forEach((prodId, prodData) => fetchedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite: prodData['isFavorite'])));
      _items = fetchedProducts;
      notifyListeners();
      // print(fetchedProducts);
   
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Future<void> addProduct(Product product) async {
    const url = 'https://myshop-77a95.firebaseio.com/products.json';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite
          }));

      final finalProduct = Product(
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          id: json.decode(response.body)['name']);

      _items.add(finalProduct);
      notifyListeners();
    } catch (exception) {
      throw exception;
    }
  }

  Product getItem(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  Future<void> deleteItem(String productId) async {
    final url = 'https://myshop-77a95.firebaseio.com/products/$productId.json';
    final prodIndex = _items.indexWhere((item) => item.id == productId);
    var prodItem = _items[prodIndex];
    _items.removeWhere((prod) => prod.id == productId);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode > 400) {
      _items.insert(prodIndex, prodItem);
      notifyListeners();
      throw HttpException('Delete failed');
    }

    prodItem = null;
  }

  Future<void> updateItem(Product editedProduct) async {
    final index = _items.indexWhere((prod) => prod.id == editedProduct.id);
    final url =
        'https://myshop-77a95.firebaseio.com/products/${editedProduct.id}.json';
    await http.patch(url,
        body: json.encode({
          'title': editedProduct.title,
          'description': editedProduct.description,
          'price': editedProduct.price,
          'imageUrl': editedProduct.imageUrl
        }));
    _items[index] = editedProduct;
    notifyListeners();
    return Future.value();
  }


}
