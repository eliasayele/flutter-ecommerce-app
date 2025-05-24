abstract class AuthRepository {
  Future<String> login(String username, String password);
  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<String?> getToken();
  Future<String?> getUsername();
  Future<void> saveUsername(String username);
}
