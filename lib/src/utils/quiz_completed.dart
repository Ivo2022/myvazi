import 'package:flutter/material.dart';

class QuizCompletedModal extends StatelessWidget {
  const QuizCompletedModal({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Quiz Completed"),
      content: RichText(
        text: const TextSpan(
          style: TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text:
                  "Congratulations! You have passed the quiz. Please complete the registration of your account in order to create a shop on MyVazi.",
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/register');
            //const SignUpForm();
          },
          child: const Text('CREATE ACCOUNT'),
        ),
      ],
    );
  }
}
