import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.of(context).pushReplacementNamed('/home');
        } else if (state is Unauthenticated) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FlutterLogo(size: 100),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.appTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
} 