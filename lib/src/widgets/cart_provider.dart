import 'package:flutter/material.dart';
import 'package:myvazi/src/screens/test.dart';


class CartProvider extends ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addToCart(CartItem product, int quantity, String selectedVariant) {
    var existingCartItem = _cartItems.firstOrNull!;

    existingCartItem.quantity += quantity;
    notifyListeners();
  }

  int getProductQuantity(int productId) {
    int quantity = 0;
    for (CartItem item in _cartItems) {
      if (item.product.id == productId) {
        quantity += item.quantity;
      }
    }
    return quantity;
  }
}

//   void removeFromCart(Product product) {
//     _cartItems.remove(product);
//     notifyListeners();
//   }
//
//   void clearCart() {
//     _cartItems.clear();
//     notifyListeners();
//   }
// }