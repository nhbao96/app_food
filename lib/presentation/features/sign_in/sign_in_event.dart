
import '../../../common/bases/base_event.dart';
class SignInEvent extends BaseEvent {
  String email, password;

  SignInEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [];

}

class SignInSuccessEvent extends BaseEvent {
  @override
  List<Object?> get props => [];

}

class SignInFailEvent extends BaseEvent {
  String message;

  SignInFailEvent({required this.message});
  @override
  List<Object?> get props => [];

}