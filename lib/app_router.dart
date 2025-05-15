import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:readify/screens/home_screen.dart';
import 'package:readify/screens/search_screen.dart';
import 'package:readify/screens/favorites_screen.dart';
import 'package:readify/screens/profile_screen.dart';
import 'package:readify/screens/auth/login_screen.dart';
import 'package:readify/screens/auth/register_screen.dart';
import 'package:readify/screens/book_details_screen.dart';
import 'package:readify/screens/error_screen.dart';
import 'package:readify/models/book.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    errorBuilder: (context, state) => ErrorScreen(
      error: state.error.toString(),
    ),
    routes: [
      // Auth routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Main app shell with bottom navigation
      ShellRoute(
        builder: (context, state, child) {
          return ScaffoldWithBottomNav(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: '/favorites',
            builder: (context, state) => const FavoritesScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      
      // Book details route
      GoRoute(
        path: '/book/:id',
        builder: (context, state) {
          final bookId = state.pathParameters['id'];
          if (bookId == null) {
            throw Exception('Book ID is required');
          }
          final book = state.extra as Book;
          return BookDetailsScreen(book: book);
        },
      ),
      
      // Redirect from root to home
      GoRoute(
        path: '/',
        redirect: (context, state) => '/home',
      ),
    ],
  );
}

class ScaffoldWithBottomNav extends StatelessWidget {
  final Widget child;

  const ScaffoldWithBottomNav({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.search_outlined),
            selectedIcon: const Icon(Icons.search),
            label: l10n.search,
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite_outline),
            selectedIcon: const Icon(Icons.favorite),
            label: l10n.favorites,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l10n.profile,
          ),
        ],
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/search');
              break;
            case 2:
              context.go('/favorites');
              break;
            case 3:
              context.go('/profile');
              break;
          }
        },
      ),
    );
  }
}