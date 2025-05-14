import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/book.dart';
import '../blocs/book/book_bloc.dart';
import '../blocs/book/book_event.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book book;

  const BookDetailsScreen({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Гибкий AppBar с изображением книги
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                book.title,
                style: const TextStyle(
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ],
                ),
              ),
              background: Hero(
                tag: 'book-${book.id}',
                child: book.coverUrl != null
                    ? Image.network(
                        book.coverUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.book,
                              size: 64,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.book,
                            size: 64,
                            color: Colors.grey,
                          ),
                        ),
                      ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  book.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: book.isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  if (book.isFavorite) {
                    context.read<BookBloc>().add(RemoveFromFavorites(book));
                  } else {
                    context.read<BookBloc>().add(AddToFavorites(book));
                  }
                },
              ),
            ],
          ),
          // Контент
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Автор
                  Text(
                    book.author,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  // Рейтинг
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${book.rating.toStringAsFixed(1)} (${book.reviewsCount} отзывов)',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Категории
                  if (book.categories.isNotEmpty) ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: book.categories.map((category) {
                        return Chip(
                          label: Text(category),
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          labelStyle: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                  // Описание
                  Text(
                    'Описание',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book.description ?? 'Описание отсутствует',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  // Дата публикации
                  Text(
                    'Дата публикации',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${book.publishedDate.day}.${book.publishedDate.month}.${book.publishedDate.year}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 