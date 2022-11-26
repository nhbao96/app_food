import 'package:appp_sale_29092022/common/bases/base_widget.dart';
import 'package:appp_sale_29092022/common/utils/extension.dart';
import 'package:appp_sale_29092022/common/widgets/progress_listener_widget.dart';
import 'package:appp_sale_29092022/data/datasources/remote/api_request.dart';
import 'package:appp_sale_29092022/data/models/cart.dart';
import 'package:appp_sale_29092022/data/models/product.dart';
import 'package:appp_sale_29092022/data/respositories/cart_respository.dart';
import 'package:appp_sale_29092022/data/respositories/product_respository.dart';
import 'package:appp_sale_29092022/views/cart/cart-bloc.dart';
import 'package:appp_sale_29092022/views/cart/cart-event.dart';
import 'package:appp_sale_29092022/views/home/home-bloc.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/constants/api_constant.dart';
import '../../common/widgets/loading_widget.dart';
import 'home-event.dart';

class HomeProductPage extends StatefulWidget {
  const HomeProductPage({Key? key}) : super(key: key);

  @override
  State<HomeProductPage> createState() => _HomeProductPageState();
}

class _HomeProductPageState extends State<HomeProductPage> {
  @override
  Widget build(BuildContext context) {
    String args = ModalRoute.of(context)?.settings.arguments.toString() ?? "";
    print("_HomeProductPageState : token = $args");
    return PageContainer(
        child: _HomeProductContainer(),
        providers: [
          Provider<ApiRequest>(create: (context) => ApiRequest()),
          ProxyProvider<ApiRequest, ProductRespository>(
            create: (context) => ProductRespository(),
            update: (context, apiRequest, productRepo) {
              productRepo?.updateApiRequest(apiRequest);
              return productRepo!;
            },
          ),
          ProxyProvider<ProductRespository, HomeBloc>(
            create: (context) => HomeBloc(),
            update: (context, productRespository, homeBloc) {
              homeBloc?.updateRespository(productRespository);
              return homeBloc!;
            },
          ),
          ProxyProvider<ApiRequest, CartRespository>(
            create: (context) => CartRespository(),
            update: (context, apiRequest, cartRepo) {
              cartRepo?.updateApiRequest(apiRequest);
              return cartRepo!;
            },
          ),
          ProxyProvider<CartRespository, CartBloc>(
            create: (context) => CartBloc(),
            update: (context, cartRespository, cartBloc) {
              cartBloc?.updateRepository(cartRespository);
              return cartBloc!;
            },
          )
        ],
        appBar: AppBar(
          actions: [
            Expanded(
              child: Center(
                child: Text(
                  "Food",
                  style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
              flex: 1,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.history,
                        color: Colors.black,
                      )),
                  Consumer<CartBloc>(
                    builder: (context, bloc, child){
                      return StreamBuilder<CartModel>(
                          initialData: null,
                          stream: bloc.streamController,
                          builder: (context, snapshot) {
                            if (snapshot.hasError || snapshot.data == null || snapshot.data?.products.isEmpty == true) {
                              return Container();
                            }
                            int count = snapshot.data?.products.length ?? 0;
                            return shoppingCartWidget(args,count);
                          }
                      );
                    },
                  )

                ],
              ),
              flex: 2,
            )
          ],
        ));
  }

  Widget shoppingCartWidget(String token, int count){
    return Stack(
      children: [
        IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "cart-page",
                  arguments: token);
            },
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.orange,
            )),
        Container(
          margin: EdgeInsets.only(right: 10, top: 10),
          child: Container(
            child: Badge(
              key: Key(count.toString()),
              child: Icon(Icons.shopping_cart_outlined),
            ),
          ),
        ),
      ],
    );
  }
}

class _HomeProductContainer extends StatefulWidget {
  const _HomeProductContainer({Key? key}) : super(key: key);

  @override
  State<_HomeProductContainer> createState() => _HomeProductContainerState();
}

class _HomeProductContainerState extends State<_HomeProductContainer> {
  late HomeBloc bloc;
  late CartBloc cartBloc;
  late String _token;
  late String _cartId;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = context.read();
    bloc.eventSink.add(LoadListProducts());

    cartBloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    _token = ModalRoute.of(context)?.settings.arguments.toString() ?? "";
    if (!_token.isEmpty) {
      cartBloc.eventSink.add(CartEvent(token: _token));
    }

    return SafeArea(
        child: Container(
      child: Stack(
        children: [
          LoadingWidget(
            bloc: bloc,
            child: StreamBuilder<List<ProductModel>>(
                initialData: const [],
                stream: bloc.ListProduct,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Container(
                      child: Center(child: Text("Data error")),
                    );
                  }
                  if (snapshot.hasData && snapshot.data == []) {
                    return Center(
                      child: ReloadButton(),
                    );
                  }

                  return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        String img = snapshot.data?[index].img.toString() ?? "";
                        String title =
                            snapshot.data?[index].name.toString() ?? "";
                        String address =
                            snapshot.data?[index].address.toString() ?? "";
                        String price =
                            snapshot.data?[index].price.toString() ?? "";
                        String idProduct = snapshot.data?[index].id.toString() ?? "";
                        return ProductWidget(
                            context, img, title, address, price,idProduct);
                      });
                }),
          ),
          ProgressListenerWidget<CartBloc>(child: Container(), callback: (event){
            if(event.runtimeType ==  GetCartSuccess){
              _cartId = (event as GetCartSuccess).idCart;
            }
          })
        ],
      ),
    ));
  }

  Widget ProductWidget(BuildContext context, String img, String title,
      String address, String price, String idProduct) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.98,
      height: 120,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Image.network(
                ApiConstant.BASE_URL + img,
                width: 175,
              ),
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(left: 10, top: 5, bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // margin: EdgeInsets.symmetric(vertical: 10),
                            child: Text(title.toUpperCase(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: false,
                                style: TextStyle(
                                    fontSize: 12.6,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 0),
                            child: Text(
                              address,
                              maxLines: 1,
                              softWrap: false,
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            //  margin: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              convertToMoney(int.parse(price)),
                              maxLines: 1,
                              softWrap: false,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontStyle: FontStyle.italic),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            child: SizedBox(
                              width: 60,
                              height: 20,
                              child: ElevatedButton(
                                onPressed: () {
                                  addToCart( idProduct, 1);
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.deepOrange),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: BorderSide(
                                                color: Colors.deepOrange)))),
                                child: Text(
                                  "ADD",
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void addToCart(String idProduct, int quantity){
    print("homeview : addToCart");
    cartBloc.eventSink.add(IncreaseItemCartEvent(_token, idProduct, quantity));
  }

  Widget ReloadButton() {
    return ElevatedButton(
        onPressed: () {
          bloc.eventSink.add(LoadListProducts());
        },
        child: Text("Reload"));
  }
}
