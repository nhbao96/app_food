import 'package:appp_sale_29092022/common/bases/base_event.dart';

class GetCartEvent extends BaseEvent{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class IncreaseCartItemEvent extends BaseEvent{
  String idProduct;
  int quantity;

  IncreaseCartItemEvent(this.idProduct, this.quantity);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class DecreaseCartItemEvent extends BaseEvent{
  String idProduct;
  int quantity;

  DecreaseCartItemEvent(this.idProduct, this.quantity);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ConfirmCartEvent extends BaseEvent{

  @override
  // TODO: implement props
  List<Object?> get props => [];

  ConfirmCartEvent();
}

class ConfirmCartSuccessEvent extends BaseEvent{
  String msg;

  ConfirmCartSuccessEvent(this.msg);

  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class ConfirmCartFailedEvent extends BaseEvent{
  String msg;

  ConfirmCartFailedEvent(this.msg);

  @override
  // TODO: implement props
  List<Object?> get props => [];

}