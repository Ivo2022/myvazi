import 'package:flutter/material.dart';
import 'package:myvazi/src/utils/quiz_completed.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class CreateShopScreen extends StatefulWidget {
//   const CreateShopScreen({super.key});

//   @override
//   State<CreateShopScreen> createState() => _CreateShopScreenState();
// }

// class _CreateShopScreenState extends State<CreateShopScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create Shop'),
//       ),
//       body: const Center(
//         child: Text('Create Shop Screen'),
//       ),
//     );
//   }
// }

class CreateShopScreen extends StatefulWidget {
  const CreateShopScreen({super.key});

  @override
  State<CreateShopScreen> createState() => _CreateShopScreenState();
}

class _CreateShopScreenState extends State<CreateShopScreen> {
  final PageController _controller = PageController();
  int _currentPageIndex = 0;
  String? selectedOption;

// Define the correct answers for each question
  final Map<int, String> correctAnswers = {
    1: 'A: MyVazi is an app that helps businesses sell online',
    2: 'B: Customers pay for their orders only',
    3: 'B: Using a Taxi or Bus',
    4: 'A: We pay a 10% commission off every successful sale, through MTN Mobile Money or Airtel Money',
  };

// Define a map to store the user's selected answers
  Map<int, String> userAnswers = {};

// Define a function to handle user's response
  void handleUserResponse(int questionNumber, String selectedOption) {
    userAnswers[questionNumber] = selectedOption;
  }

// Define a function to check if all questions are answered correctly
  bool areAllAnswersCorrect() {
    for (int questionNumber in correctAnswers.keys) {
      if (userAnswers[questionNumber] != correctAnswers[questionNumber]) {
        return false; // If any answer is incorrect, return false
      }
    }
    return true; // If all answers are correct, return true
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('How it works'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight,
              child: PageView(
                controller: _controller,
                onPageChanged: (int index) {
                  setState(() {
                    _currentPageIndex = index;
                  });
                },
                children: [
                  /*
                  const OnboardingPage(
                    title: 'Hello!',
                    description:
                        "Thank you for expressing interest in selling online with us. \n\n Our goal is to help one million businesses profitably sell online by 2030 and we're excited to work with you. \n\n MyVazi helps you;",
                    regularCards: [
                      Card(
                        child: ListTile(
                          title: Text(''),
                          subtitle: Text(
                              'Create a free online shop that enables you to sell and reach more customers'),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(''),
                          subtitle: Text(
                              'We connect you to affordable delivery services'),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(''),
                          subtitle: Text(
                              'We connect you to affordable delivery services'),
                        ),
                      ),
                    ],
                    quizCards: [], // Provide quiz cards here if needed
                  ),
*/
                  const OnboardingPage(
                    title: 'Hello!',
                    description:
                        "Thank you for expressing interest in selling online with us. \n\n Our goal is to help one million businesses profitably sell online by 2030 and we're excited to work with you. \n\n MyVazi helps you;",
                    cards: [
                      Card(
                        child: ListTile(
                          title: Text(''),
                          subtitle: Text(
                              'Create a free online shop that enables you to sell and reach more customers'),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(''),
                          subtitle: Text(
                              'We connect you to affordable delivery services'),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(''),
                          subtitle: Text(
                              'We run ads and advertise your products online'),
                        ),
                      ),
                    ],
                  ),

                  OnboardingPage(
                    title: 'Note',
                    description: " ",
                    cards: [
                      YoutubePlayer(
                        controller: YoutubePlayerController(
                          initialVideoId: 'rNc2Mx9-DsI',
                          flags: const YoutubePlayerFlags(
                            autoPlay: false,
                            mute: false,
                          ),
                        ),
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.blueAccent,
                      ),
                      const Card(
                        child: ListTile(
                          title: Text(''),
                          subtitle: Text(
                              "For upcountry orders; customers send mobile money, their orders are put on the bus, and a copy of the bus receipt or conductor's phone is shared with the customer on WhatsApp or by SMS."),
                        ),
                      ),
                      const Card(
                        child: ListTile(
                          title: Text(''),
                          subtitle: Text(
                              "Customers don't pay delivery fees and we recommend that sellers factor this in their pricing."),
                        ),
                      ),
                      const Card(
                        child: ListTile(
                          title: Text(''),
                          subtitle: Text(
                              "If we deliver and the product doesn't fit a customer, we exchange it for a size that fits."),
                        ),
                      ),
                      const Card(
                        child: ListTile(
                          title: Text(''),
                          subtitle: Text(
                              "Always being polite to customers gets you more sales."),
                        ),
                      ),
                      const Card(
                        child: ListTile(
                          title: Text(''),
                          subtitle: Text(
                              "MyVazi takes a 10% commission off every successful sale."),
                        ),
                      ),
                    ],
                    // quizCards: const [], // Provide quiz cards here if needed
                  ),
                  // OnboardingPage(
                  //   title: 'Note:',
                  //   description:
                  //       'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                  //   cards: [
                  //     YoutubePlayer(
                  //       controller: YoutubePlayerController(
                  //         initialVideoId: '1NKlA1y25IE',
                  //         flags: const YoutubePlayerFlags(
                  //           autoPlay: false,
                  //           mute: false,
                  //         ),
                  //       ),
                  //       showVideoProgressIndicator: true,
                  //       progressIndicatorColor: Colors.blueAccent,
                  //     ),
                  //     const Card(
                  //       child: ListTile(
                  //         title: Text(''),
                  //         subtitle: Text(
                  //             "For upcountry orders; customers send mobile money, their orders are put on the bus, and a copy of the bus receipt or conductor's phone is shared with the customer on WhatsApp or by SMS."),
                  //       ),
                  //     ),
                  //     const Card(
                  //       child: ListTile(
                  //         title: Text(''),
                  //         subtitle: Text(
                  //             "Customers don't pay delivery fees and we recommend that sellers factor this in their pricing."),
                  //       ),
                  //     ),
                  //     const Card(
                  //       child: ListTile(
                  //         title: Text(''),
                  //         subtitle: Text(
                  //             "If we deliver and the product doesn't fit a customer, we exchange it for a size that fits."),
                  //       ),
                  //     ),
                  //     const Card(
                  //       child: ListTile(
                  //         title: Text(''),
                  //         subtitle: Text(
                  //             "Always being polite to customers gets you more sales."),
                  //       ),
                  //     ),
                  //     const Card(
                  //       child: ListTile(
                  //         title: Text(''),
                  //         subtitle: Text(
                  //             "MyVazi takes a 10% commission off every successful sale."),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // OnboardingPage(
                  //   title: 'Start Selling',
                  //   description:
                  //       "Thank you for expressing interest in selling online with us. \n\n Our goal is to help one million businesses profitably sell online by 2030 and we're excited to work with you. \n\n MyVazi helps you;",
                  //   regularCards: const [
                  //     Card(
                  //       child: ListTile(
                  //         title: Text(''),
                  //         subtitle: Text(
                  //             'Create a free online shop that enables you to sell and reach more customers'),
                  //       ),
                  //     ),
                  //     Card(
                  //       child: ListTile(
                  //         title: Text(''),
                  //         subtitle: Text(
                  //             'We connect you to affordable delivery services'),
                  //       ),
                  //     ),
                  //     Card(
                  //       child: ListTile(
                  //         title: Text(''),
                  //         subtitle: Text(
                  //             'We connect you to affordable delivery services'),
                  //       ),
                  //     ),
                  //   ],
                  //   quizCards: [
                  //     QuizCard(
                  //       question: '1. What is MyVazi?',
                  //       options: const [
                  //         'A: MyVazi is an app that helps businesses sell online',
                  //         'B: MyVazi is a boutique',
                  //         'C: MyVazi is a stylist'
                  //       ],
                  //       correctAnswer:
                  //           'A: MyVazi is an app that helps businesses sell online',
                  //       groupValue: selectedOption,
                  //       onOptionSelected: (String? selectedOption) {
                  //         // Handle option selection here if needed
                  //         if (selectedOption != null) {
                  //           // Do something with the selected option
                  //           print('Selected option: $selectedOption');
                  //         }
                  //       },
                  //     ),
                  //     QuizCard(
                  //       question: '2. What do customers pay for on MyVazi?',
                  //       options: const [
                  //         'A: Customers pay delivery fees',
                  //         'B: Customers pay for their orders only',
                  //         'C: Customers pay delivery fees and their order'
                  //       ],
                  //       correctAnswer: 'B: Customers pay for their orders only',
                  //       groupValue: selectedOption,
                  //       onOptionSelected: (String? selectedOption) {
                  //         // Handle option selection here if needed
                  //         if (selectedOption != null) {
                  //           // Do something with the selected option
                  //           print('Selected option: $selectedOption');
                  //         }
                  //       },
                  //     ),
                  //     QuizCard(
                  //       question: '3. How do we deliver upcountry?',
                  //       options: const [
                  //         'A: Using bodabodas',
                  //         'B: Using a Taxi or Bus',
                  //         "C: We don't deliver upcountry"
                  //       ],
                  //       correctAnswer: 'B: Using a Taxi or Bus',
                  //       groupValue: selectedOption,
                  //       onOptionSelected: (String? selectedOption) {
                  //         // Handle option selection here if needed
                  //         if (selectedOption != null) {
                  //           // Do something with the selected option
                  //           print('Selected option: $selectedOption');
                  //         }
                  //       },
                  //     ),
                  //     QuizCard(
                  //       question: '4. How do you pay MyVazi?',
                  //       options: const [
                  //         'A: We pay a 10% commission off every successful sale, through MTN Mobile Money or Airtel Money',
                  //         'B: 100,000 every month',
                  //         "C: We don't pay anything"
                  //       ],
                  //       correctAnswer:
                  //           'A: We pay a 10% commission off every successful sale, through MTN Mobile Money or Airtel Money',
                  //       groupValue: selectedOption,
                  //       onOptionSelected: (value) {
                  //         setState(() {
                  //           selectedOption = value;
                  //         });
                  //       },
                  //       // onOptionSelected: (String? selectedOption) {
                  //       //   // Handle option selection here if needed
                  //       //   if (selectedOption != null) {
                  //       //     // Do something with the selected option
                  //       //     print('Selected option: $selectedOption');
                  //       //   }
                  //       // },
                  //     ),
                  //   ], // Provide quiz cards here if needed
                  // ),

// Use the functions in your UI code
                  OnboardingPage(
                    title: ' ',
                    description: ' ',
                    cards: [
                      QuizCard(
                        question: '1. What is MyVazi?',
                        options: const [
                          'A: MyVazi is an app that helps businesses sell online',
                          'B: MyVazi is a boutique',
                          'C: MyVazi is a stylist'
                        ],
                        onSelected: (option) => handleUserResponse(1, option),
                      ),

                      QuizCard(
                        question: '2. What do customers pay for on MyVazi?',
                        options: const [
                          'A: Customers pay delivery fees',
                          'B: Customers pay for their orders only',
                          'C: Customers pay delivery fees and their order'
                        ],
                        onSelected: (option) => handleUserResponse(2, option),
                      ),
                      QuizCard(
                        question: '3. How do we deliver upcountry?',
                        options: const [
                          'A: Using bodabodas',
                          'B: Using a Taxi or Bus',
                          "C: We don't deliver upcountry"
                        ],
                        onSelected: (option) => handleUserResponse(3, option),
                      ),
                      QuizCard(
                        question: '4. How do you pay MyVazi?',
                        options: const [
                          'A: We pay a 10% commission off every successful sale, through MTN Mobile Money or Airtel Money',
                          'B: 100,000 every month',
                          "C: We don't pay anything"
                        ],
                        onSelected: (option) => handleUserResponse(4, option),
                      ),
                      // Repeat the above pattern for each quiz card
                      TextButton(
                        onPressed: () {
                          if (areAllAnswersCorrect()) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const QuizCompletedModal();
                              },
                            );
                          } else {
                            // Show a message indicating that not all answers are correct
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please answer all questions correctly.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: const Text('SUBMIT'),
                      ),
                    ],
                  ),

                  // OnboardingPage(
                  //   title: ' ',
                  //   description: ' ',
                  //   cards: [
                  //     const QuizCard(
                  //       question: '1. What is MyVazi?',
                  //       options: [
                  //         'A: MyVazi is an app that helps businesses sell online',
                  //         'B: MyVazi is a boutique',
                  //         'C: MyVazi is a stylist'
                  //       ],
                  //     ),
                  //     const QuizCard(
                  //       question: '2. What do customers pay for on MyVazi?',
                  //       options: [
                  //         'A: Customers pay delivery fees',
                  //         'B: Customers pay for their orders only',
                  //         'C: Customers pay delivery fees and their order'
                  //       ],
                  //     ),
                  //     const QuizCard(
                  //       question: '3. How do we deliver upcountry?',
                  //       options: [
                  //         'A: Using bodabodas',
                  //         'B: Using a Taxi or Bus',
                  //         "C: We don't deliver upcountry"
                  //       ],
                  //     ),
                  //     const QuizCard(
                  //       question: '4. How do you pay MyVazi?',
                  //       options: [
                  //         'A: We pay a 10% commission off every successful sale, through MTN Mobile Money or Airtel Money',
                  //         'B: 100,000 every month',
                  //         "C: We don't pay anything"
                  //       ],
                  //     ),
                  //     TextButton(
                  //       onPressed: () {
                  //         showDialog(
                  //           context: context,
                  //           builder: (BuildContext context) {
                  //             return const QuizCompletedModal();
                  //           },
                  //         );
                  //       },
                  //       child: const Text('SUBMIT'),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // TextButton(
            //   onPressed: _currentPageIndex > 0
            //       ? () {
            //           _controller.previousPage(
            //             duration: Duration(milliseconds: 500),
            //             curve: Curves.ease,
            //           );
            //         }
            //       : null,
            //   child: Text('PREVIOUS'),
            // ),
            IconButton(
              onPressed: _currentPageIndex > 0
                  ? () {
                      _controller.previousPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    }
                  : null,
              icon: const Icon(Icons.arrow_back),
            ),
            Text(
                '${_currentPageIndex + 1}/${3}'), // Change '3' to the total number of pages
            IconButton(
              onPressed: _currentPageIndex <
                      2 // Change '3' to the total number of pages minus 1
                  ? () {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    }
                  : null,
              icon: const Icon(Icons.arrow_forward),
            ),
            // TextButton(
            //   onPressed: _currentPageIndex <
            //           3 // Change '3' to the total number of pages minus 1
            //       ? () {
            //           _controller.nextPage(
            //             duration: Duration(milliseconds: 500),
            //             curve: Curves.ease,
            //           );
            //         }
            //       : null,
            //   child: Text('NEXT'),
            // ),
          ],
        ),
      ),
    );
  }
}
/*
class OnboardingPage extends StatefulWidget {
  final String title;
  final String description;
  final List<Widget> regularCards;
  final List<QuizCard> quizCards;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.regularCards,
    required this.quizCards,
  });

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  List<String?> userResponses = [];
  bool passedQuiz = false;

  @override
  void initState() {
    super.initState();
    userResponses = List.filled(widget.quizCards.length, null);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.description,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 10),
            // Display regular cards or quiz cards based on the page index
            if (widget.quizCards.isNotEmpty)
              ...widget.quizCards.map((quizCard) {
                return quizCard.copyWith(
                  onOptionSelected: (value) {
                    setState(() {
                      int index = widget.quizCards.indexOf(quizCard);
                      userResponses[index] = value;
                    });
                  },
                );
              })
            else
              ...widget.regularCards,
            // Submit button
            if (widget.quizCards.isNotEmpty)
              TextButton(
                onPressed: () {
                  // Check user responses
                  bool allCorrect = true;
                  for (int i = 0; i < userResponses.length; i++) {
                    if (userResponses[i] != widget.quizCards[i].correctAnswer) {
                      allCorrect = false;
                      break;
                    }
                  }
                  setState(() {
                    passedQuiz = allCorrect;
                  });
                  // Show modal based on result
                  if (allCorrect) {
                    // Show congratulatory modal
                    // ShowModalHere();
                  } else {
                    // Show modal asking to redo
                    // ShowModalHere();
                  }
                },
                child: const Text('SUBMIT'),
              ),
          ],
        ),
      ),
    );
  }
}
*/

// class QuizCard extends StatelessWidget {
//   final String question;
//   final List<String> options;
//   final String correctAnswer;
//   final Function(String?) onOptionSelected;

//   const QuizCard({super.key,
//     required this.question,
//     required this.options,
//     required this.correctAnswer,
//     required this.onOptionSelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             question,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Column(
//             children: options.map((option) {
//               return RadioListTile<String>(
//                 title: Text(option),
//                 value: option,
//                 groupValue: null,
//                 onChanged: (value) => onOptionSelected(value),
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }

//   QuizCard copyWith({
//     required Function(String?) onOptionSelected,
//   }) {
//     return QuizCard(
//       question: question,
//       options: options,
//       correctAnswer: correctAnswer,
//       onOptionSelected: onOptionSelected,
//     );
//   }
// }

/*
class QuizCard extends StatelessWidget {
  final String question;
  final List<String> options;
  final String? groupValue; // Updated to accept nullable groupValue
  final String correctAnswer;
  final Function(String?) onOptionSelected;

  const QuizCard({
    Key? key,
    required this.question,
    required this.options,
    required this.groupValue,
    required this.correctAnswer,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: options.map((option) {
              return RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: groupValue,
                onChanged: onOptionSelected,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  QuizCard copyWith({
    String? question,
    List<String>? options,
    String? correctAnswer,
    Function(String?)? onOptionSelected,
  }) {
    return QuizCard(
      question: question ?? this.question,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      groupValue: groupValue ?? groupValue,
      onOptionSelected: onOptionSelected ?? this.onOptionSelected,
    );
  }
}
*/

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final List<Widget> cards;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 10),
            // Display smaller cards
            ...cards.map((card) => card),
          ],
        ),
      ),
    );
  }
}

class QuizCard extends StatefulWidget {
  final String question;
  final List<String> options;
  final Function(String option)
      onSelected; // Change the parameter type to String

  // Modify the constructor to accept the onSelected parameter
  const QuizCard({
    super.key, // Add Key? key parameter
    required this.question,
    required this.options,
    required this.onSelected, // Accept the onSelected parameter
  }); // Pass the key parameter to the superclass constructor

  @override
  State<QuizCard> createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard> {
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.question,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: widget.options.map((option) {
                return RadioListTile<String>(
                  title: Text(option),
                  value: option,
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value;
                      widget.onSelected(
                          value!); // Call the onSelected callback with the selected option
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}


// class QuizCard extends StatefulWidget {
//   final String question;
//   final List<String> options;
//   Function(dynamic option) onSelected;

//   QuizCard({
//     super.key,
//     required this.question,
//     required this.options,
//     required void Function(dynamic option) onSelected,
//   });

//   @override
//   State<QuizCard> createState() => _QuizCardState();
// }

// class _QuizCardState extends State<QuizCard> {
//   String? _selectedOption;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               widget.question,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 17,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Column(
//               children: widget.options.map((option) {
//                 return RadioListTile<String>(
//                   title: Text(option),
//                   value: option,
//                   groupValue: _selectedOption,
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedOption = value;
//                     });
//                   },
//                 );
//               }).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
