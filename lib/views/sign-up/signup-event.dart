import 'dart:async';

import 'package:appp_sale_29092022/common/bases/base_event.dart';

import '../../data/models/user.dart';

class SignUpEvent extends BaseEvent{
  String email;
  String password;
  String name;
  String phone;
  String address;

  SignUpEvent({required this.email, required this.password, required this.name, required this.phone, required this.address});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

}