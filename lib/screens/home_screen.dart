// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/book/book_bloc.dart';
import '../blocs/book/book_event.dart';
import '../blocs/book/book_state.dart';
import '../models/book.dart';
import '../components/book_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    context.read<BookBloc>().add(LoadBooks());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Readify'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: BookSearchDelegate(context.read<BookBloc>()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<BookBloc, BookState>(
        builder: (context, state) {
          if (state is BookLoadInProgress) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BookLoadSuccess) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<BookBloc>().add(LoadBooks());
              },
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: state.books.length,
                itemBuilder: (context, index) {
                  final book = state.books[index];
                  return BookCard(book: book);
                },
              ),
            );
          } else if (state is BookLoadFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Не удалось загрузить книги'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<BookBloc>().add(LoadBooks());
                    },
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class BookSearchDelegate extends SearchDelegate {
  final BookBloc _bookBloc;

  BookSearchDelegate(this._bookBloc);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    _bookBloc.add(SearchBooks(query));
    return BlocBuilder<BookBloc, BookState>(
      bloc: _bookBloc,
      builder: (context, state) {
        if (state is BookLoadInProgress) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BookLoadSuccess) {
          final filteredBooks = state.books.where((book) =>
              book.title.toLowerCase().contains(query.toLowerCase()) ||
              book.author.toLowerCase().contains(query.toLowerCase())).toList();
          
          if (filteredBooks.isEmpty) {
            return const Center(child: Text('Книги не найдены'));
          }
          
          return ListView.builder(
            itemCount: filteredBooks.length,
            itemBuilder: (context, index) {
              final book = filteredBooks[index];
              return ListTile(
                leading: book.coverUrl != null
                    ? Image.network(
                        book.coverUrl!,
                        width: 50,
                        height: 75,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.book),
                title: Text(book.title),
                subtitle: Text(book.author),
                onTap: () {
                  // Навигация к деталям книги
                  close(context, book);
                },
              );
            },
          );
        }
        return const Center(child: Text('Произошла ошибка'));
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
} 