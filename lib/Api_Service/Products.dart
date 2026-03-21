  import 'dart:convert';
  import 'package:product_hub/Model/products_model.dart';
  import 'package:http/http.dart' as http;

  class Api_Service {

    final url = "https://fakestoreapi.com/products";

    Future<List<ProductModel>> getProducts() async {
      try {
        var response = await http.get(Uri.parse(url));

        print("STATUS CODE: ${response.statusCode}");

        if (response.statusCode == 200) {
          List data = jsonDecode(response.body);

          List<ProductModel> products =
          data.map((e)=>ProductModel.fromJson(e)).toList();

          return products;
        } else {
          print("ERROR: ${response.statusCode}");
          return [];
        }
      } catch (e) {
        print("EXCEPTION: $e");
        return [];
      }
    }
  }