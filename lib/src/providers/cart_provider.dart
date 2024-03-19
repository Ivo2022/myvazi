import 'package:flutter/material.dart';
import 'package:myvazi/src/models/cart.dart';
import 'package:myvazi/src/models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final Cart _cart = Cart();

  Cart get cart => _cart;

  void addItemToCart(CartItem item) {
    _cart.addItem(item);
    notifyListeners();
  }

  // Other methods to remove items, update quantities, etc.
}
