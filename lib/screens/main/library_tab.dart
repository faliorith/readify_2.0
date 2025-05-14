// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';
import '../../services/book_service.dart';

class LibraryTab extends StatefulWidget {
  const LibraryTab({super.key});

  @override
  State<LibraryTab> createState() => _LibraryTabState();
}

class _LibraryTabState extends State<LibraryTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _bookService = BookService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! Authenticated) {
          return const Center(child: CircularProgressIndicator());
        }

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

            return Scaffold(
              appBar: AppBar(
                title: const Text('My Library'),
                bottom: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Reading'),
                    Tab(text: 'Favorites'),
                  ],
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: [
                  _ReadingList(userId: user.id),
                  _FavoritesList(userId: user.id),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _ReadingList extends StatelessWidget {
  final String userId;

  const _ReadingList({required this.userId});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: 4, // TODO: Replace with actual data
      itemBuilder: (context, index) {
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
                      style: TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: 0.3, // TODO: Replace with actual progress
                      backgroundColor: Colors.grey[200],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '30% completed', // TODO: Replace with actual progress
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FavoritesList extends StatelessWidget {
  final String userId;

  const _FavoritesList({required this.userId});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: 6, // TODO: Replace with actual data
      itemBuilder: (context, index) {
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        image: const DecorationImage(
                          image: NetworkImage('https://via.placeholder.com/150'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Book Title',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Author Name',
                      style: TextStyle(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 