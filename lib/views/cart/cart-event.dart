import 'package:appp_sale_29092022/common/bases/base_event.dart';

class CartEvent extends BaseEvent{
  String token;
  @override
  // TODO: implement props
  List<Object?> get props => [];

  CartEvent({ required this.token});
}