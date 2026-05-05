import 'package:equatable/equatable.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState extends Equatable {
  final AuthStatus status;
  final bool isSignInMode;
  final String? email;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.isSignInMode = true,
    this.email,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    bool? isSignInMode,
    String? email,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      isSignInMode: isSignInMode ?? this.isSignInMode,
      email: email ?? this.email,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, isSignInMode, email, errorMessage];
}
