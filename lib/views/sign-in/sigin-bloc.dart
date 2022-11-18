import 'dart:async';

import 'package:appp_sale_29092022/common/bases/base_bloc.dart';
import 'package:appp_sale_29092022/data/datasources/remote/dto/app_resource.dart';
import 'package:appp_sale_29092022/data/models/user.dart';
import 'package:appp_sale_29092022/data/respositories/authendication_respository.dart';
import 'package:appp_sale_29092022/views/sign-in/signin-event.dart';

import '../../common/bases/base_event.dart';
import '../../data/datasources/remote/dto/user_dto.dart';

class SignBloc extends BaseBloc{
  late AuthendicationRespository _authendicationRespository;
  StreamController<User> _signInStreamController = StreamController();

  Stream<User> get user => _signInStreamController.stream;

  void updateRepository(AuthendicationRespository authendicationRespository){
    _authendicationRespository = authendicationRespository;
  }

  @override
  void dispatch(BaseEvent event){
    switch(event.runtimeType){
      case SignInEvent:
        handleSignInEvent(event as SignInEvent);
        break;
    }
  }
  void handleSignInEvent(SignInEvent event) async {
    loadingSink.add(true);
    try{
      AppResource<UserDto> resourceDTO = await _authendicationRespository.signIn(event.email, event.password);
       if(resourceDTO.data == null){
         return;
       }
      UserDto userDto = resourceDTO.data!;
      User userModel = User(userDto.email, userDto.name, userDto.phone, userDto.token);
      _signInStreamController.sink.add(userModel);
      loadingSink.add(false);
      progressSink.add(SignInSuccessEvent(token: userModel.token));
    }catch(e){
        print(e.toString());
        loadingSink.add(false);
        progressSink.add(SignInFailEvent());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _signInStreamController.close();
  }
}