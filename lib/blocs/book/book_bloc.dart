// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/book_repository.dart';
import 'book_event.dart';
import 'book_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final BookRepository _bookRepository;
  final FirebaseAuth _auth;
  StreamSubscription? _favoritesSubscription;

  BookBloc({
    required BookRepository bookRepository,
    required FirebaseAuth auth,
  })  : _bookRepository = bookRepository,
        _auth = auth,
        super(BookInitial()) {
    on<LoadBooks>(_onLoadBooks);
    on<SearchBooks>(_onSearchBooks);
    on<FilterBooks>(_onFilterBooks);
    on<AddToFavorites>(_onAddToFavorites);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
    on<UpdateBook>(_onUpdateBook);

    // Подписываемся на изменения в избранном
    _subscribeTofavorites();
  }

  Future<void> _onLoadBooks(LoadBooks event, Emitter<BookState> emit) async {
    emit(BookLoadInProgress());
    try {
      final books = await _bookRepository.getBooks();
      final categories = await _bookRepository.getCategories();
      final authors = await _bookRepository.getAuthors();
      
      emit(BookLoadSuccess(
        books: books,
        categories: categories,
        authors: authors,
      ));
    } catch (e) {
      emit(BookLoadFailure(e.toString()));
    }
  }

  Future<void> _onSearchBooks(SearchBooks event, Emitter<BookState> emit) async {
    if (state is BookLoadSuccess) {
      final currentState = state as BookLoadSuccess;
      try {
        final searchResults = await _bookRepository.searchBooks(event.query);
        emit(currentState.copyWith(
          books: searchResults,
          searchQuery: event.query,
        ));
      } catch (e) {
        emit(BookLoadFailure(e.toString()));
      }
    }
  }

  Future<void> _onFilterBooks(FilterBooks event, Emitter<BookState> emit) async {
    if (state is BookLoadSuccess) {
      final currentState = state as BookLoadSuccess;
      try {
        final filteredBooks = await _bookRepository.filterBooks(
          categories: event.categories,
          minRating: event.minRating,
          author: event.author,
        );
        emit(currentState.copyWith(
          books: filteredBooks,
          selectedCategories: event.categories,
          minRating: event.minRating,
          selectedAuthor: event.author,
        ));
      } catch (e) {
        emit(BookLoadFailure(e.toString()));
      }
    }
  }

  Future<void> _onAddToFavorites(
      AddToFavorites event, Emitter<BookState> emit) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        await _bookRepository.addToFavorites(userId, event.book);
      }
    } catch (e) {
      emit(BookLoadFailure(e.toString()));
    }
  }

  Future<void> _onRemoveFromFavorites(
      RemoveFromFavorites event, Emitter<BookState> emit) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        await _bookRepository.removeFromFavorites(userId, event.book.id);
      }
    } catch (e) {
      emit(BookLoadFailure(e.toString()));
    }
  }

  Future<void> _onUpdateBook(UpdateBook event, Emitter<BookState> emit) async {
    if (state is BookLoadSuccess) {
      final currentState = state as BookLoadSuccess;
      try {
        await _bookRepository.updateBook(event.book);
        final updatedBooks = currentState.books.map((book) {
          return book.id == event.book.id ? event.book : book;
        }).toList();
        emit(currentState.copyWith(books: updatedBooks));
      } catch (e) {
        emit(BookLoadFailure(e.toString()));
      }
    }
  }

  void _subscribeTofavorites() {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      _favoritesSubscription?.cancel();
      _favoritesSubscription = _bookRepository
          .getFavoriteBooks(userId)
          .listen((favoriteBooks) {
        if (state is BookLoadSuccess) {
          final currentState = state as BookLoadSuccess;
          emit(currentState.copyWith(favorites: favoriteBooks));
        }
      });
    }
  }

  @override
  Future<void> close() {
    _favoritesSubscription?.cancel();
    return super.close();
  }
} 