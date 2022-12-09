import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/bases/base_widget.dart';
import '../../../common/constants/variable_constant.dart';
import '../../../common/utils/extension.dart';
import '../../../data/datasources/remote/api_request.dart';
import '../../../data/model/Cart.dart';
import '../../../data/repositories/order_repository.dart';
import 'order_bloc.dart';
import 'order_event.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return PageContainer(child: _OrderHistoryContainer(), providers: [
      Provider<ApiRequest>(
        create: (context) => ApiRequest(),
      ),
      ProxyProvider<ApiRequest, OrderRespository>(
        create: (context) => OrderRespository(),
        update: (context, apiRequest, orderRespository) {
          orderRespository?.updateApiRequest(apiRequest);
          return orderRespository!;
        },
      ),
      ProxyProvider<OrderRespository, OrderBloc>(
          create: (context) => OrderBloc(),
          update: (context, orderRespository, orderBloc) {
            orderBloc?.updateOrderRespository(orderRespository);
            return orderBloc!;
          })
    ]);
  }
}

class _OrderHistoryContainer extends StatefulWidget {
  const _OrderHistoryContainer({Key? key}) : super(key: key);

  @override
  State<_OrderHistoryContainer> createState() => _OrderHistoryContainerState();
}

class _OrderHistoryContainerState extends State<_OrderHistoryContainer> {
  late OrderBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = context.read();
    _bloc.eventSink.add(ShowOrderHistoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      child: StreamBuilder<List<Cart>>(
        stream: _bloc.streamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container(
              child: Center(child: Text("Data error")),
            );
          }
          if (snapshot.hasData && snapshot.data! == []) {
            return Center(
              child: Center(child: Text("Data empty")),
            );
          }
          return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                return Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: _orderItemWidget(context, snapshot.data![index]));
              });
        },
      ),
    ));
  }

  Widget _orderItemWidget(BuildContext context, Cart item) {
    return InkWell(
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          width: MediaQuery.of(context).size.width * 0.8,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                  child: Text(
                item.dateCreated,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              )),
              Flexible(
                  child: Text(
                "Total : ${convertToMoney(item.price)}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
              ))
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, VariableConstant.ORDER_DETAIL_PAGE,
            arguments: {"cart": item});
      },
    );
  }
}
