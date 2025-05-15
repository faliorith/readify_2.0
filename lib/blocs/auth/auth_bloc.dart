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

    add(CheckAuthStatus());
  }

  void _onCheckAuthStatus(CheckAuthStatus event, Emitter<AuthState> emit) {
    final user = authService.currentUser;
    if (user != null) {
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignInRequested(SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await authService.signInWithEmailAndPassword(
        event.email,
        event.password,
      );
      emit(Authenticated(result.user!));
    } catch (e) {
      emit(AuthError(e.toString()));
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
      emit(Authenticated(result.user!));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOutRequested(SignOutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authService.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onUpdateProfileRequested(UpdateProfileRequested event, Emitter<AuthState> emit) async {
    try {
      final user = authService.currentUser;
      if (user != null) {
        await authService.updateProfile(
          userId: user.uid,
          name: event.name,
          photoUrl: event.photoUrl,
        );
        emit(Authenticated(user));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}