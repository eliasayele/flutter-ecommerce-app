import 'package:injectable/injectable.dart';

import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

@LazySingleton(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _productRemoteDataSource;

  const ProductRepositoryImpl(this._productRemoteDataSource);

  @override
  Future<List<ProductModel>> getProducts({int? limit}) async {
    try {
      return await _productRemoteDataSource.getProducts(limit: limit);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProductModel> getProductById(int productId) async {
    try {
      return await _productRemoteDataSource.getProductById(productId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      return await _productRemoteDataSource.getCategories();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      return await _productRemoteDataSource.getProductsByCategory(category);
    } catch (e) {
      rethrow;
    }
  }
}
