import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Book extends Equatable {
  final String id;
  final String title;
  final String author;
  final String? description;
  final String? coverUrl;
  final List<String> categories;
  final double rating;
  final int reviewsCount;
  final DateTime publishedDate;
  final bool isFavorite;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    this.description,
    this.coverUrl,
    this.categories = const [],
    this.rating = 0.0,
    this.reviewsCount = 0,
    required this.publishedDate,
    this.isFavorite = false,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        author,
        description,
        coverUrl,
        categories,
        rating,
        reviewsCount,
        publishedDate,
        isFavorite,
      ];

  factory Book.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Book(
      id: doc.id,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      description: data['description'],
      coverUrl: data['coverUrl'],
      categories: List<String>.from(data['categories'] ?? []),
      rating: (data['rating'] ?? 0.0).toDouble(),
      reviewsCount: data['reviewsCount'] ?? 0,
      publishedDate: (data['publishedDate'] as Timestamp).toDate(),
      isFavorite: data['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'coverUrl': coverUrl,
      'categories': categories,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'publishedDate': Timestamp.fromDate(publishedDate),
      'isFavorite': isFavorite,
    };
  }

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    String? coverUrl,
    List<String>? categories,
    double? rating,
    int? reviewsCount,
    DateTime? publishedDate,
    bool? isFavorite,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      coverUrl: coverUrl ?? this.coverUrl,
      categories: categories ?? this.categories,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      publishedDate: publishedDate ?? this.publishedDate,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}