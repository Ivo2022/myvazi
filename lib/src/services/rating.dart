import 'package:flutter/material.dart';

/*
We create a StarRating widget that takes the rating and displays star icons accordingly.
The rating parameter defines the number of filled stars.
The starCount parameter determines the total number of stars.
The size parameter sets the size of each star.
The color parameter sets the color of the stars.
 */

class StarRating extends StatelessWidget {
  final double rating;
  final int starCount;
  final double size;
  final Color color;

  const StarRating({
    Key? key,
    required this.rating,
    this.starCount = 5,
    this.size = 24.0,
    this.color = Colors.orange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(starCount, (index) {
        double difference = rating - index;
        IconData starIcon;

        if (difference >= 1.0) {
          starIcon = Icons.star;
        } else if (difference >= 0.5) {
          starIcon = Icons.star_half;
        } else {
          starIcon = Icons.star_border;
        }

        return Icon(
          starIcon,
          size: size,
          color: color,
        );
      }),
    );
  }
}

// class MyRating extends StatelessWidget {
//   const MyRating({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Star Rating Example'),
//         ),
//         body: Center(
//           child: StarRating(rating: 2.8),
//         ),
//       ),
//     );
//   }
// }
