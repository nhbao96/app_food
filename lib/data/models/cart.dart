import 'package:appp_sale_29092022/data/models/product.dart';

import '../datasources/remote/dto/product_dto.dart';

class CartModel {
  String? _sId;
  List<ProductModel>? _products;
  String? _idUser;
  int? _price;
  String? _dateCreated;


  CartModel(
      this._sId, this._products, this._idUser, this._price, this._dateCreated);

  String get dateCreated => _dateCreated ?? "";

  int get price => _price ?? 0;

  String get idUser => _idUser ?? "";

  List<ProductModel> get products => _products ?? [];

  String get sId => _sId ?? "";

  @override
  String toString() {
    return 'CartModel{_sId: $_sId, _products-length: ${_products?.length}, _idUser: $_idUser, _price: $_price, _dateCreated: $_dateCreated}';
  }

  void setProduct(List<ProductDTO> listProductDTO){
    print("cartModel length = ${listProductDTO.length} ** products lenght = ${_products?.length}");

    for(int i = 0 ; i < listProductDTO.length; i++){
      print("-----setProduct");
      ProductModel productModel = ProductModel(listProductDTO[i].sId, listProductDTO[i].name, listProductDTO[i].address, listProductDTO[i].price, listProductDTO[i].img, listProductDTO[i].quantity, listProductDTO[i].gallery);
      _products?.add(productModel);
    }

    print("cartModel length = ${listProductDTO.length} ** products lenght = ${_products?.length}");
  }

  set setProductsModel(List<ProductModel> value) {
    _products = value;
  }
}
