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
      var res = await _apiRequest.signInRequest(email, password);
     print(res);
    } on DioError catch (dioError) {
      print(dioError.response?.data["message"]);
    } catch (e) {
      print(e.toString());
    }

    return completer.future;
  }
}
