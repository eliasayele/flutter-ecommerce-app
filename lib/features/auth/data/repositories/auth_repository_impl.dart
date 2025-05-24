import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  final SharedPreferences _sharedPreferences;

  static const String _tokenKey = 'auth_token';
  static const String _usernameKey = 'auth_username';

  const AuthRepositoryImpl(this._authRemoteDataSource, this._sharedPreferences);

  @override
  Future<String> login(String username, String password) async {
    try {
      final token = await _authRemoteDataSource.login(username, password);

      // Save token and username to local storage
      await _sharedPreferences.setString(_tokenKey, token);
      await _sharedPreferences.setString(_usernameKey, username);

      return token;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await _sharedPreferences.remove(_tokenKey);
    await _sharedPreferences.remove(_usernameKey);
    // Clear cart and wishlist data on logout
    await _sharedPreferences.remove('cart_items');
    await _sharedPreferences.remove('wishlist_items');
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = _sharedPreferences.getString(_tokenKey);
    return token != null && token.isNotEmpty;
  }

  @override
  Future<String?> getToken() async {
    return _sharedPreferences.getString(_tokenKey);
  }

  @override
  Future<String?> getUsername() async {
    return _sharedPreferences.getString(_usernameKey);
  }

  @override
  Future<void> saveUsername(String username) async {
    await _sharedPreferences.setString(_usernameKey, username);
  }
}
