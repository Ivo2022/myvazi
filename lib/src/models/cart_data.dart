class Product {
  final int id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class ShoppingCart {
  final List<CartItem> items = [];

  double get totalPrice {
    return items.fold(
        0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  void addToCart(Product product) {
    final existingIndex = items.indexWhere((item) => item.product == product);

    if (existingIndex != -1) {
      // Product is already in the cart, update quantity
      items[existingIndex] = CartItem(
          product: product, quantity: items[existingIndex].quantity + 1);
    } else {
      // Product is not in the cart, add a new item
      items.add(CartItem(product: product, quantity: 1));
    }
  }

  void removeFromCart(CartItem cartItem) {
    items.remove(cartItem);
  }

  void incrementQuantity(CartItem cartItem) {
    final index = items.indexOf(cartItem);
    items[index] =
        CartItem(product: cartItem.product, quantity: cartItem.quantity + 1);
  }

  void decrementQuantity(CartItem cartItem) {
    final index = items.indexOf(cartItem);
    if (cartItem.quantity > 1) {
      items[index] =
          CartItem(product: cartItem.product, quantity: cartItem.quantity - 1);
    } else {
      removeFromCart(cartItem);
    }
  }
}
