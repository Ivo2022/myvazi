import 'package:flutter/material.dart';
import 'package:myvazi/src/models/cart_data.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final Function(CartItem) onRemove;
  final Function(CartItem) onIncrement;
  final Function(CartItem) onDecrement;

  const CartItemWidget({
    super.key,
    required this.cartItem,
    required this.onRemove,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(cartItem.product.name),
      subtitle: Text('Quantity: ${cartItem.quantity}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () => onDecrement(cartItem),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => onIncrement(cartItem),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => onRemove(cartItem),
          ),
        ],
      ),
    );
  }
}
