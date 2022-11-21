import 'dart:async';

import 'package:appp_sale_29092022/common/bases/base_event.dart';
import 'package:appp_sale_29092022/data/datasources/remote/dto/app_resource.dart';
import 'package:appp_sale_29092022/data/datasources/remote/dto/cart_dto.dart';
import 'package:appp_sale_29092022/data/datasources/remote/dto/product_dto.dart';
import 'package:appp_sale_29092022/data/models/cart.dart';
import 'package:appp_sale_29092022/views/cart/cart-event.dart';

import '../../common/bases/base_bloc.dart';
import '../../data/models/product.dart';
import '../../data/respositories/cart_respository.dart';

class CartBloc extends BaseBloc {
  late CartRespository _cartRespository;
  StreamController<CartModel> _streamController = StreamController();

  Stream<CartModel> get streamController => _streamController.stream;

  void updateRepository(CartRespository cartRespository) {
    _cartRespository = cartRespository;
  }

  @override
  void dispatch(BaseEvent event) {
    switch (event.runtimeType) {
      case CartEvent:
        handleLoadCart(event as CartEvent);
        break;
      case UpdateCartEvent:
        handleUpdateCartEvent(event as UpdateCartEvent);
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
    loadingSink.add(true);
    try {
      AppResource<CartDTO> response = await _cartRespository.getCart(event.token);
      if (response.data == null) {
        throw "data null";
      }
      CartDTO cartDTO = response.data!;
      List<dynamic> productResponse = cartDTO.products!;
      List<ProductDTO> productsDTO = ProductDTO.parser(productResponse);

      List<ProductModel> listProducts = [];
      for(int i = 0 ; i < productsDTO.length; i++){
        ProductModel productModel =  ProductModel(productsDTO[i].sId, productsDTO[i].name, productsDTO[i].address, productsDTO[i].price, productsDTO[i].img, productsDTO[i].quantity, productsDTO[i].gallery);
        listProducts.add(productModel);
      }
      CartModel cartModel = CartModel(cartDTO.id,listProducts, cartDTO.idUser, cartDTO.price, cartDTO.dateCreated);
      loadingSink.add(false);
      _streamController.sink.add(cartModel);
    } catch (e) {
      print(e.toString());
     // loadingSink.add(false);
    }
  }

  void handleUpdateCartEvent(UpdateCartEvent event) async{
    loadingSink.add(true);
    try{
      AppResource<CartDTO> resource=  await _cartRespository.updateCart(event.idCart, event.idProduct, event.quantity);
      if (resource.data == null) {
        throw "data null";
      }
      CartDTO cartDTO = resource.data!;
      List<dynamic> productResponse = cartDTO.products!;
      List<ProductDTO> productsDTO = ProductDTO.parser(productResponse);

      List<ProductModel> listProducts = [];
      for(int i = 0 ; i < productsDTO.length; i++){
        ProductModel productModel =  ProductModel(productsDTO[i].sId, productsDTO[i].name, productsDTO[i].address, productsDTO[i].price, productsDTO[i].img, productsDTO[i].quantity, productsDTO[i].gallery);
        listProducts.add(productModel);
      }
      CartModel cartModel = CartModel(cartDTO.id,listProducts, cartDTO.idUser, cartDTO.price, cartDTO.dateCreated);
      loadingSink.add(false);
      _streamController.sink.add(cartModel);
    }catch(e){
      print(e.toString());
    }
  }
}
