import 'package:appp_sale_29092022/data/models/product.dart';

import '../datasources/remote/dto/product_dto.dart';

class CartModel {
  String? _sId;
  List<ProductModel>? _products;
  String? _idUser;
  int? _price;
  String? _dateCreated;

  CartModel(
      this._sId, this._idUser, this._price, this._dateCreated);

  String get dateCreated => _dateCreated ?? "";

  int get price => _price ?? 0;

  String get idUser => _idUser ?? "";

  List<ProductModel> get products => _products ?? [];

  String get sId => _sId ?? "";

  void setProduct(List<ProductDTO> listProductDTO){
    products.clear();
    for(int i = 0 ; i < listProductDTO.length; i++){
      ProductModel productModel = ProductModel(listProductDTO[i].sId, listProductDTO[i].name, listProductDTO[i].address, listProductDTO[i].price, listProductDTO[i].img, listProductDTO[i].quantity, listProductDTO[i].gallery);
      products.add(productModel);
    }
  }
}
