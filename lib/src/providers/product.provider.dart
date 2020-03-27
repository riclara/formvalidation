import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:formvalidation/src/preferences/UserPreferences.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:formvalidation/src/models/product.model.dart';
import 'package:mime_type/mime_type.dart';

class ProductProvider {
  final String _url = 'https://flutter-devel.firebaseio.com/';
  final _prefs = UserPreferences();
 
  Future createProduct (ProductModel product) async {
    final url = '$_url/products.json?auth=${_prefs.token}';
    final resp = await http.post(url, body: productModelToJson(product));
    final decodeData = json.decode(resp.body);
    return decodeData;
  }

  Future<bool> updateProduct (ProductModel product) async {
    final url = '$_url/products/${product.id}.json?auth=${_prefs.token}';
    final resp = await http.put(url, body: productModelToJson(product));
    final decodeData = json.decode(resp.body);
    print(decodeData);
    return true;
  }

  Future<List<ProductModel>> getProducts(BuildContext context) async {
    final url = '$_url/products.json?auth=${_prefs.token}';
    final resp = await http.get(url);
    final Map<String, dynamic> decodeData = json.decode(resp.body);
    final List<ProductModel> products = List();
    if (decodeData != null && decodeData['error'] != null){
      Navigator.of(context).pushReplacementNamed('login');
      return [];
    }
    if (decodeData == null) return [];
    decodeData.forEach((id, prod) {
      final prodTmp = ProductModel.fromJson(prod);
      prodTmp.id = id;
      products.add(prodTmp);
    });
    return products;
  }

  Future<int> deleteProduct(id) async {
    final url = '$_url/products/$id.json?auth=${_prefs.token}';
    final resp = await http.delete(url);
    return resp.body == null ? 1 : 0;
  }

  Future<String> uploadFile(File image) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/riclara/image/upload');
    final mimeType = mime(image.path).split('/');
    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url
    );
    final file = await http.MultipartFile.fromPath(
      'file',
      image.path,
      contentType: MediaType(mimeType[0], mimeType[1]),
    );
    imageUploadRequest.files.add(file);
    imageUploadRequest.fields['upload_preset'] = 'ml_default';

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);
    print(resp.statusCode);
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      return null;
    }

    final respData = json.decode(resp.body);
    return respData['secure_url'];
  }
  
}