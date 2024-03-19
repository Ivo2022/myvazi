// import 'package:flutter/material.dart';
// import 'package:myvazi/src/providers/auth_state_provider.dart';
// import 'package:provider/provider.dart';

// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         // Add your authentication provider here
//         ChangeNotifierProvider(create: (_) => AuthState()),
//         // Add other providers if needed
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Access authentication provider to get authentication state
//     final authProvider = Provider.of<AuthState>(context);

//     return MaterialApp(
//       home: authProvider.isLoggedIn ? const HomePage() : LoginPage(),
//     );
//   }
// }

// class LoginPage extends StatelessWidget {
//   const LoginPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Access authentication provider to call authentication methods
//     final authProvider = Provider.of<AuthState>(context);

//     return Scaffold(
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             // Call login method from authentication provider
//             authProvider.login(token);
//           },
//           child: const Text('Login'),
//         ),
//       ),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Access authentication provider to get authentication state
//     final authProvider = Provider.of<AuthState>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () {
//               // Call logout method from authentication provider
//               authProvider.logout();
//             },
//           ),
//         ],
//       ),
//       body: const Center(
//         child: Text('Welcome!'),
//       ),
//     );
//   }
// }
