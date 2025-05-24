import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/dio_client.dart';

abstract class AuthRemoteDataSource {
  Future<String> login(String username, String password);
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  const AuthRemoteDataSourceImpl(this._dioClient);

  @override
  Future<String> login(String username, String password) async {
    try {
      final response = await _dioClient.post(
        '/auth/login',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['token'] != null) {
          return data['token'] as String;
        } else {
          throw ServerException('Invalid response: token not found');
        }
      } else {
        throw ServerException('Login failed');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Invalid credentials');
      }
      rethrow;
    } catch (e) {
      throw ServerException('Login failed: ${e.toString()}');
    }
  }
}
