import 'dart:async';

import 'package:appp_sale_29092022/data/datasources/remote/api_request.dart';
import 'package:appp_sale_29092022/data/datasources/remote/dto/product_dto.dart';
import 'package:dio/dio.dart';

import '../datasources/remote/dto/app_resource.dart';

class ProductRespository{
  late ApiRequest _apiRequest;

  void updateApiRequest(ApiRequest apiRequest){
    _apiRequest = apiRequest;
  }

  Future<AppResource<List<ProductDTO>>> getProducts() async {
    Completer<AppResource<List<ProductDTO>>> completer = Completer();
    try{
      Response<dynamic> response = await _apiRequest.getProductRequest();
      AppResource<List<ProductDTO>> resource = AppResource.fromJson(response.data, ProductDTO.parser);
      completer.complete(resource);
    }catch(e){
      completer.completeError(e.toString());
    }
    return completer.future;
  }
}