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
    return PageContainer(child: _HomeProductContainer(),
      providers: [
        Provider<ApiRequest>(create: (context) => ApiRequest()),
        ProxyProvider<ApiRequest,ProductRespository>(create: (context) => ProductRespository(),
        update: (context, apiRequest,productRepo){
          productRepo?.updateApiRequest(apiRequest);
          return productRepo!;
        },),
        ProxyProvider<ProductRespository,HomeBloc>(create: (context)=>HomeBloc(),
        update: (context, productRespository, homeBloc){
          homeBloc?.updateRespository(productRespository);
          return homeBloc!;
        },)
      ],
    appBar: AppBar(title: Text("Home Page"),),);
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
                    return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20),
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          String img = snapshot.data?[index].img.toString() ??"";
                          return Image.network(ApiConstant.BASE_URL + img);
                        }
                    );
                  }
              ),

            ],
          ),
        )
    );
  }
}
