import 'package:equatable/equatable.dart';
import '../../models/book.dart';

abstract class BookEvent extends Equatable {
  const BookEvent();

  @override
  List<Object?> get props => [];
}

class LoadBooks extends BookEvent {}

class SearchBooks extends BookEvent {
  final String query;

  const SearchBooks(this.query);

  @override
  List<Object?> get props => [query];
}

class AddToFavorites extends BookEvent {
  final Book book;

  const AddToFavorites(this.book);

  @override
  List<Object?> get props => [book];
}

class RemoveFromFavorites extends BookEvent {
  final Book book;

  const RemoveFromFavorites(this.book);

  @override
  List<Object?> get props => [book];
}

class FilterBooks extends BookEvent {
  final List<String> categories;
  final double? minRating;
  final String? author;

  const FilterBooks({
    this.categories = const [],
    this.minRating,
    this.author,
  });

  @override
  List<Object?> get props => [categories, minRating, author];
}

class UpdateBook extends BookEvent {
  final Book book;

  const UpdateBook(this.book);

  @override
  List<Object?> get props => [book];
} 