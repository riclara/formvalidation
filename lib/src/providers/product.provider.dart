import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:formvalidation/src/models/product.model.dart';

class ProductProvider {
  final String _url = 'https://flutter-devel.firebaseio.com/';

  Future<bool> createProduct (ProductModel product) async {
    final url = '$_url/products.json';
    final resp = await http.post(url, body: productModelToJson(product));
    final decodeData = json.decode(resp.body);
    print(decodeData);
    return true;
  }

  Future<bool> updateProduct (ProductModel product) async {
    final url = '$_url/products/${product.id}.json';
    final resp = await http.put(url, body: productModelToJson(product));
    final decodeData = json.decode(resp.body);
    return true;
  }

  Future<List<ProductModel>> getProducts() async {
    final url = '$_url/products.json';
    final resp = await http.get(url);
    final Map<String, dynamic> decodeData = json.decode(resp.body);
    final List<ProductModel> products = List();
    decodeData.forEach((id, prod) {
      final prodTmp = ProductModel.fromJson(prod);
      prodTmp.id = id;
      products.add(prodTmp);
    });
    if (decodeData == null) return [];
    return products;
  }

  Future<int> deleteProduct(id) async {
    final url = '$_url/products/$id.json';
    final resp = await http.delete(url);
    print(resp);
    return 1;
  }
  
}