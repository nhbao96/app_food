import 'dart:async';

import 'package:app_food_baonh/presentation/features/sign_in/sign_in_event.dart';

import '../../../common/bases/base_bloc.dart';
import '../../../common/bases/base_event.dart';
import '../../../common/constants/variable_constant.dart';
import '../../../data/datasources/local/cache/app_cache.dart';
import '../../../data/datasources/remote/dto/app_resource.dart';
import '../../../data/datasources/remote/dto/user_dto.dart';
import '../../../data/repositories/authentication_repository.dart';



class SignInBloc extends BaseBloc {
  late AuthenticationRepository _repository;

  void updateAuthenRepo(AuthenticationRepository authenticationRepository) {
    _repository = authenticationRepository;
  }

  @override
  void dispatch(BaseEvent event) {
    switch (event.runtimeType) {
      case SignInEvent:
        handleSignIn(event as SignInEvent);
        break;
    }
  }

  void handleSignIn(SignInEvent event) async {
    loadingSink.add(true);
    try {
      AppResource<UserDTO> resourceUserDTO =
          await _repository.signIn(event.email, event.password);
      if (resourceUserDTO.data == null) return;
      UserDTO userDTO = resourceUserDTO.data!;
      AppCache.setString(key: VariableConstant.TOKEN, value: userDTO.token ?? "");
      progressSink.add(SignInSuccessEvent());
      loadingSink.add(false);
    } catch (e) {
      progressSink.add(SignInFailEvent(message: e.toString()));
      loadingSink.add(false);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
