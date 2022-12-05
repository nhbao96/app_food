import 'dart:async';

import 'package:appp_sale_29092022/data/datasources/remote/api_request.dart';
import 'package:appp_sale_29092022/data/datasources/remote/dto/app_resource.dart';
import 'package:appp_sale_29092022/data/datasources/remote/dto/cart_dto.dart';
import 'package:dio/dio.dart';

class CartRespository{
  late ApiRequest _apiRequest;

  void updateApiRequest(ApiRequest apiRequest){
    _apiRequest = apiRequest;
  }

  Future<AppResource<CartDTO>> getCart() async{
    Completer<AppResource<CartDTO>> completer = Completer();
    try{
      Response<dynamic> response = await _apiRequest.getCart();
      AppResource<CartDTO> resourceDTO = AppResource.fromJson(response.data, CartDTO.parser);
      completer.complete(resourceDTO);
    }catch(e){
      completer.completeError(e);
    }
    return completer.future;
  }


  Future<AppResource<CartDTO>> updateCart(String idProduct, int quantity) async{
    Completer<AppResource<CartDTO>> completer = Completer();
    try{
      Response<dynamic> response = await _apiRequest.updateCart(idProduct,quantity);
      AppResource<CartDTO> resourceDTO = AppResource.fromJson(response.data, CartDTO.parser);
      completer.complete(resourceDTO);
    }catch(e){
      completer.completeError(e);
    }
    return completer.future;
  }

  Future<AppResource<CartDTO>> addToCart(String idProduct) async{
    Completer<AppResource<CartDTO>> completer = Completer();
    try{
      Response<dynamic> response = await _apiRequest.addToCart(idProduct);
      AppResource<CartDTO> resourceDTO = AppResource.fromJson(response.data, CartDTO.parser);
      completer.complete(resourceDTO);
    }catch(e){
      completer.completeError(e);
    }
    return completer.future;
  }

  Future<String> confirmCart() async{
    Completer<String> completer  = Completer();
    try{
     Response<dynamic> response = await _apiRequest.confirmCart();
     String resourceDTO = response.data["data"];
     completer.complete(resourceDTO);
    }catch(e){
      completer.completeError(e.toString());
    }
    return completer.future;
  }
}