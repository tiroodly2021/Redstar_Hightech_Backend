import 'package:get/get.dart';

import '../models/product_model.dart';

class ProductProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Product.fromMap(map);
      if (map is List) return map.map((item) => Product.fromMap(item)).toList();
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<Product?> getProduct(int id) async {
    final response = await get('product/$id');
    return response.body;
  }

  Future<Response<Product>> postProduct(Product product) async =>
      await post('product', product);
  Future<Response> deleteProduct(int id) async => await delete('product/$id');
}
