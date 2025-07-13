import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';
import 'package:edutrack/data/auth_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(LoginState.initial()) {
    on<LoginEmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email, token: null));
    });

    on<LoginPasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password, token: null));
    });

    on<LoginSubmitted>((event, emit) async {
      emit(state.copyWith(
        isSubmitting: true,
        isFailure: false,
        isSuccess: false,
        token: null,
        role: event.role,
      ));

      try {
        final response = await authRepository.login(
          email: state.email,
          password: state.password,
          role: event.role, 
        );

        emit(state.copyWith(
          isSubmitting: false,
          isSuccess: true,
          token: response['token'],
          email: response['user']['email'],
          role: response['user']['role'],
        ));
      } catch (e) {
        emit(state.copyWith(
          isSubmitting: false,
          isFailure: true,
          token: null,
        ));
      }
    });
  }
}
