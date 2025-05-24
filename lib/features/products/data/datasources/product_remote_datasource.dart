import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/dio_client.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({int? limit});
  Future<ProductModel> getProductById(int productId);
  Future<List<String>> getCategories();
  Future<List<ProductModel>> getProductsByCategory(String category);
}

@LazySingleton(as: ProductRemoteDataSource)
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final DioClient _dioClient;

  const ProductRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<ProductModel>> getProducts({int? limit}) async {
    try {
      final queryParams = limit != null ? {'limit': limit} : null;
      final response = await _dioClient.get(
        '/products',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to fetch products');
      }
    } on DioException catch (e) {
      throw ServerException('Failed to fetch products: ${e.message}');
    } catch (e) {
      throw ServerException('Failed to fetch products: ${e.toString()}');
    }
  }

  @override
  Future<ProductModel> getProductById(int productId) async {
    try {
      final response = await _dioClient.get('/products/$productId');

      if (response.statusCode == 200) {
        return ProductModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to fetch product details');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ServerException('Product not found');
      }
      throw ServerException('Failed to fetch product details: ${e.message}');
    } catch (e) {
      throw ServerException('Failed to fetch product details: ${e.toString()}');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      final response = await _dioClient.get('/products/categories');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((category) => category.toString()).toList();
      } else {
        throw ServerException('Failed to fetch categories');
      }
    } on DioException catch (e) {
      throw ServerException('Failed to fetch categories: ${e.message}');
    } catch (e) {
      throw ServerException('Failed to fetch categories: ${e.toString()}');
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final response = await _dioClient.get('/products/category/$category');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to fetch products by category');
      }
    } on DioException catch (e) {
      throw ServerException(
        'Failed to fetch products by category: ${e.message}',
      );
    } catch (e) {
      throw ServerException(
        'Failed to fetch products by category: ${e.toString()}',
      );
    }
  }
}
