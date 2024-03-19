import 'package:flutter/material.dart';
import 'package:myvazi/routes.dart';
import 'package:myvazi/src/forms/signin_form.dart';

class NavigationService {
  static String? previousRoute;

  static void navigateToLogin(BuildContext context) {
    // Store the current route name
    previousRoute = ModalRoute.of(context)?.settings.name;

    // Navigate to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SignInForm(
          onVerificationSuccess: (int) {},
        ),
      ),
    );
  }

  static void handleSuccessfulLogin(BuildContext context) {
    if (previousRoute != null) {
      // Navigate back to the previous page
      Navigator.pushReplacementNamed(context, previousRoute!);
    } else {
      // Navigate to a default landing page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainScreen(initialIndex: 0),
        ),
      );
    }

    // Clear the stored state
    previousRoute = null;
  }
}
