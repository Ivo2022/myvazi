import 'package:flutter/material.dart';

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

class MyApp extends StatelessWidget {
  final ShoppingCart cart = ShoppingCart();

  final List<Product> products = [
    Product(id: 1, name: 'Product 1', price: 20.0),
    Product(id: 2, name: 'Product 2', price: 30.0),
    Product(id: 3, name: 'Product 3', price: 25.0),
    // Add more products as needed
  ];

  MyApp({super.key});

  void addToCart(Product product) {
    var cartItem = cart.items.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product),
    );

    setState(() {
      if (cart.items.contains(cartItem)) {
        cartItem.quantity++;
      } else {
        cart.items.add(cartItem);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Shopping Cart'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        addToCart(product);
                      },
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Total: \$${cart.totalPrice.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Display the Cart as a bottom sheet
                showCartBottomSheet(context);
              },
              child: const Text('View Cart'),
            ),
          ],
        ),
      ),
    );
  }

  // void addToCart(Product product) {
  //   var cartItem = cart.items.firstWhere(
  //     (item) => item.product.id == product.id,
  //     orElse: () => CartItem(product: product),
  //   );

  //   if (cart.items.contains(cartItem)) {
  //     cartItem.quantity++;
  //   } else {
  //     cart.items.add(cartItem);
  //   }

  //   // Update the UI
  //   setState(() {});
  // }

  void showCartBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return CartScreen(
          cart: cart,
          removeFromCart: removeFromCart,
          addToCart: (Product) {},
        );
      },
    );
  }

  void removeFromCart(CartItem cartItem) {
    setState(() {
      if (cartItem.quantity > 1) {
        cartItem.quantity--;
      } else {
        cart.items.remove(cartItem);
      }
    });
  }

  void setState(VoidCallback fn) {
    // Mock implementation of setState for simplicity
    fn();
  }
}

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
        title: const Text('Shopping Cart'),
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

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final Function(CartItem) onRemove;
  final Function(CartItem) onIncrement;
  final Function(CartItem) onDecrement;

  CartItemWidget({
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
