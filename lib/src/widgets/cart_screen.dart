import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myvazi/src/widgets/cart_provider.dart';

class NewCartScreen extends StatelessWidget {
  const NewCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: ListView.builder(
        itemCount: cart.cartItems.length,
        itemBuilder: (context, index) {
          final product = cart.cartItems[index];
          return ListTile(
            title: Text('Testing'),
            subtitle: Text('Testing'),
            trailing: IconButton(
              icon: const Icon(Icons.remove_shopping_cart),
              onPressed: () {
                // cart.removeFromCart(product);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // cart.clearCart();
        },
        child: const Icon(Icons.clear),
      ),
    );
  }
}
