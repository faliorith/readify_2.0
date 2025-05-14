import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! Authenticated) {
          return const Center(child: CircularProgressIndicator());
        }

        // Получаем данные пользователя из Firestore
        return FutureBuilder<UserModel?>(
          future: context.read<AuthService>().getCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final user = snapshot.data;
            if (user == null) {
              return const Center(child: Text('Error loading user data'));
            }

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  title: Text('Welcome, ${user.name}'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.notifications),
                      onPressed: () {
                        // TODO: Implement notifications
                      },
                    ),
                  ],
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Continue Reading',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: 5, // TODO: Replace with actual data
                      itemBuilder: (context, index) {
                        return const _BookCard();
                      },
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Recommended for You',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => const _BookCard(),
                      childCount: 6, // TODO: Replace with actual data
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _BookCard extends StatelessWidget {
  const _BookCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                image: const DecorationImage(
                  image: NetworkImage('https://via.placeholder.com/150'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Book Title',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Author Name',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 