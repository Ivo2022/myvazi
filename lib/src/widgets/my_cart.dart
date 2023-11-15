import 'package:flutter/material.dart';
import 'package:myvazi/src/models/cart_data.dart';
import 'package:myvazi/src/widgets/cart_item_widget.dart';

class CartScreen extends StatefulWidget {
  final ShoppingCart cart;
  final void Function(CartItem) removeFromCart;
  final void Function(Product) addToCart;

  const CartScreen({
    super.key,
    required this.cart,
    required this.removeFromCart,
    required this.addToCart,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Define these methods
  void onRemove(CartItem cartItem) {
    widget.removeFromCart(cartItem);
    setState(() {});
  }

  void onIncrement(CartItem cartItem) {
    // Implement the logic to increment quantity
    cartItem.quantity++;
    setState(() {});
  }

  void onDecrement(CartItem cartItem) {
    // Implement the logic to decrement quantity
    if (cartItem.quantity > 1) {
      cartItem.quantity--;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cart.items.length,
              itemBuilder: (context, index) {
                final cartItem = widget.cart.items[index];
                return CartItemWidget(
                  cartItem: cartItem,
                  onRemove: onRemove,
                  onIncrement: onIncrement,
                  onDecrement: onDecrement,
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Total: \$${widget.cart.totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
