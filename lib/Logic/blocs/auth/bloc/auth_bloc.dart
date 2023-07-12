import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weatherapp/data/repos/auth_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthRepo authRepo = AuthRepo();
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) {});
    // on((event, emit) {});
    on<AuthLoginButtonEvent>((event, emit) async {
      try {
        print('Login Button Pressed');
        emit(AuthloadingState());
        bool sucessfulLogin = await authRepo.login(event.email, event.password);
        if (sucessfulLogin) {
          emit(AuthSuccessState());
        } else {
          emit(AuthLoginfailedState());
        }
      } catch (e) {
        emit(AuthErrorState(message: e.toString()));
      }
    });
  }
}
