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
  StreamController<CartModel> _streamController = StreamController.broadcast();

  Stream<CartModel> get streamController => _streamController.stream;
  late CartModel _model;
  late String _token;

  CartModel get model => _model;

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
      case IncreaseItemCartEvent:
        handleIncreaseItemCartEvent(event as IncreaseItemCartEvent);
        break;
      case DecreaseItemCartEvent:
        handleDecreaseItemCartEvent(event as DecreaseItemCartEvent);
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
      _token = event.token;
      AppResource<CartDTO> response = await _cartRespository.getCart(_token);
      if (response.data == null) {
        throw "data null";
      }
      CartDTO cartDTO = response.data!;
      List<dynamic> productResponse = cartDTO.products!;
      List<ProductDTO> productsDTO = ProductDTO.parser(productResponse);

      List<ProductModel> listProducts = [];
      for (int i = 0; i < productsDTO.length; i++) {
        ProductModel productModel = ProductModel(
            productsDTO[i].sId,
            productsDTO[i].name,
            productsDTO[i].address,
            productsDTO[i].price,
            productsDTO[i].img,
            productsDTO[i].quantity,
            productsDTO[i].gallery);
        listProducts.add(productModel);
      }
      _model = CartModel(cartDTO.id, listProducts, cartDTO.idUser,
          cartDTO.price, cartDTO.dateCreated);
      loadingSink.add(false);
      _streamController.sink.add(_model);
      progressSink.add(GetCartSuccess(cartDTO.id.toString(),_model.price));
    } catch (e) {
      print(e.toString());
      // loadingSink.add(false);
    }
  }

  void handleUpdateCartEvent(UpdateCartEvent event) async {
    loadingSink.add(true);
    try {
      AppResource<CartDTO> resource = await _cartRespository.updateCart(event.token,
          event.idCart, event.idProduct, event.quantity);
      if (resource.data == null) {
        throw "data null";
      }
      CartDTO cartDTO = resource.data!;
      List<dynamic> productResponse = cartDTO.products!;
      List<ProductDTO> productsDTO = ProductDTO.parser(productResponse);

      List<ProductModel> listProducts = [];
      for (int i = 0; i < productsDTO.length; i++) {
        ProductModel productModel = ProductModel(
            productsDTO[i].sId,
            productsDTO[i].name,
            productsDTO[i].address,
            productsDTO[i].price,
            productsDTO[i].img,
            productsDTO[i].quantity,
            productsDTO[i].gallery);
        listProducts.add(productModel);
      }
      _model = CartModel(cartDTO.id, listProducts, cartDTO.idUser,
          cartDTO.price, cartDTO.dateCreated);
      loadingSink.add(false);
      _streamController.sink.add(_model);
    } catch (e) {
      print(e.toString());
    }
  }

  void handleIncreaseItemCartEvent(IncreaseItemCartEvent event) async {
    loadingSink.add(true);
    try {
      int quantity = getProductQuantity(event.idProduct);
      AppResource<CartDTO> resource;
      if(quantity == 0){
        resource = await _cartRespository.addToCart(event.token,event.idProduct);
      }else{
        quantity += event.value;
        resource = await _cartRespository.updateCart(event.token,
            _model.sId, event.idProduct, quantity);
      }

      if (resource.data == null) {
        throw "data null";
      }
      CartDTO cartDTO = resource.data!;
      List<dynamic> productResponse = cartDTO.products!;
      List<ProductDTO> productsDTO = ProductDTO.parser(productResponse);

      List<ProductModel> listProducts = [];
      for (int i = 0; i < productsDTO.length; i++) {
        ProductModel productModel = ProductModel(
            productsDTO[i].sId,
            productsDTO[i].name,
            productsDTO[i].address,
            productsDTO[i].price,
            productsDTO[i].img,
            productsDTO[i].quantity,
            productsDTO[i].gallery);
        listProducts.add(productModel);
      }
      _model = CartModel(cartDTO.id, listProducts, cartDTO.idUser,
          cartDTO.price, cartDTO.dateCreated);
      loadingSink.add(false);
      _streamController.sink.add(_model);
    } catch (e) {
      print(e.toString());
      loadingSink.add(false);
    }
  }

  void handleDecreaseItemCartEvent(DecreaseItemCartEvent event) async {
    loadingSink.add(true);
    try {
      int quantity = getProductQuantity(event.idProduct) - event.value;
      if(quantity <0){
        throw "quantity cannot < 0";
      }
      AppResource<CartDTO> resource = await _cartRespository.updateCart(event.token,
          _model.sId, event.idProduct, quantity);
      if (resource.data == null) {
        throw "data null";
      }
      CartDTO cartDTO = resource.data!;
      List<dynamic> productResponse = cartDTO.products!;
      List<ProductDTO> productsDTO = ProductDTO.parser(productResponse);

      List<ProductModel> listProducts = [];
      for (int i = 0; i < productsDTO.length; i++) {
        ProductModel productModel = ProductModel(
            productsDTO[i].sId,
            productsDTO[i].name,
            productsDTO[i].address,
            productsDTO[i].price,
            productsDTO[i].img,
            productsDTO[i].quantity,
            productsDTO[i].gallery);
        listProducts.add(productModel);
      }
      _model = CartModel(cartDTO.id, listProducts, cartDTO.idUser,
          cartDTO.price, cartDTO.dateCreated);
      loadingSink.add(false);
      _streamController.sink.add(_model);
    } catch (e) {
      print(e.toString());
      loadingSink.add(false);
    }
  }

  String get token => _token;

  int getProductQuantity(String idProduct) {
    int result = 0;
    for (int i = 0; i < _model.products.length; i++) {
      if (_model.products[i].id == idProduct) {
        result = _model.products[i].quatity;
      }
    }
    return result;
  }
}
