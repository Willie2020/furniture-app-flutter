import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/auth_database.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthDatabase _authDb = AuthDatabase.instance;

  AuthBloc() : super(const AuthState()) {
    on<SignInRequested>(_onSignIn);
    on<SignUpRequested>(_onSignUp);
    on<SignOutRequested>(_onSignOut);
    on<ToggleAuthMode>(_onToggleMode);
  }

  Future<void> _onSignIn(SignInRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    try {
      final success = await _authDb.signIn(event.email, event.password);
      if (success) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          email: event.email.trim().toLowerCase(),
        ));
      } else {
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Invalid email or password.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Database error: ${e.toString()}',
      ));
    }
  }

  Future<void> _onSignUp(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    try {
      final success = await _authDb.signUp(event.email, event.password);
      if (success) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          email: event.email.trim().toLowerCase(),
        ));
      } else {
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Email already registered.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Database error: ${e.toString()}',
      ));
    }
  }

  void _onSignOut(SignOutRequested event, Emitter<AuthState> emit) {
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  void _onToggleMode(ToggleAuthMode event, Emitter<AuthState> emit) {
    emit(state.copyWith(
      isSignInMode: !state.isSignInMode,
      errorMessage: null,
      status: AuthStatus.initial,
    ));
  }
}
