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
      token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjI0MzM3NzQ5OTQsImRhdGEiOnsiX2lkIjoiNjJiNzJhZTM1ZTRlNmU2ZTNjNmE4MWQ5IiwiZW1haWwiOiJkZW1vMUBnbWFpbC5jb20iLCJwYXNzd29yZCI6IiQyYiQxMCRlcGdxQXJMbGdrSklWdGc0QWtEcUR1QjB6Z1RKVU9waW1LVURESnJvM09tOWR0MWdiL2MvbSIsIm5hbWUiOiJwaGF0IiwicGhvbmUiOiIxMjM0NTY3ODkxMCIsInVzZXJHcm91cCI6MCwicmVnaXN0ZXJEYXRlIjoiMjAyMi0wNi0yNVQxNTozMzo1NS4wNzBaIiwiX192IjowfSwiaWF0IjoxNjU2MTc0OTk0fQ.bUDANXsWOZv0Z_FGslX-7Mihygwm4txSwack8Xj4tkI';
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