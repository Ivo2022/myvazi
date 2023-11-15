import 'package:flutter/material.dart';
import 'package:myvazi/routes.dart';
import 'package:myvazi/src/providers/app_state_manager.dart';
import 'package:myvazi/src/providers/seller_subcats_provider.dart';
import 'package:myvazi/src/screens/chat.dart';
import 'package:myvazi/src/screens/post.dart';
import 'package:myvazi/src/screens/profile.dart';
import 'package:myvazi/src/screens/sale.dart';
import 'package:myvazi/src/screens/test.dart';
import 'package:myvazi/src/widgets/account_edit.dart';
import 'package:myvazi/src/widgets/make_payment.dart';
import 'package:myvazi/src/widgets/buy_now.dart';
import 'package:myvazi/src/widgets/edit_product.dart';
import 'package:myvazi/src/widgets/order.dart';
import 'package:myvazi/src/widgets/product_upload.dart';
import 'package:provider/provider.dart';
import 'package:myvazi/src/utils/providers.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppStateManagerProvider()),
        ChangeNotifierProvider(create: (context) => UserDataProvider()),
        ChangeNotifierProvider(create: (context) => SellerRatingsProvider()),
        ChangeNotifierProvider(create: (context) => SellerSubcatsProvider()),
      ],
      child: const Routes(),
    ),
  );
}

class Routes extends StatefulWidget {
  const Routes({super.key});

  @override
  State<Routes> createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  final ShoppingCart cart = ShoppingCart();

  void removeFromCart(CartItem cartItem) {
    setState(() {
      if (cartItem.quantity > 1) {
        cartItem.quantity--;
      } else {
        cart.items.remove(cartItem);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyVazi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        useMaterial3: true,
      ),
      home: const Routing(),
      routes: {
        '/post': (context) => const Screen1(),
        '/sale': (context) => const Sale(),
        '/chat': (context) => const Chat(),
        '/profile': (context) => const Profile(),
        '/edit-product': (context) => const EditProduct(),
        '/order': (context) => const Order(),
        '/buy-now': (context) => const BuyNow(),
        // '/product-view': (context) => const ProductView(),
        '/product-upload': (context) => const ProductUpload(),
        '/make-payment': (context) => const MakePayment(),
        '/account-edit': (context) => const AccountEdit(),
        '/my-cart': (context) => CartScreen(
              cart: cart,
              removeFromCart: removeFromCart,
              addToCart: (Product) {},
            ),
      },
    );
  }
}
