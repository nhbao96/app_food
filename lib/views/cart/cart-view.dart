import 'package:appp_sale_29092022/common/bases/base_widget.dart';
import 'package:appp_sale_29092022/common/utils/extension.dart';
import 'package:appp_sale_29092022/common/widgets/loading_widget.dart';
import 'package:appp_sale_29092022/data/datasources/remote/api_request.dart';
import 'package:appp_sale_29092022/data/models/cart.dart';
import 'package:appp_sale_29092022/data/respositories/cart_respository.dart';
import 'package:appp_sale_29092022/views/cart/cart-bloc.dart';
import 'package:appp_sale_29092022/views/cart/cart-event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/constants/api_constant.dart';
import '../../common/widgets/progress_listener_widget.dart';

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
      ProxyProvider<CartRespository, CartBloc>(
        create: (context) => CartBloc(),
        update: (context, cartRepo, cartBloc) {
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
  late CartModel _cartModel;
  late String _token =
      ModalRoute.of(context)?.settings.arguments.toString() ?? "";

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

  Widget _rootCartWidget(String token) {
    bloc.eventSink.add(CartEvent(token: token));
    return Container(
        child: LoadingWidget(
            bloc: bloc,
            child: StreamBuilder<CartModel>(
              stream: bloc.streamController,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }
                if (snapshot.data == null) {
                  return Center(
                    child: Text("Loading ..."),
                  );
                }
                _cartModel = snapshot.data!;
                int totalItems = _cartModel.products.length;
                if (totalItems == 0) {
                  return Center(child: Text("Your cart is empty!"));
                }
                double screenWidth = MediaQuery.of(context).size.width;
                return Stack(
                  children: [
                    ListView.builder(
                        padding: const EdgeInsets.all(25),
                        itemCount: _cartModel.products.length ?? 0,
                        itemBuilder: (context, index) {
                          String id = _cartModel.products[index].id;
                          String img = _cartModel.products[index].img;
                          String name = _cartModel.products[index].name;
                          int price = _cartModel.products[index].price;
                          int quantity = _cartModel.products[index].quatity;
                          return CartItemWidget(
                              context, id, img, name, price, quantity);
                        }),
                    Column(
                      children: [
                        Expanded(child: Container(),flex: 8,),
                        Expanded(child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Total money :"),
                                  Text(convertToMoney(_cartModel.price))
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              height: 30,
                              child: ElevatedButton(
                                onPressed: (){},
                                child: Text("Order", style: TextStyle(fontSize: 11),),
                              ),
                            )
                          ],
                        ),flex: 1,)
                      ],
                    )
                  ],
                );
              },
            )));
  }

  Widget CartItemWidget(BuildContext context, String id, String img,
      String name, int price, int quantity) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.9,
      height: 100,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Image.network(
                ApiConstant.BASE_URL + img,
                width: 150,
              ),
            ),
            Flexible(
                child: Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Text(convertToMoney(price), style: TextStyle(fontSize: 11)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            bloc.eventSink.add(UpdateCartEvent(
                                _cartModel.sId, id, quantity - 1));
                          },
                          child: Text("-")),
                      Text(quantity.toString()),
                      TextButton(
                          onPressed: () {
                            bloc.eventSink.add(UpdateCartEvent(
                                _cartModel.sId, id, quantity + 1));
                          },
                          child: Text("+")),
                    ],
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
