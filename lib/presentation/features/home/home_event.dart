import 'package:appp_sale_29092022/common/bases/base_event.dart';

class LoadHomeEvent extends BaseEvent{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadHomeSuccessEvent extends BaseEvent{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadHomeFailedEvent extends BaseEvent{
  String message;
  LoadHomeFailedEvent({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}