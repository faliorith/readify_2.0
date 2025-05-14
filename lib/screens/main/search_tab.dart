import 'package:flutter/material.dart';
import '../../services/book_service.dart';
import '../../models/book.dart';
import '../../components/book_card.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final _searchController = TextEditingController();
  final _bookService = BookService();
  List<Book>? _searchResults;
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _bookService.searchBooks(query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search books...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  _performSearch(value);
                },
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _searchResults == null
                      ? const Center(
                          child: Text('Start typing to search for books'),
                        )
                      : _searchResults!.isEmpty
                          ? const Center(
                              child: Text('No books found'),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              itemCount: _searchResults!.length,
                              itemBuilder: (context, index) {
                                final book = _searchResults![index];
                                return BookCard(
                                  book: book,
                                  onTap: () {
                                    // TODO: Navigate to book details
                                  },
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
} 