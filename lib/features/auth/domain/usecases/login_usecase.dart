import 'package:injectable/injectable.dart';

import '../repositories/auth_repository.dart';

@injectable
class LoginUseCase {
  final AuthRepository _authRepository;

  const LoginUseCase(this._authRepository);

  Future<String> call(String username, String password) async {
    if (username.isEmpty) {
      throw Exception('Username cannot be empty');
    }

    if (password.isEmpty) {
      throw Exception('Password cannot be empty');
    }

    return await _authRepository.login(username, password);
  }
}
