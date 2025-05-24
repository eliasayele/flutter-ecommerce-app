import '../../../products/data/models/product_model.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> getProducts({int? limit});
  Future<ProductModel> getProductById(int productId);
  Future<List<String>> getCategories();
  Future<List<ProductModel>> getProductsByCategory(String category);
}
