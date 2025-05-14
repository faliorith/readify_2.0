import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'home_tab.dart';
import 'search_tab.dart';
import 'library_tab.dart';
import 'profile_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    HomeTab(),
    SearchTab(),
    LibraryTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! Authenticated) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: _tabs,
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home),
                label: AppLocalizations.of(context)!.homeTab,
              ),
              NavigationDestination(
                icon: const Icon(Icons.search),
                label: AppLocalizations.of(context)!.searchTab,
              ),
              NavigationDestination(
                icon: const Icon(Icons.library_books),
                label: AppLocalizations.of(context)!.libraryTab,
              ),
              NavigationDestination(
                icon: const Icon(Icons.person),
                label: AppLocalizations.of(context)!.profileTab,
              ),
            ],
          ),
        );
      },
    );
  }
} 