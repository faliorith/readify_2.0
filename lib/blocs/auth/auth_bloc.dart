import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readify/services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc({required this.authService}) : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
    
    // Если currentUser синхронный — можно оставить
    add(CheckAuthStatus());
  }

  Future<void> _onCheckAuthStatus(CheckAuthStatus event, Emitter<AuthState> emit) async {
    try {
      final user = await authService.currentUser; // если async
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError("Failed to check auth status: ${e.toString()}"));
    }
  }

  Future<void> _onSignInRequested(SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await authService.signInWithEmailAndPassword(
        event.email,
        event.password,
      );
      final user = result.user;
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(AuthError("User is null after sign in"));
      }
    } catch (e) {
      emit(AuthError("Sign in failed: ${e.toString()}"));
    }
  }

  Future<void> _onSignUpRequested(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await authService.registerWithEmailAndPassword(
        event.email,
        event.password,
        name: event.name,
      );
      final user = result.user;
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(AuthError("User is null after sign up"));
      }
    } catch (e) {
      emit(AuthError("Sign up failed: ${e.toString()}"));
    }
  }

  Future<void> _onSignOutRequested(SignOutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authService.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError("Sign out failed: ${e.toString()}"));
    }
  }

  Future<void> _onUpdateProfileRequested(UpdateProfileRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authService.currentUser;
      if (user != null) {
        await authService.updateProfile(
          userId: user.uid,
          name: event.name,
          photoUrl: event.photoUrl,
        );

        await authService.reloadUser(); // если реализовано
        final updatedUser = await authService.currentUser;
        if (updatedUser != null) {
          emit(Authenticated(updatedUser));
        } else {
          emit(AuthError("Failed to reload updated user"));
        }
      } else {
        emit(AuthError("No user found to update profile"));
      }
    } catch (e) {
      emit(AuthError("Profile update failed: ${e.toString()}"));
    }
  }
}
