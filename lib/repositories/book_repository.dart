// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book.dart';

class BookRepository {
  final FirebaseFirestore _firestore;
  final String _collection = 'books';

  BookRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<Book>> getBooks() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      return snapshot.docs.map((doc) => Book.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to load books: $e');
    }
  }

  Future<List<Book>> searchBooks(String query) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThan: query + 'z')
          .get();

      final authorSnapshot = await _firestore
          .collection(_collection)
          .where('author', isGreaterThanOrEqualTo: query)
          .where('author', isLessThan: query + 'z')
          .get();

      final books = snapshot.docs.map((doc) => Book.fromFirestore(doc)).toList();
      final authorBooks =
          authorSnapshot.docs.map((doc) => Book.fromFirestore(doc)).toList();

      return {...books, ...authorBooks}.toList();
    } catch (e) {
      throw Exception('Failed to search books: $e');
    }
  }

  Future<List<Book>> filterBooks({
    List<String>? categories,
    double? minRating,
    String? author,
  }) async {
    try {
      Query query = _firestore.collection(_collection);

      if (categories != null && categories.isNotEmpty) {
        query = query.where('categories', arrayContainsAny: categories);
      }

      if (minRating != null) {
        query = query.where('rating', isGreaterThanOrEqualTo: minRating);
      }

      if (author != null) {
        query = query.where('author', isEqualTo: author);
      }

      final snapshot = await query.get();
      return snapshot.docs.map((doc) => Book.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to filter books: $e');
    }
  }

  Future<void> updateBook(Book book) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(book.id)
          .update(book.toMap());
    } catch (e) {
      throw Exception('Failed to update book: $e');
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      final categories = snapshot.docs
          .expand((doc) => (doc.data()['categories'] as List<dynamic>?)?.cast<String>() ?? [])
          .toSet()
          .toList();
      return List<String>.from(categories);
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  Future<List<String>> getAuthors() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      final authors = snapshot.docs
          .map((doc) => doc.data()['author'] as String)
          .toSet()
          .toList();
      return authors;
    } catch (e) {
      throw Exception('Failed to load authors: $e');
    }
  }

  Stream<List<Book>> getFavoriteBooks(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Book.fromFirestore(doc)).toList());
  }

  Future<void> addToFavorites(String userId, Book book) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(book.id)
          .set(book.toMap());
    } catch (e) {
      throw Exception('Failed to add book to favorites: $e');
    }
  }

  Future<void> removeFromFavorites(String userId, String bookId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(bookId)
          .delete();
    } catch (e) {
      throw Exception('Failed to remove book from favorites: $e');
    }
  }
} 