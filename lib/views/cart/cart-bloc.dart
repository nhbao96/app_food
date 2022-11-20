import 'dart:async';

import 'package:appp_sale_29092022/common/bases/base_event.dart';
import 'package:appp_sale_29092022/data/datasources/remote/dto/app_resource.dart';
import 'package:appp_sale_29092022/data/datasources/remote/dto/cart_dto.dart';
import 'package:appp_sale_29092022/data/datasources/remote/dto/product_dto.dart';
import 'package:appp_sale_29092022/data/models/cart.dart';
import 'package:appp_sale_29092022/views/cart/cart-event.dart';

import '../../common/bases/base_bloc.dart';
import '../../data/respositories/cart_respository.dart';

class CartBloc extends BaseBloc {
  late CartRespository _cartRespository;
  StreamController<CartModel> _streamController = StreamController();

  void updateRepository(CartRespository cartRespository) {
    _cartRespository = cartRespository;
  }

  @override
  void dispatch(BaseEvent event) {
    switch (event.runtimeType) {
      case CartEvent:
        handleLoadCart(event as CartEvent);
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _streamController.close();
  }

  void handleLoadCart(CartEvent event) async {
    try {
      AppResource<CartDTO> response = await _cartRespository.getCart(event.token);
      if (response.data == null) {
        throw "data null";
      }
      CartDTO cartDTO = response.data!;
      CartModel cartModel = CartModel(cartDTO.id, cartDTO.idUser, cartDTO.price, cartDTO.dateCreated);
      cartModel.setProduct(cartDTO.products??[]);
    } catch (e) {
      print(e.toString());
    }
  }
}
