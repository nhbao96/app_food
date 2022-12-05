import 'dart:async';

import 'package:appp_sale_29092022/common/bases/base_bloc.dart';
import 'package:appp_sale_29092022/common/bases/base_event.dart';
import 'package:appp_sale_29092022/common/constants/variable_constant.dart';
import 'package:appp_sale_29092022/common/utils/extension.dart';
import 'package:appp_sale_29092022/data/datasources/local/cache/app_cache.dart';
import '../../../data/datasources/remote/dto/app_resource.dart';
import '../../../data/datasources/remote/dto/cart_dto.dart';
import '../../../data/datasources/remote/dto/product_dto.dart';
import '../../../data/model/Cart.dart';
import '../../../data/model/Product.dart';
import '../../../data/repositories/cart_respository.dart';
import 'cart_event.dart';

class CartBloc extends BaseBloc{
  late CartRespository _cartRespository;
  StreamController<Cart> _streamController = StreamController.broadcast();
  Cart? _cartModel ;

  void updateRepository(CartRespository cartRespository){
    _cartRespository = cartRespository;
  }

  StreamController<Cart> get streamController => _streamController;

  @override
  void dispatch(BaseEvent event) {
    // TODO: implement dispatch
    switch (event.runtimeType) {
      case GetCartEvent:
        handleGetCartEvent(event as GetCartEvent);
        break;
      case IncreaseCartItemEvent:
        handleIncreaseCartItemEvent(event as IncreaseCartItemEvent);
        break;
      case DecreaseCartItemEvent:
        handleDecreaseCartItemEvent(event as DecreaseCartItemEvent);
        break;
      case ConfirmCartEvent:
        handleConfirmCartEvent(event as ConfirmCartEvent);
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

  void handleGetCartEvent(GetCartEvent event) async {
    loadingSink.add(true);
    print("handleGetCartEvent");
    try {
      AppResource<CartDTO> appResourceDTO = await _cartRespository.getCart();
      if (appResourceDTO.data == null) {
        throw "data null";
      }
      CartDTO cartDTO = appResourceDTO.data!;

      List<Product> listProduct = [];
      if (cartDTO.products != null) {
        List<dynamic> listProductResponse = cartDTO.products!;
        List<ProductDTO> listProductDTO = ProductDTO.parserListProducts(listProductResponse);
        for (int i = 0; i < listProductDTO.length; i++) {
          listProduct.add(Product(
              listProductDTO[i].id,
              listProductDTO[i].name,
              listProductDTO[i].address,
              listProductDTO[i].price,
              listProductDTO[i].img,
              listProductDTO[i].quantity,
              listProductDTO[i].gallery,
              listProductDTO[i].dateCreated,
              listProductDTO[i].dateUpdated));
        }
      }
      _cartModel = Cart(cartDTO.id, listProduct, cartDTO.idUser, cartDTO.price, cartDTO.dateCreated);
      AppCache.setString(key: VariableConstant.CART_ID,value: _cartModel!.id.toString());
      _streamController.add(_cartModel!);
    } catch (e) {
      print(e.toString());
    }
    loadingSink.add(false);
  }

  int getQuantityFromIdProduct(String id){
    int quantity = 0;
    if(_cartModel == null) {
      return 0;
    }

    for(int i = 0; i<_cartModel!.products.length;i++){
      if(_cartModel!.products[i].id == id){
        quantity = _cartModel!.products[i].quantity;
      }
    }
    return quantity;
  }

  void handleIncreaseCartItemEvent(IncreaseCartItemEvent event) async{

    loadingSink.add(true);
    try{
      print("handleIncreaseCartItemEvent begin");
      int quantity = getQuantityFromIdProduct(event.idProduct);

      AppResource<CartDTO> resourceDTO;
      if(quantity == 0){
        print("handleIncreaseCartItemEvent 112");
        quantity = event.quantity;
        resourceDTO = await _cartRespository.addToCart(event.idProduct);
      }else{
        quantity += event.quantity;
        resourceDTO = await _cartRespository.updateCart(event.idProduct, quantity);
      }

      if (resourceDTO.data == null) {
        throw "data null";
      }
      CartDTO cartDTO = resourceDTO.data!;

      List<Product> listProduct = [];
      if (cartDTO.products != null) {
        List<dynamic> listProductResponse = cartDTO.products!;
        List<ProductDTO> listProductDTO = ProductDTO.parserListProducts(listProductResponse);
        for (int i = 0; i < listProductDTO.length; i++) {
          listProduct.add(Product(
              listProductDTO[i].id,
              listProductDTO[i].name,
              listProductDTO[i].address,
              listProductDTO[i].price,
              listProductDTO[i].img,
              listProductDTO[i].quantity,
              listProductDTO[i].gallery,
              listProductDTO[i].dateCreated,
              listProductDTO[i].dateUpdated));
        }
      }
      _cartModel = Cart(cartDTO.id, listProduct, cartDTO.idUser, cartDTO.price, cartDTO.dateCreated);
      AppCache.setString(key: VariableConstant.CART_ID,value: cartDTO.id.toString());
      _streamController.add(_cartModel!);
    }catch(e){
      print(e.toString());
    }
    loadingSink.add(false);
  }

  void handleDecreaseCartItemEvent(DecreaseCartItemEvent event) async{
    loadingSink.add(true);
    try{
      int quantity = getQuantityFromIdProduct(event.idProduct);
      quantity -= event.quantity;
      AppResource<CartDTO> resourceDTO = await _cartRespository.updateCart(event.idProduct, quantity);
      if (resourceDTO.data == null) {
        throw "data null";
      }
      CartDTO cartDTO = resourceDTO.data!;

      List<Product> listProduct = [];
      if (cartDTO.products != null) {
        List<dynamic> listProductResponse = cartDTO.products!;
        List<ProductDTO> listProductDTO = ProductDTO.parserListProducts(listProductResponse);
        for (int i = 0; i < listProductDTO.length; i++) {
          listProduct.add(Product(
              listProductDTO[i].id,
              listProductDTO[i].name,
              listProductDTO[i].address,
              listProductDTO[i].price,
              listProductDTO[i].img,
              listProductDTO[i].quantity,
              listProductDTO[i].gallery,
              listProductDTO[i].dateCreated,
              listProductDTO[i].dateUpdated));
        }
      }
      _cartModel = Cart(cartDTO.id, listProduct, cartDTO.idUser, cartDTO.price, cartDTO.dateCreated);
      AppCache.setString(key: VariableConstant.CART_ID,value: cartDTO.id.toString());
      _streamController.add(_cartModel!);
    }catch(e){
      print(e.toString());
    }
    loadingSink.add(false);
  }

  void handleConfirmCartEvent(ConfirmCartEvent event) async{
    loadingSink.add(true);
    try{
      String resource = await _cartRespository.confirmCart();
      progressSink.add(ConfirmCartSuccessEvent(resource));
      _cartModel!.clear();
      _streamController.add(_cartModel!);
    }catch(e){
      progressSink.add(ConfirmCartFailedEvent(e.toString()));
    }
    loadingSink.add(false);
  }

}