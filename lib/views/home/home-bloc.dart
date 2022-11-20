import 'dart:async';

import 'package:appp_sale_29092022/common/bases/base_event.dart';
import 'package:appp_sale_29092022/data/datasources/remote/dto/app_resource.dart';
import 'package:appp_sale_29092022/data/datasources/remote/dto/product_dto.dart';
import 'package:appp_sale_29092022/data/respositories/product_respository.dart';
import 'package:appp_sale_29092022/views/home/home-event.dart';

import '../../common/bases/base_bloc.dart';
import '../../data/models/product.dart';

class HomeBloc extends BaseBloc {
  late ProductRespository _productRespository;
  StreamController<List<ProductModel>> _streamController = StreamController();
  Stream<List<ProductModel>> get ListProduct => _streamController.stream;

  void updateRespository(ProductRespository productRespository) {
    _productRespository = productRespository;
  }

  @override
  void dispatch(BaseEvent event) {
    // TODO: implement dispatch
    switch (event.runtimeType) {
      case LoadListProducts:
        print("HomeBloc :dispatch");
        handleLoadListProduct(event as LoadListProducts);
        break;
    }
  }

  void handleLoadListProduct(LoadListProducts event) async{
    loadingSink.add(true);
    try{
      AppResource<List<ProductDTO>> resourceDTO = await _productRespository.getProducts();
      List<ProductDTO> listProductDTO = resourceDTO.data! ;
      List<ProductModel> listProducts = [];
      for(int i = 0 ; i < listProductDTO.length; i++){
        ProductModel productModel = ProductModel(listProductDTO[i].sId, listProductDTO[i].name, listProductDTO[i].address, listProductDTO[i].price, listProductDTO[i].img, listProductDTO[i].quantity, listProductDTO[i].gallery);
        listProducts.add(productModel);
      }
      loadingSink.add(false);
      _streamController.sink.add(listProducts);
    }catch(e){
      loadingSink.add(false);
      print(e.toString());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _streamController.close();
  }
}
