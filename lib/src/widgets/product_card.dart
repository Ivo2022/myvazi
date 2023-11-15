import 'package:flutter/material.dart';
import 'package:myvazi/src/models/data.dart';
import 'package:myvazi/src/widgets/cart_provider.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard(
      {super.key,
      required this.product,
      required String id,
      required String name});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();

    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        title: Text(product.name),
        subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
        trailing: IconButton(
          icon: const Icon(Icons.add_shopping_cart),
          onPressed: () {},
        ),
      ),
    );
  }
}
