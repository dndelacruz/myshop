import 'package:flutter/foundation.dart';

class CartItem {
  @required final String id;
  @required final String title;
  @required final double price;
  @required final int quantity;

  CartItem({this.id, this.title, this.price, this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get numberOfItems {
    return items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, item) => total += item.quantity * item.price);
    return total;
  }

  void removeItem(String productId){
    _items.remove(productId);
    notifyListeners();
  }

  void addItem(String productId, String title, double price){
    if(_items.containsKey((productId))){
      _items.update(productId, (existingItem) => CartItem(
        id: existingItem.id,
        title: existingItem.title,
        price: existingItem.price,
        quantity: existingItem.quantity + 1

      ));      
    } else {
      _items.putIfAbsent(productId, () => CartItem(
        id: DateTime.now().toString(),
        title: title,
        price: price,
        quantity: 1
      ));
    }
    notifyListeners();
  }

  void removeSingleItem(String productId){
    if(!_items.containsKey(productId)) return;
    if(_items[productId].quantity > 1){
      _items.update(productId, (existingProduct) => CartItem(
        id: existingProduct.id,
        title: existingProduct.title,
        price: existingProduct.price,
        quantity: existingProduct.quantity - 1
      ));
    }
    else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clearCart(){
    _items = {};
    notifyListeners();
  }
}
