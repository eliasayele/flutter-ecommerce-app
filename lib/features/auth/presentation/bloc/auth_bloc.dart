import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/login_usecase.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final AuthRepository _authRepository;

  AuthBloc(this._loginUseCase, this._authRepository) : super(AuthInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<LogoutButtonPressed>(_onLogoutButtonPressed);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final token = await _loginUseCase.call(event.username, event.password);
      emit(AuthSuccess(token: token, username: event.username));
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onLogoutButtonPressed(
    LogoutButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authRepository.logout();
      emit(AuthLoggedOut());
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final isLoggedIn = await _authRepository.isLoggedIn();
      if (isLoggedIn) {
        final token = await _authRepository.getToken();
        final username = await _authRepository.getUsername();
        if (token != null && username != null) {
          emit(AuthSuccess(token: token, username: username));
        } else {
          emit(AuthLoggedOut());
        }
      } else {
        emit(AuthLoggedOut());
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }
}
