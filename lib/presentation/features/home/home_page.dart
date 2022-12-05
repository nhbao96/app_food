import 'package:appp_sale_29092022/common/bases/base_widget.dart';
import 'package:appp_sale_29092022/common/constants/variable_constant.dart';
import 'package:appp_sale_29092022/data/datasources/remote/api_request.dart';
import 'package:appp_sale_29092022/data/model/Cart.dart';
import 'package:appp_sale_29092022/data/model/Product.dart';
import 'package:appp_sale_29092022/data/repositories/cart_respository.dart';
import 'package:appp_sale_29092022/presentation/features/cart/cart_bloc.dart';
import 'package:appp_sale_29092022/presentation/features/cart/cart_event.dart';
import 'package:appp_sale_29092022/presentation/features/home/home_event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/constants/api_constant.dart';
import '../../../common/utils/extension.dart';
import '../../../common/widgets/loading_widget.dart';
import '../../../common/widgets/progress_listener_widget.dart';
import '../../../data/repositories/product_respository.dart';
import 'home_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      providers: [
        Provider<ApiRequest>(create: (context) => ApiRequest()),
        ProxyProvider<ApiRequest, ProductRespository>(
          create: (context) => ProductRespository(),
          update: (context, apiRequest, productRespository) {
            productRespository?.updateApiRequest(apiRequest);
            return productRespository!;
          },
        ),
        ProxyProvider<ProductRespository, HomeBloc>(
            create: (context) => HomeBloc(),
            update: (context, productRespository, homeBloc) {
              homeBloc?.updateRespository(productRespository);
              return homeBloc!;
            }),
        ProxyProvider<ApiRequest, CartRespository>(
          create: (context) => CartRespository(),
          update: (context, apiRequest, cartRepository) {
            cartRepository?.updateApiRequest(apiRequest);
            return cartRepository!;
          },
        ),
        ProxyProvider<CartRespository, CartBloc>(
            create: (context) => CartBloc(),
            update: (context, cartRespository, cartBloc) {
              cartBloc?.updateRepository(cartRespository);
              return cartBloc!;
            }),
      ],
      child: _HomePageContainer(),
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
                    onPressed: () {
                        Navigator.pushNamed(context, VariableConstant.ORDER_HISTORY_PAGE);
                    },
                    icon: Icon(
                      Icons.history,
                      color: Colors.black,
                    )),
                Consumer<CartBloc>(
                  builder: (context, bloc, child){
                    return StreamBuilder<Cart>(
                        initialData: null,
                        stream: bloc.streamController.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasError || snapshot.data == null || snapshot.data?.products.isEmpty == true) {
                            return Container();
                          }
                          int count = snapshot.data?.products.length ?? 0;
                          return _shoppingCartWidget(count);
                        }
                    );
                  },
                )

              ],
            ),
            flex: 2,
          )
        ],
      ),
    );
  }

  Widget _shoppingCartWidget(int countItems){
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, VariableConstant.CART_PAGE);
      },
      child: Container(
        margin: EdgeInsets.only(right: 10, top: 10),
        child: Container(
          child: Badge(
            label: Text(countItems.toString(), style: const TextStyle(color: Colors.white),),
            child: Icon(Icons.shopping_cart_outlined),
          ),
        ),
      ),
    );
  }
}

class _HomePageContainer extends StatefulWidget {
  const _HomePageContainer({Key? key}) : super(key: key);

  @override
  State<_HomePageContainer> createState() => _HomePageContainerState();
}

class _HomePageContainerState extends State<_HomePageContainer> {
  late HomeBloc _homeBloc;
  late CartBloc _cartBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _homeBloc = context.read();
    _cartBloc = context.read();
    _homeBloc.eventSink.add(LoadHomeEvent());
    _cartBloc.eventSink.add(GetCartEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:  Stack(
          children: [
            LoadingWidget(
              bloc: _homeBloc,
              child: StreamBuilder<List<Product>>(
                  initialData: const [],
                  stream: _homeBloc.productStreamController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Container(
                        child: Center(child: Text("Data error")),
                      );
                    }
                    if (snapshot.hasData && snapshot.data == []) {
                      return Center(
                        child: ReloadButton(_homeBloc),
                      );
                    }
                    return ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          String img = snapshot.data?[index].img.toString() ?? "";
                          String title = snapshot.data?[index].name.toString() ?? "";
                          String address =  snapshot.data?[index].address.toString() ?? "";
                          String price =snapshot.data?[index].price.toString() ?? "";
                          String idProduct = snapshot.data?[index].id.toString() ?? "";
                          return ProductWidget(context, img, title, address, price,idProduct);
                        });
                  }),
            )

          ],
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
                                  addToCart(_cartBloc, idProduct, 1);
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

  void addToCart(CartBloc bloc, String idProduct, int quantity){
    bloc.eventSink.add(IncreaseCartItemEvent(idProduct, quantity));
  }

  Widget ReloadButton(HomeBloc bloc) {
    return ElevatedButton(
        onPressed: () {
          bloc.eventSink.add(LoadHomeEvent());
        },
        child: Text("Reload"));
  }
}
