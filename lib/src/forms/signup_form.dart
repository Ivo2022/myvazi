import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController bizNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    fullNameController.dispose();
    bizNameController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            title: const Text('Registration'),
            bottom: const TabBar(
                tabs: [Tab(text: 'Personal'), Tab(text: 'Business')])),
        body: TabBarView(children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
                  TextField(
                    controller: fullNameController,
                    decoration: const InputDecoration(
                      hintText: 'MyVazi...',
                      labelText: 'Full Name',
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  TextField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      hintText: 'Kampala',
                      labelText: 'Address',
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle form submission here
                        print('Phone Number: ${phoneController.text}');
                        print('Full Name: ${fullNameController.text}');
                        print('Business Name: ${bizNameController.text}');
                        print('Address: ${addressController.text}');
                      },
                      child: const Text('Sign Up'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14, // Adjust the font size as needed
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Sign In',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(context);
                            },
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Go back to ",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14, // Adjust the font size as needed
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Home',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Handle Sign In navigation
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // SignIn Form
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
                  TextField(
                    controller: fullNameController,
                    decoration: const InputDecoration(
                      hintText: 'MyVazi...',
                      labelText: 'Full Name',
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  TextField(
                    controller: bizNameController,
                    decoration: const InputDecoration(
                      hintText: 'MyVazi...',
                      labelText: 'Business Name',
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  TextField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      hintText: 'Kampala',
                      labelText: 'Address',
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle form submission here
                        print('Phone Number: ${phoneController.text}');
                        print('Full Name: ${fullNameController.text}');
                        print('Business Name: ${bizNameController.text}');
                        print('Address: ${addressController.text}');
                      },
                      child: const Text('Sign Up'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14, // Adjust the font size as needed
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Sign In',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(context);
                            },
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Go back to ",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14, // Adjust the font size as needed
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Home',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Handle Sign In navigation
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
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