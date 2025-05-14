import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/book/book_bloc.dart';
import '../blocs/book/book_state.dart';
import '../components/book_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Информация о пользователе
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Имя пользователя',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'email@example.com',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            // Статистика
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(context, '12', 'Прочитано'),
                  _buildStatItem(context, '5', 'Читаю сейчас'),
                  _buildStatItem(context, '8', 'В избранном'),
                ],
              ),
            ),
            const Divider(),
            // Избранные книги
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Избранные книги',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<BookBloc, BookState>(
                    builder: (context, state) {
                      if (state is BookLoadSuccess) {
                        if (state.favorites.isEmpty) {
                          return const Center(
                            child: Text('Нет избранных книг'),
                          );
                        }
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: state.favorites.length,
                          itemBuilder: (context, index) {
                            return BookCard(book: state.favorites[index]);
                          },
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }
} 