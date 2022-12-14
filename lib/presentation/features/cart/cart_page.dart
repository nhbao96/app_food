import 'package:app_food_baonh/common/constants/variable_constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/bases/base_widget.dart';
import '../../../common/constants/api_constant.dart';
import '../../../common/utils/extension.dart';
import '../../../common/widgets/loading_widget.dart';
import '../../../common/widgets/progress_listener_widget.dart';
import '../../../data/datasources/remote/api_request.dart';
import '../../../data/model/Cart.dart';
import '../../../data/repositories/cart_respository.dart';
import 'cart_bloc.dart';
import 'cart_event.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartViewState();
}

class _CartViewState extends State<CartPage> {
  late bool _isReloadHome;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isReloadHome = false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isReloadHome) {
          Navigator.pushReplacementNamed(context, VariableConstant.HOME_PAGE);
        } else {
          Navigator.pop(context);
        }
        return true;
      },
      child: PageContainer(
        child: _CartContainer(),
        providers: [
          Provider<ApiRequest>(
            create: (context) => ApiRequest(),
          ),
          ProxyProvider<ApiRequest, CartRespository>(
              create: (context) => CartRespository(),
              update: (context, apiRequest, cartRepository) {
                cartRepository?.updateApiRequest(apiRequest);
                return cartRepository!;
              }),
          ProxyProvider<CartRespository, CartBloc>(
              create: (context) => CartBloc(),
              update: (context, cartRespository, cartBloc) {
                cartBloc?.updateRepository(cartRespository);
                return cartBloc!;
              })
        ],
        appBar: AppBar(
          actions: [
            ProgressListenerWidget<CartBloc>(
                child: Container(),
                callback: (event) {
                  switch (event.runtimeType) {
                    case UpdateCartSuccessEvent:
                      _isReloadHome = true;
                      break;
                    default:
                      break;
                  }
                })
          ],
        ),
      ),
    );
  }
}

class _CartContainer extends StatefulWidget {
  const _CartContainer({Key? key}) : super(key: key);

  @override
  State<_CartContainer> createState() => _CartContainerState();
}

class _CartContainerState extends State<_CartContainer> {
  late CartBloc _cartBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cartBloc = context.read();
    _cartBloc.eventSink.add(GetCartEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: LoadingWidget(
      bloc: _cartBloc,
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: StreamBuilder<Cart>(
                stream: _cartBloc.streamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasError == true ||
                      (snapshot.hasData == true && snapshot.data == null)) {
                    return Center(
                      child: Text("Data failed"),
                    );
                  }
                  if ((snapshot.hasData &&
                          snapshot.data?.products.length == 0) &&
                      snapshot.connectionState == ConnectionState.active) {
                    return _emptyCartWidget();
                  }
                  return ListView.builder(
                    itemCount: snapshot.data?.products.length ?? 0,
                    itemBuilder: (context, index) {
                      String id = snapshot.data!.products[index].id ?? "";
                      String name = snapshot.data!.products[index].name ?? "";
                      String img = snapshot.data!.products[index].img ?? "";
                      int price = snapshot.data!.products[index].price ?? 0;
                      int quantity =
                          snapshot.data!.products[index].quantity ?? 0;

                      return Container(
                        height: 85,
                        child: _cartItemWidget(
                            id, img, String, name, price, quantity),
                      );
                    },
                  );
                },
              ),
            ),
            flex: 7,
          ),
          Expanded(
              child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: _summaryCartWidget(),
          )),
          ProgressListenerWidget<CartBloc>(
              child: Container(),
              callback: (event) {
                switch (event.runtimeType) {
                  case ConfirmCartSuccessEvent:
                    Navigator.pushReplacementNamed(
                        context, VariableConstant.HOME_PAGE);
                    showSnackBar(
                        context, (event as ConfirmCartSuccessEvent).msg);
                    break;
                  case ConfirmCartFailedEvent:
                    showSnackBar(
                        context, (event as ConfirmCartFailedEvent).msg);
                    break;
                }
              })
        ],
      ),
    ));
  }

  Widget _emptyCartWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Cart in detail",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text(
                "Your cart has no product",
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ],
          ),
        ),
        Flexible(
            flex: 4,
            child: Image.asset(
              "assets/images/icon_empty_cart.png",
              width: 200,
            ))
      ],
    );
  }

  Widget _cartItemWidget(
      String id, String img, String, name, int price, int quantity) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
              child: Image.network(
            ApiConstant.BASE_URL + img,
            width: 150,
          )),
          Flexible(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Text(
                    convertToMoney(price),
                    style: TextStyle(fontSize: 11, color: Colors.black),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: TextButton(
                          onPressed: () {
                            _cartBloc.eventSink
                                .add(DecreaseCartItemEvent(id, 1));
                          },
                          child: Text(
                            "-",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      Text(
                        quantity.toString(),
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: TextButton(
                          onPressed: () {
                            _cartBloc.eventSink
                                .add(IncreaseCartItemEvent(id, 1));
                          },
                          child: Text(
                            "+",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            flex: 2,
          )
        ],
      ),
    );
  }

  Widget _summaryCartWidget() {
    int value = 0;
    return Container(
      child: StreamBuilder<Cart>(
          stream: _cartBloc.streamController.stream,
          builder: (context, snapshot) {
            if (snapshot.data == null || snapshot.data?.products.length == 0) {
              return Container();
            }
            int price = snapshot.data?.price ?? 0;
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Money :",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    Text(convertToMoney(price),
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ],
                ),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      _cartBloc.eventSink.add(ConfirmCartEvent());
                    },
                    child: Text("Order",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ),
                )
              ],
            );
          }),
    );
  }
}
