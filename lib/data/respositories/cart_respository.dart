import 'dart:async';

import 'package:appp_sale_29092022/data/datasources/remote/api_request.dart';
import 'package:appp_sale_29092022/data/datasources/remote/dto/cart_dto.dart';
import 'package:dio/dio.dart';

import '../datasources/remote/dto/app_resource.dart';

class CartRespository{
  late ApiRequest _apiRequest;
  void updateApiRequest(ApiRequest apiRequest){
    _apiRequest = apiRequest;
  }

  Future<AppResource<CartDTO>> getCart(String token) async{
    Completer<AppResource<CartDTO>> completer = Completer();
    try{
      Response<dynamic> response = await _apiRequest.getCart(token);
      AppResource<CartDTO> resource = AppResource.fromJson(response.data, CartDTO.parser);
      completer.complete(resource);
    }catch(e){
      print(e.toString());
      completer.completeError(e.toString());
    }
    return completer.future;
  }
}