import 'dart:async';
import '../../../common/bases/base_bloc.dart';
import '../../../common/bases/base_event.dart';
import '../../../data/datasources/remote/dto/app_resource.dart';
import '../../../data/datasources/remote/dto/cart_dto.dart';
import '../../../data/datasources/remote/dto/product_dto.dart';
import '../../../data/model/Cart.dart';
import '../../../data/model/Product.dart';
import '../../../data/repositories/order_repository.dart';
import 'order_event.dart';

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
        listCart.add(Cart(element.id, listProduct, element.idUser, element.price, element.dateCreated));

      });
      _streamController.sink.add(listCart);
    } catch (e) {
      print(e.toString());
    }
    loadingSink.add(false);
  }
}
