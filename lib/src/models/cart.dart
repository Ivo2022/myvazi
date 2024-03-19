import 'package:myvazi/src/models/cart_item.dart';

class Cart {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(CartItem item) {
    _items.add(item);
  }

  void removeItem(int productId) {
    _items.removeWhere((item) => item.productId == productId);
  }

  // Other methods to update item quantities, calculate total price, etc.
}
