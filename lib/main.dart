import 'package:appp_sale_29092022/common/constants/variable_constant.dart';
import 'package:appp_sale_29092022/data/datasources/local/cache/app_cache.dart';
import 'package:appp_sale_29092022/presentation/features/cart/cart_page.dart';
import 'package:appp_sale_29092022/presentation/features/home/home_page.dart';
import 'package:appp_sale_29092022/presentation/features/orders/order_detail_page.dart';
import 'package:appp_sale_29092022/presentation/features/orders/order_page.dart';
import 'package:appp_sale_29092022/presentation/features/sign_in/sign_in_page.dart';
import 'package:appp_sale_29092022/presentation/features/sign_up/sign_up_page.dart';
import 'package:appp_sale_29092022/presentation/features/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


void main() {
  runApp(const MyApp());
  AppCache.init();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      routes: {
        VariableConstant.SIGN_IN: (context) => SignInPage(),
        VariableConstant.SIGN_UP: (context) => SignUpPage(),
        VariableConstant.SPLASH: (context) => SplashPage(),
        VariableConstant.HOME_PAGE: (context) => HomePage(),
        VariableConstant.CART_PAGE: (context) =>CartPage(),
        VariableConstant.ORDER_HISTORY_PAGE : (context)=>OrderHistoryPage(),
        VariableConstant.ORDER_DETAIL_PAGE : (context)=>OrderDetailPage()
      },
      initialRoute:  VariableConstant.SPLASH,
    );
  }
}
