  import 'dart:convert';
  import 'package:product_hub/Model/products_model.dart';
  import 'package:http/http.dart' as http;

  class Api_Service {

    final url = "https://dummyjson.com/products?limit=2000";
      Future<List<ProductModel>>getproduct()async{
        try{
          final respose=await http.get(Uri.parse(url));
          if(respose.statusCode==200){
            final decode=jsonDecode(respose.body);
            List data=decode['products'];

            List<ProductModel> products=data.map((e)=>ProductModel.fromJson(e)).toList();
            return products;

          }
          else{
              throw Exception("Failed to load data");
          }

        }
        catch(e){
          print(e);
          return [];
        }
      }
      
  }