part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthLoginButtonEvent extends AuthEvent {
  final String email;
  final String password;
  AuthLoginButtonEvent({required this.email, required this.password});
}

class AuthfieldValidationEvent extends AuthEvent {
  final String email;
  final String password;
  AuthfieldValidationEvent({required this.email, required this.password});
}

class AuthSignupButtonEvent extends AuthEvent {}
