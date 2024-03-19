import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:myvazi/src/configs/constants.dart';
import 'package:myvazi/src/forms/signup_form.dart';
import 'package:myvazi/src/providers/auth_state_provider.dart';
import 'package:myvazi/src/utility/signin.dart';
import 'package:provider/provider.dart';

class SignInForm extends StatefulWidget {
  final Function(int) onVerificationSuccess;

  const SignInForm({
    super.key,
    required this.onVerificationSuccess,
  });

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController bizNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String localImagePath = '';

  void login(BuildContext context, TextEditingController phoneController,
      Function(String) onVerificationSuccess) async {
    try {
      await AuthUtil.loginUser(context, phoneController, onVerificationSuccess);
    } catch (error) {
      // Handle error
    }
  }

  void onVerificationSuccess(String value) async {
    final authProvider = Provider.of<AuthState>(context, listen: false);
    await authProvider.login(value);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double sizeWidth =
        screenWidth < 600 ? screenWidth * 0.21 : screenWidth * 0.04;
    double spacingBetween =
        screenWidth < 600 ? screenWidth * 0.01 : screenWidth * 0.3;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: spacingBetween),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: sizeWidth, // Default radius for larger screens
                      backgroundImage: localImagePath.isNotEmpty
                          ? NetworkImage(localImagePath)
                          : NetworkImage(ServerConfig.defaultProfileImage),
                    ),
                  ],
                ),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  hintText: '256...',
                  labelText: 'Phone Number',
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (usernameController.text.isNotEmpty ||
                        phoneController.text.isNotEmpty) {
                      // username and phone number have been provided, call a function to handle registration success
                      //loginUser();
                      // Then call the login function where you need to log in, passing the required parameters
                      login(context, phoneController, onVerificationSuccess);
                    } else {
                      // Code is invalid, show error message
                      _handleRegistrationFailure(context);
                    }
                  },
                  child: const Text('Sign in'),
                ),
              ),
              const SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  text: "Not Registered? ",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14, // Adjust the font size as needed
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Create an account',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpForm()),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleRegistrationFailure(BuildContext context) {
    // Close the verification screen dialog
    Navigator.pop(context);

    // Navigate to the front page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invalid registration data'),
        backgroundColor: Colors.red,
      ),
    );
  }
}


/*
// Example of performing form validation
if (_formKey.currentState!.validate()) {
  // Form fields are valid, proceed with login logic
}

// Example of resetting the form
_formKey.currentState!.reset();

Keep in mind that using GlobalKey should be done with caution, as it can lead to tight coupling and 
make the code harder to maintain. Only use it if you have a specific need to access the form's state 
from outside its widget subtree. If the form's state management can be handled within its widget subtree,
 you can omit the GlobalKey.

*/