import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {
      @required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false
      });

  Future<bool> toggleFavoriteStatus() async {
    final url = 'https://myshop-77a95.firebaseio.com/products/$id.json';
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.patch(url, body: json.encode({
        'isFavorite': isFavorite,
      }));
      if(response.statusCode > 400) throw HttpException('Toggle favorite status failed');
    } catch (e) {
      isFavorite = !isFavorite;
      notifyListeners();
    }
    return isFavorite;
  }
}
