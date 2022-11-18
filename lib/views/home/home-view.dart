import 'package:appp_sale_29092022/common/bases/base_widget.dart';
import 'package:appp_sale_29092022/data/datasources/remote/api_request.dart';
import 'package:appp_sale_29092022/data/models/product.dart';
import 'package:appp_sale_29092022/data/respositories/product_respository.dart';
import 'package:appp_sale_29092022/views/home/home-bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/constants/api_constant.dart';
import 'home-event.dart';

class HomeProductPage extends StatefulWidget {
  const HomeProductPage({Key? key}) : super(key: key);

  @override
  State<HomeProductPage> createState() => _HomeProductPageState();
}

class _HomeProductPageState extends State<HomeProductPage> {

  @override
  Widget build(BuildContext context) {
    String args = ModalRoute.of(context)?.settings.arguments.toString() ??"";
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
          )
        ],
        appBar: AppBar(
          title: Row(
            children: [
              Expanded(
                child: Text(
                  "Food",
                  style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
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
                          Icons.stars_rounded,
                          color: Colors.black,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.shopping_cart,
                          color: Colors.orange,
                        ))
                  ],
                ),
                flex: 2,
              )
            ],
          ),
        ));
  }
}

class _HomeProductContainer extends StatefulWidget {
  const _HomeProductContainer({Key? key}) : super(key: key);

  @override
  State<_HomeProductContainer> createState() => _HomeProductContainerState();
}

class _HomeProductContainerState extends State<_HomeProductContainer> {
  late HomeBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = context.read();
    bloc.eventSink.add(LoadListProducts());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      child: Stack(
        children: [
          StreamBuilder<List<ProductModel>>(
              initialData: const [],
              stream: bloc.ListProduct,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Container(
                    child: Center(child: Text("Data error")),
                  );
                }
                if (snapshot.hasData && snapshot.data == []) {
                  return Container();
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

                      return ProductWidget(context, img, title, address, price);
                    });
              }),
        ],
      ),
    ));
  }

  Widget ProductWidget(BuildContext context, String img, String title,
      String address, String price) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width*0.8,
      height: 100,
      child: Card(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Image.network(
                ApiConstant.BASE_URL + img,
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(title,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Expanded(
                              child: Text(
                                address,
                                maxLines: 1,
                                softWrap: false,
                                style: TextStyle(color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                price,
                                maxLines: 1,
                                softWrap: false,
                                style: TextStyle(
                                    color: Colors.black, fontStyle: FontStyle.italic),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      flex: 3),
                  Expanded(
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Container(
                         child: ElevatedButton(onPressed: (){}, child: Text("Add"),style: ButtonStyle(backgroundColor:MaterialStateProperty.all(Colors.orange) ,
                             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                 RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(18.0),
                                     side: BorderSide(color: Colors.orange),
                                 )
                             )
                         )),
                       )
                     ],
                   ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
