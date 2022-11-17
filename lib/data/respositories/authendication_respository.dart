import 'dart:async';

import 'package:appp_sale_29092022/data/datasources/remote/api_request.dart';
import 'package:appp_sale_29092022/data/datasources/remote/dto/app_resource.dart';
import 'package:appp_sale_29092022/data/datasources/remote/dto/user_dto.dart';
import 'package:dio/dio.dart';

class AuthendicationRespository {
  late ApiRequest _apiRequest;

  void updateApiRequest(ApiRequest apiRequest) {
    _apiRequest = apiRequest;
  }

  Future<AppResource<UserDto>> signIn(String email, String password) async {
    Completer<AppResource<UserDto>> completer = Completer();
    try {
      Response<dynamic> response = await _apiRequest.signInRequest(email, password);
      AppResource<UserDto> resource = AppResource.fromJson(response.data, UserDto.fromJson);
      completer.complete(resource);
    } on DioError catch (dioError) {
      completer.completeError(dioError.response?.data["message"]);
    } catch (e) {
      completer.completeError(e.toString());
    }

    return completer.future;
  }

  Future<AppResource<UserDto>> signUp(String email, String password, String name, String phone, String address) async{
    Completer<AppResource<UserDto>> completer = Completer();
    try{
      Response<dynamic> response = await _apiRequest.signUpRequest(email, password, name, phone, address);
      AppResource<UserDto> resource = AppResource.fromJson(response.data, UserDto.parser);
      completer.complete(resource);
    }catch(e){
      completer.completeError(e.toString());
    }
    return completer.future;
  }
}
