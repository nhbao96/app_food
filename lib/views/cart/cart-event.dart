import 'package:appp_sale_29092022/common/bases/base_event.dart';

class CartEvent extends BaseEvent{
  String token;
  @override
  // TODO: implement props
  List<Object?> get props => [];

  CartEvent({ required this.token});
}

class UpdateCartEvent extends BaseEvent{
  String _idCart;
  String _idProduct;
  int _quantity;

  UpdateCartEvent(this._idCart, this._idProduct, this._quantity);

  int get quantity => _quantity;

  String get idCart => _idCart;

  String get idProduct => _idProduct;

  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class UpdateCartSuccess extends BaseEvent{
  int _quantity;
  int _totalMoney;
  int get quantity => _quantity;

  UpdateCartSuccess(this._quantity, this._totalMoney);

  int get totalMoney => _totalMoney;

  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class UpdateCartFailed extends BaseEvent{

  @override
  // TODO: implement props
  List<Object?> get props => [];

  UpdateCartFailed();
}