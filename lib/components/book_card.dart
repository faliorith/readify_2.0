import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/book.dart';
import '../blocs/book/book_bloc.dart';
import '../blocs/book/book_event.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap;

  const BookCard({
    super.key,
    required this.book,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap ?? () {
          // Навигация к деталям книги
          Navigator.pushNamed(
            context,
            '/book/${book.id}',
            arguments: book,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Обложка книги
            AspectRatio(
              aspectRatio: 0.7,
              child: book.coverUrl != null
                  ? Hero(
                      tag: 'book-${book.id}',
                      child: Image.network(
                        book.coverUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.book,
                              size: 48,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.book,
                        size: 48,
                        color: Colors.grey,
                      ),
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Название книги
                    Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    // Автор
                    Text(
                      book.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const Spacer(),
                    // Рейтинг и кнопка избранного
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              book.rating.toStringAsFixed(1),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(
                            book.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: book.isFavorite ? Colors.red : null,
                          ),
                          onPressed: () {
                            if (book.isFavorite) {
                              context
                                  .read<BookBloc>()
                                  .add(RemoveFromFavorites(book));
                            } else {
                              context.read<BookBloc>().add(AddToFavorites(book));
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 