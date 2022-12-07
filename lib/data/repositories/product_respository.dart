import 'dart:async';
import 'package:dio/dio.dart';

import '../datasources/remote/api_request.dart';
import '../datasources/remote/dto/app_resource.dart';
import '../datasources/remote/dto/product_dto.dart';

class ProductRespository{
  late ApiRequest _apiRequest;

  void updateApiRequest(ApiRequest apiRequest){
    _apiRequest = apiRequest;
  }

  Future<AppResource<List<ProductDTO>>> getProducts() async{
    Completer<AppResource<List<ProductDTO>>> completer = Completer();
    try{
      Response<dynamic> response = await _apiRequest.getProducts();
      AppResource<List<ProductDTO>> resourceDTO = AppResource.fromJson(response.data, ProductDTO.parserListProducts);
      completer.complete(resourceDTO);
    }catch(e){
      completer.completeError(e);
    }
    return completer.future;
  }
}