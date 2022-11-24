import 'package:appp_sale_29092022/common/bases/base_event.dart';

class CartEvent extends BaseEvent{
  String token;
  @override
  // TODO: implement props
  List<Object?> get props => [];

  CartEvent({ required this.token});
}

class GetCartSuccess extends BaseEvent{
  String _idCart;
  int _price;
  String get idCart => _idCart;


  int get price => _price;


  GetCartSuccess(this._idCart, this._price);

  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class UpdateCartEvent extends BaseEvent{
  String _token;
  String _idCart;
  String _idProduct;
  int _quantity;

  UpdateCartEvent(this._token,this._idCart, this._idProduct, this._quantity);

  int get quantity => _quantity;

  String get idCart => _idCart;

  String get idProduct => _idProduct;

  String get token => _token;

  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class IncreaseItemCartEvent extends BaseEvent{
  String token;
  String idProduct;
  int value;

  IncreaseItemCartEvent(this.token, this.idProduct, this.value);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class DecreaseItemCartEvent extends BaseEvent{
  String token;
  String idProduct;
  int value;

  DecreaseItemCartEvent(this.token, this.idProduct, this.value);

  @override
  // TODO: implement props
  List<Object?> get props => [];

}