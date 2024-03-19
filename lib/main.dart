import 'package:flutter/material.dart';
import 'package:myvazi/routes.dart';
import 'package:myvazi/src/providers/app_state_manager.dart';
import 'package:myvazi/src/providers/auth_state_provider.dart';
import 'package:myvazi/src/screens/chat.dart';
import 'package:myvazi/src/screens/post.dart';
import 'package:myvazi/src/screens/profile.dart';
import 'package:myvazi/src/screens/sale.dart';
import 'package:myvazi/src/screens/test.dart';
import 'package:myvazi/src/widgets/account_edit.dart';
import 'package:myvazi/src/widgets/billing_information.dart';
//import 'package:myvazi/src/widgets/cart_provider.dart';
import 'package:myvazi/src/widgets/make_payment.dart';
import 'package:myvazi/src/widgets/buy_now.dart';
import 'package:myvazi/src/widgets/edit_product.dart';
import 'package:myvazi/src/widgets/not_found_page.dart';
import 'package:myvazi/src/widgets/product_details_display.dart';
import 'package:myvazi/src/widgets/product_upload.dart';
import 'package:myvazi/src/widgets/product_view.dart';
import 'package:myvazi/src/widgets/register.dart';
import 'package:myvazi/src/widgets/sign_in_page.dart';
import 'package:myvazi/src/widgets/test.dart';
import 'package:provider/provider.dart';
import 'package:myvazi/src/utils/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await openHiveBox();
  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider<AuthState>(create: (_) => AuthState()),
        ChangeNotifierProvider(create: (_) => AuthState()),
        ChangeNotifierProvider(create: (context) => AppStateManagerProvider()),
        ChangeNotifierProvider(create: (context) => SellerDataProvider()),
        ChangeNotifierProvider(create: (context) => UserDataProvider()),
        ChangeNotifierProvider(create: (context) => SellerRatingsProvider()),
        ChangeNotifierProvider(create: (context) => SellerSubcatsProvider()),
        //ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => ProductViewProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
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
          useMaterial3: true,
          colorSchemeSeed: Colors.black,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor:
                    MaterialStateProperty.all(Colors.yellow.shade50)),
          )),
      home: const MainScreen(
        initialIndex: 0,
      ),
      routes: {
        '/initial': (context) => SignInPage(
              onVerificationSuccess: (int) {},
            ),
        '/home': (context) => const FrontPage(),
        '/post': (context) => const Post(),
        '/sale': (context) => const Sale(),
        '/chat': (context) => const Chat(),
        '/profile': (context) => const Profile(phoneNo: " "),
        '/edit-product': (context) => const EditProduct(),
        '/buy-now': (context) => const BuyNow(),
        '/product-view': (context) => const ProductView(),
        '/product-details-display': (context) => const ProductDetailsDisplay(),
        '/product-upload': (context) => const ProductUpload(),
        '/make-payment': (context) => const MakePayment(),
        '/account-edit': (context) => const AccountEdit(),
        '/billing-information': (context) => const BillingInformation(),
        '/register': (context) => const Register(),
        '/my-cart': (context) => CartScreen(
              cart: cart,
              removeFromCart: removeFromCart,
              addToCart: (product) {},
            ),
      },
      onGenerateRoute: (settings) {
        // Check the route name and return the corresponding route
        if (settings.name == '/dynamicRoute') {
          return MaterialPageRoute(builder: (_) => const ProductView());
        }
        // Return null if the route is unknown
        return null;
      },
      onUnknownRoute: (settings) {
        // Handle unknown routes here
        // For example, you could navigate to a 404 page or display an error message
        return MaterialPageRoute(builder: (_) => const NotFoundPage());
      },
    );
  }
}
