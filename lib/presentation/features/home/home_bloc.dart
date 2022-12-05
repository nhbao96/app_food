import 'dart:async';

import 'package:appp_sale_29092022/common/bases/base_bloc.dart';
import 'package:appp_sale_29092022/common/bases/base_event.dart';
import 'package:appp_sale_29092022/data/datasources/remote/dto/app_resource.dart';
import 'package:appp_sale_29092022/data/datasources/remote/dto/cart_dto.dart';
import 'package:appp_sale_29092022/data/datasources/remote/dto/product_dto.dart';
import 'package:appp_sale_29092022/data/repositories/cart_respository.dart';
import 'package:appp_sale_29092022/data/repositories/product_respository.dart';
import 'package:appp_sale_29092022/presentation/features/cart/cart_event.dart';
import 'package:appp_sale_29092022/presentation/features/home/home_event.dart';

import '../../../data/model/Cart.dart';
import '../../../data/model/Product.dart';

class HomeBloc extends BaseBloc {
  late ProductRespository _productRespository;

  StreamController<List<Product>> _streamController = StreamController();
  StreamController<List<Product>> get productStreamController => _streamController;

  void updateRespository(ProductRespository productRespository) {
    _productRespository = productRespository;
  }

  @override
  void dispatch(BaseEvent event) {
    // TODO: implement dispatch
    switch (event.runtimeType) {
      case LoadHomeEvent:
        handleLoadHomeEvent(event as LoadHomeEvent);
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

  void handleLoadHomeEvent(LoadHomeEvent event) async {
    loadingSink.add(true);
    print("handleLoadHomeEvent");
    try {
      AppResource<List<ProductDTO>> resourceDTO =
          await _productRespository.getProducts();
      if (resourceDTO.data == null) {
        throw "data null";
      }
      List<ProductDTO> listProductDTO = resourceDTO.data!;
      List<Product> listProductModel = [];
      for (int i = 0; i < listProductDTO.length; i++) {
        listProductModel.add(Product(
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
      _streamController.add(listProductModel);
    } catch (e) {
      print(e.toString());
    }
    loadingSink.add(false);
  }
}
