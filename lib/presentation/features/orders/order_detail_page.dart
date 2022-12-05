import 'package:appp_sale_29092022/common/bases/base_widget.dart';
import 'package:flutter/material.dart';

import '../../../data/model/Cart.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({Key? key}) : super(key: key);

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  Widget build(BuildContext context) {
    return PageContainer(child: _OrderDetailContainer(), providers: [],);
  }
}

class _OrderDetailContainer extends StatefulWidget {
  const _OrderDetailContainer({Key? key}) : super(key: key);

  @override
  State<_OrderDetailContainer> createState() => _OrderDetailContainerState();
}

class _OrderDetailContainerState extends State<_OrderDetailContainer> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    final  Map<String, Object> rcvdData  =  ModalRoute.of(context)!.settings.arguments as Map<String, Object>;
    Cart model = rcvdData["cart"] as Cart;
    return Container();
  }
}




