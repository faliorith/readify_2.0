import 'package:equatable/equatable.dart';
import '../../models/book.dart';

abstract class BookState extends Equatable {
  const BookState();

  @override
  List<Object?> get props => [];
}

class BookInitial extends BookState {}

class BookLoadInProgress extends BookState {}

class BookLoadSuccess extends BookState {
  final List<Book> books;
  final List<String> categories;
  final List<String> authors;
  final List<Book> favorites;
  final String? searchQuery;
  final List<String>? selectedCategories;
  final double? minRating;
  final String? selectedAuthor;

  const BookLoadSuccess({
    required this.books,
    this.categories = const [],
    this.authors = const [],
    this.favorites = const [],
    this.searchQuery,
    this.selectedCategories,
    this.minRating,
    this.selectedAuthor,
  });

  @override
  List<Object?> get props => [
        books,
        categories,
        authors,
        favorites,
        searchQuery,
        selectedCategories,
        minRating,
        selectedAuthor,
      ];

  BookLoadSuccess copyWith({
    List<Book>? books,
    List<String>? categories,
    List<String>? authors,
    List<Book>? favorites,
    String? searchQuery,
    List<String>? selectedCategories,
    double? minRating,
    String? selectedAuthor,
  }) {
    return BookLoadSuccess(
      books: books ?? this.books,
      categories: categories ?? this.categories,
      authors: authors ?? this.authors,
      favorites: favorites ?? this.favorites,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      minRating: minRating ?? this.minRating,
      selectedAuthor: selectedAuthor ?? this.selectedAuthor,
    );
  }
}

class BookLoadFailure extends BookState {
  final String message;

  const BookLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
} 