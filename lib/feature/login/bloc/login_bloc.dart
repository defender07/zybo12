import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';
import '../repository/login_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository repository;

  LoginBloc(this.repository) : super(LoginInitial()) {
    on<VerifyUserEvent>(_onVerifyUser);
  }

  Future<void> _onVerifyUser(
      VerifyUserEvent event,
      Emitter<LoginState> emit,
      ) async {
    emit(LoginLoading());
    try {
      final response = await repository.verifyUser(event.phoneNumber);
      emit(LoginSuccess(response));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
