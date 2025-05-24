import 'package:injectable/injectable.dart';

import '../../../products/data/models/product_model.dart';
import '../repositories/product_repository.dart';

@injectable
class GetProductByIdUseCase {
  final ProductRepository _productRepository;

  const GetProductByIdUseCase(this._productRepository);

  Future<ProductModel> call(int productId) async {
    if (productId <= 0) {
      throw Exception('Invalid product ID');
    }

    try {
      return await _productRepository.getProductById(productId);
    } catch (e) {
      throw Exception('Failed to fetch product details: ${e.toString()}');
    }
  }
}
