import 'package:appp_sale_29092022/common/bases/base_widget.dart';
import 'package:appp_sale_29092022/data/datasources/remote/api_request.dart';
import 'package:appp_sale_29092022/data/respositories/cart_respository.dart';
import 'package:appp_sale_29092022/views/cart/cart-bloc.dart';
import 'package:appp_sale_29092022/views/cart/cart-event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartView extends StatefulWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  Widget build(BuildContext context) {
    return PageContainer(child: _CartContainer(), providers: [
      Provider<ApiRequest>(
        create: (context) => ApiRequest(),
      ),
      ProxyProvider<ApiRequest, CartRespository>(
        create: (context) => CartRespository(),
        update: (context, apirequest, cartrepo) {
          cartrepo?.updateApiRequest(apirequest);
          return cartrepo!;
        },
      ),
      ProxyProvider<CartRespository,CartBloc>(
        create: (context)=>CartBloc(),
        update: (context,cartRepo,cartBloc){
          cartBloc?.updateRepository(cartRepo);
          return cartBloc!;
        },
      )
    ]);
  }
}

class _CartContainer extends StatefulWidget {
  const _CartContainer({Key? key}) : super(key: key);

  @override
  State<_CartContainer> createState() => _CartContainerState();
}

class _CartContainerState extends State<_CartContainer> {
  late CartBloc bloc;
  late String _token =  ModalRoute.of(context)?.settings.arguments.toString() ?? "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = context.read();

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: _rootCartWidget(_token));
  }

  Widget _rootCartWidget(String token){
    bloc.eventSink.add(CartEvent(token: token));
    return Container();
  }
}
