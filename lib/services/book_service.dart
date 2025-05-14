import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book.dart';

class BookService {
  final Dio _dio;
  final String _baseUrl = 'https://www.googleapis.com/books/v1';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  BookService() : _dio = Dio() {
    _dio.options.baseUrl = _baseUrl;
  }

  Future<List<Book>> searchBooks(String query) async {
    try {
      final response = await _dio.get('/volumes', queryParameters: {
        'q': query,
        'maxResults': 20,
      });

      if (response.data['items'] == null) {
        return [];
      }

      return (response.data['items'] as List)
          .map((item) => _convertToBook(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to search books: ${e.toString()}');
    }
  }

  Future<Book> getBookDetails(String bookId) async {
    try {
      final response = await _dio.get('/volumes/$bookId');
      return _convertToBook(response.data);
    } catch (e) {
      throw Exception('Failed to get book details: ${e.toString()}');
    }
  }

  Book _convertToBook(Map<String, dynamic> item) {
    final volumeInfo = item['volumeInfo'];
    return Book(
      id: item['id'],
      title: volumeInfo['title'] ?? 'Unknown Title',
      author: volumeInfo['authors']?[0] ?? 'Unknown Author',
      description: volumeInfo['description'] ?? 'No description available',
      coverUrl: volumeInfo['imageLinks']?['thumbnail'] ??
          'https://via.placeholder.com/128x192.png?text=No+Cover',
      publishedDate: DateTime.now(), // Используем текущую дату как заглушку
    );
  }

  Future<List<Book>> getBooks() async {
    final snapshot = await _firestore.collection('books').get();
    return snapshot.docs.map((doc) => Book.fromFirestore(doc)).toList();
  }

  Future<List<Book>> searchBooksFirestore(String query) async {
    final snapshot = await _firestore
        .collection('books')
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThan: '${query}z')
        .get();
    return snapshot.docs.map((doc) => Book.fromFirestore(doc)).toList();
  }
} 