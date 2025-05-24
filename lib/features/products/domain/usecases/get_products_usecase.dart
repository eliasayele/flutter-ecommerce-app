import 'package:injectable/injectable.dart';

import '../../../products/data/models/product_model.dart';
import '../repositories/product_repository.dart';

@injectable
class GetProductsUseCase {
  final ProductRepository _productRepository;

  const GetProductsUseCase(this._productRepository);

  Future<List<ProductModel>> call({int? limit}) async {
    try {
      return await _productRepository.getProducts(limit: limit);
    } catch (e) {
      throw Exception('Failed to fetch products: ${e.toString()}');
    }
  }
}
