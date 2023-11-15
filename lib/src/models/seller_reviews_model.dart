class Review {
  final String dateCreated;
  final String comment;
  final String ratings;

  Review({
    required this.dateCreated,
    required this.comment,
    required this.ratings,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      dateCreated: json['date_created'],
      comment: json['comment'],
      ratings: json['ratings'],
    );
  }
}

class ReviewsResponse {
  final List<Review> reviews;
  final int countRatings;
  final double averageRatings;

  ReviewsResponse({
    required this.reviews,
    required this.countRatings,
    required this.averageRatings,
  });

  factory ReviewsResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> reviewsList = json['reviews'];
    List<Review> reviews = reviewsList.map((review) {
      return Review.fromJson(review);
    }).toList();

    return ReviewsResponse(
      reviews: reviews,
      countRatings: json['countratings'],
      averageRatings: json['averageratings'],
    );
  }
}
