import 'dart:async';

import 'package:appp_sale_29092022/common/bases/base_bloc.dart';
import 'package:appp_sale_29092022/common/bases/base_event.dart';
import 'package:appp_sale_29092022/data/datasources/remote/dto/app_resource.dart';
import 'package:appp_sale_29092022/data/datasources/remote/dto/cart_dto.dart';
import 'package:appp_sale_29092022/data/datasources/remote/dto/product_dto.dart';
import 'package:appp_sale_29092022/data/model/Product.dart';
import 'package:appp_sale_29092022/data/repositories/order_repository.dart';
import 'package:appp_sale_29092022/presentation/features/orders/order_event.dart';

import '../../../data/model/Cart.dart';

class OrderBloc extends BaseBloc {
  StreamController<List<Cart>> _streamController = StreamController.broadcast();
  late OrderRespository _orderRespository;

  StreamController<List<Cart>> get streamController => _streamController;

  void updateOrderRespository(OrderRespository orderRespository) {
    _orderRespository = orderRespository;
  }

  @override
  void dispatch(BaseEvent event) {
    // TODO: implement dispatch
    switch (event.runtimeType) {
      case ShowOrderHistoryEvent:
        handleShowOrderHistoryEvent(event as ShowOrderHistoryEvent);
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

  void handleShowOrderHistoryEvent(ShowOrderHistoryEvent event) async {
    loadingSink.add(true);
    try {
      AppResource<List<CartDTO>> resourceDTO = await _orderRespository.orderHistory();
      if (resourceDTO.data == null) {
        throw "order data null";
      }
      List<CartDTO> listcartDTO = resourceDTO.data!;
      print("listcartDTO length = ${listcartDTO.length}");
      List<Cart> listCart = [];
      listcartDTO.forEach((element) {
        List<dynamic> productResource = element.products!;
        List<ProductDTO> listProductDTO = ProductDTO.parserListProducts(productResource);
        List<Product> listProduct = [];
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
        print("order bloc : dateCreated = ${ element.dateCreated}");
        listCart.add(Cart(element.id, listProduct, element.idUser, element.price, element.dateCreated));

      });
      listCart.forEach((element) {print("element ${element.toString()}");});
      _streamController.sink.add(listCart);
    } catch (e) {
      print(e.toString());
    }
    loadingSink.add(false);
  }
}
