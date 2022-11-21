import 'package:appp_sale_29092022/common/constants/api_constant.dart';
import 'package:appp_sale_29092022/data/datasources/remote/dio_client.dart';
import 'package:dio/dio.dart';

class ApiRequest {
  late Dio _dio;

  ApiRequest() {
    _dio = DioClient.instance.dio;
  }

  Future signInRequest(String email, String password) {
    return _dio.post(ApiConstant.SIGN_IN,
        data: {"email": email, "password": password});
  }

  Future signUpRequest(String email, String password, String name, String phone,
      String address) {
    return _dio.post(ApiConstant.SIGN_UP, data: {
      "email": email,
      "name": name,
      "password": password,
      "phone": phone,
      "address": address
    });
  }

  Future getProductRequest() {
    return _dio.get(ApiConstant.PRODUCT);
  }

  Future getCart(String token) {
    BaseOptions options = _dio.options;
    return _dio.get(
      ApiConstant.CART,
      options: Options(headers: {
        "authorization": "Bearer ${token}",
      }),
    );
  }

  Future updateCart(String idCart, String idProduct, int quantity){
   String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjI0MzM3NzQ5OTQsImRhdGEiOnsiX2lkIjoiNjJiNzJhZTM1ZTRlNmU2ZTNjNmE4MWQ5IiwiZW1haWwiOiJkZW1vMUBnbWFpbC5jb20iLCJwYXNzd29yZCI6IiQyYiQxMCRlcGdxQXJMbGdrSklWdGc0QWtEcUR1QjB6Z1RKVU9waW1LVURESnJvM09tOWR0MWdiL2MvbSIsIm5hbWUiOiJwaGF0IiwicGhvbmUiOiIxMjM0NTY3ODkxMCIsInVzZXJHcm91cCI6MCwicmVnaXN0ZXJEYXRlIjoiMjAyMi0wNi0yNVQxNTozMzo1NS4wNzBaIiwiX192IjowfSwiaWF0IjoxNjU2MTc0OTk0fQ.bUDANXsWOZv0Z_FGslX-7Mihygwm4txSwack8Xj4tkI';
    return _dio.post(ApiConstant.UPDATE_CART,
        options: Options(headers: {
          "authorization": "Bearer ${token}",
        }),
       data: {
      "id_product" : idProduct,
      "id_cart" : idCart,
      "quantity" : quantity
    });
  }
}
