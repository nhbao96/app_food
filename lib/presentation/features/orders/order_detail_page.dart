import 'package:flutter/material.dart';

import '../../../common/bases/base_widget.dart';
import '../../../common/constants/api_constant.dart';
import '../../../common/utils/extension.dart';
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
    print("model ${model.toString()}");
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Column(
        children: [
          Expanded(child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: model.products.length ?? 0,
              itemBuilder: (context,index){
                String title = model.products[index].name;
                String img = model.products[index].img;
                int price = model.products[index].price;
                int quantity = model.products[index].quantity;
                return ProductWidget(context, img, title, price.toString(), quantity);
              }),flex: 9,),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Total money of your order",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),),
              Text(convertToMoney(model.price),style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold,color: Colors.red),)
            ],
          ),flex: 2),
        ],
      ),
    );
  }

  Widget ProductWidget(BuildContext context, String img, String title,String price, int quantity) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.98,
      height: 110,
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
                            //  margin: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "Price : ${convertToMoney(int.parse(price))}",
                              maxLines: 1,
                              softWrap: false,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            //  margin: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "Quantity : ${quantity}",
                              maxLines: 1,
                              softWrap: false,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
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
}




