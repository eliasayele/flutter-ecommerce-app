import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://fakestoreapi.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
        error: true,
      ),
      _ErrorInterceptor(),
    ]);
  }

  // GET method
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // POST method
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // PUT method
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // DELETE method
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle different types of errors
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw TimeoutException(err.requestOptions);
      case DioExceptionType.badResponse:
        switch (err.response?.statusCode) {
          case 400:
            throw BadRequestException(err.requestOptions);
          case 401:
            throw UnauthorizedException(err.requestOptions);
          case 403:
            throw ForbiddenException(err.requestOptions);
          case 404:
            throw NotFoundException(err.requestOptions);
          case 500:
            throw InternalServerErrorException(err.requestOptions);
          default:
            throw DioException(
              requestOptions: err.requestOptions,
              response: err.response,
              type: err.type,
              error: err.error,
            );
        }
      case DioExceptionType.cancel:
        break;
      case DioExceptionType.unknown:
        throw NoInternetConnectionException(err.requestOptions);
      default:
        throw err;
    }
    return handler.next(err);
  }
}

// Custom exceptions
class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class TimeoutException extends ServerException {
  TimeoutException(RequestOptions requestOptions) : super('Connection timeout');
}

class BadRequestException extends ServerException {
  BadRequestException(RequestOptions requestOptions) : super('Bad request');
}

class UnauthorizedException extends ServerException {
  UnauthorizedException(RequestOptions requestOptions) : super('Unauthorized');
}

class ForbiddenException extends ServerException {
  ForbiddenException(RequestOptions requestOptions) : super('Forbidden');
}

class NotFoundException extends ServerException {
  NotFoundException(RequestOptions requestOptions) : super('Not found');
}

class InternalServerErrorException extends ServerException {
  InternalServerErrorException(RequestOptions requestOptions)
    : super('Internal server error');
}

class NoInternetConnectionException extends ServerException {
  NoInternetConnectionException(RequestOptions requestOptions)
    : super('No internet connection');
}
