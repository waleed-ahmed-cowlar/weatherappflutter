part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthloadingState extends AuthState {

}

class AuthSuccessState extends AuthState {}
class AuthLoginfailedState extends AuthState {}

class AuthErrorState extends AuthState {
  final String message;
  AuthErrorState({required this.message});
}
