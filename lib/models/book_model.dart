import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class BookModel extends Equatable {
  final String id;
  final String title;
  final String author;
  final String description;
  final String coverUrl;
  final List<String> categories;
  final int pageCount;
  final double rating;
  final int ratingCount;

  const BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.coverUrl,
    required this.categories,
    required this.pageCount,
    this.rating = 0.0,
    this.ratingCount = 0,
  });

  factory BookModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BookModel(
      id: doc.id,
      title: data['title'] as String,
      author: data['author'] as String,
      description: data['description'] as String,
      coverUrl: data['coverUrl'] as String,
      categories: List<String>.from(data['categories'] ?? []),
      pageCount: data['pageCount'] as int,
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: data['ratingCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'coverUrl': coverUrl,
      'categories': categories,
      'pageCount': pageCount,
      'rating': rating,
      'ratingCount': ratingCount,
    };
  }

  BookModel copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    String? coverUrl,
    List<String>? categories,
    int? pageCount,
    double? rating,
    int? ratingCount,
  }) {
    return BookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      coverUrl: coverUrl ?? this.coverUrl,
      categories: categories ?? this.categories,
      pageCount: pageCount ?? this.pageCount,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        author,
        description,
        coverUrl,
        categories,
        pageCount,
        rating,
        ratingCount,
      ];
} 