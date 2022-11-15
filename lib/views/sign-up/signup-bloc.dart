import 'dart:async';

import 'package:appp_sale_29092022/common/bases/base_bloc.dart';
import 'package:appp_sale_29092022/common/bases/base_event.dart';
import 'package:appp_sale_29092022/data/datasources/remote/dto/app_resource.dart';
import 'package:appp_sale_29092022/data/datasources/remote/dto/user_dto.dart';
import 'package:appp_sale_29092022/data/respositories/authendication_respository.dart';
import 'package:appp_sale_29092022/views/sign-up/signup-event.dart';

import '../../data/models/user.dart';

class SignUpBloc  extends BaseBloc{
  late AuthendicationRespository _authendicationRespository;
  StreamController<User> _signUpStreamController = StreamController();
  Stream<User> get user => _signUpStreamController.stream;

  void updateAuthenRespo(AuthendicationRespository authendicationRespository){
    _authendicationRespository = authendicationRespository;
  }

  @override
  void dispatch(BaseEvent event) {
    // TODO: implement dispatch
    switch(event.runtimeType){
      case SignUpEvent:
        handleSignUpEvent(event as SignUpEvent);
        break;
    }
  }

  void handleSignUpEvent(SignUpEvent event) async {
    try{
      AppResource<UserDto> resource = _authendicationRespository.signUp(event.email, event.password, event.name, event.phone, event.address);
    }catch(e){

    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _signUpStreamController.close();
  }

}