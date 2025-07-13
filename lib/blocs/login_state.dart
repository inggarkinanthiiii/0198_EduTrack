import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final String role;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String? token;

  const LoginState({
    required this.email,
    required this.password,
    required this.role,
    required this.isSubmitting,
    required this.isSuccess,
    required this.isFailure,
    this.token,
  });

  factory LoginState.initial() {
    return const LoginState(
      email: '',
      password: '',
      role: '',
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      token: null,
    );
  }

  LoginState copyWith({
    String? email,
    String? password,
    String? role,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    String? token,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      token: token ?? this.token,
    );
  }

  @override
  List<Object?> get props =>
      [email, password, role, isSubmitting, isSuccess, isFailure, token];
}
