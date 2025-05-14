import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:readify/models/book.dart';
import 'package:readify/services/book_service.dart';

// Events
abstract class BookEvent extends Equatable {
  const BookEvent();

  @override
  List<Object> get props => [];
}

class LoadBooks extends BookEvent {}

class SearchBooks extends BookEvent {
  final String query;

  const SearchBooks(this.query);

  @override
  List<Object> get props => [query];
}

// States
abstract class BookState extends Equatable {
  const BookState();

  @override
  List<Object> get props => [];
}

class BookInitial extends BookState {}

class BookLoading extends BookState {}

class BookLoaded extends BookState {
  final List<Book> books;

  const BookLoaded(this.books);

  @override
  List<Object> get props => [books];
}

class BookError extends BookState {
  final String message;

  const BookError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class BookBloc extends Bloc<BookEvent, BookState> {
  final BookService _bookService;

  BookBloc(this._bookService) : super(BookInitial()) {
    on<LoadBooks>(_onLoadBooks);
    on<SearchBooks>(_onSearchBooks);
  }

  Future<void> _onLoadBooks(LoadBooks event, Emitter<BookState> emit) async {
    try {
      emit(BookLoading());
      final books = await _bookService.getBooks();
      emit(BookLoaded(books));
    } catch (e) {
      emit(BookError(e.toString()));
    }
  }

  Future<void> _onSearchBooks(SearchBooks event, Emitter<BookState> emit) async {
    try {
      emit(BookLoading());
      final books = await _bookService.searchBooks(event.query);
      emit(BookLoaded(books));
    } catch (e) {
      emit(BookError(e.toString()));
    }
  }
} 