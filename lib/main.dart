import 'package:appp_sale_29092022/common/constants/variable_constant.dart';
import 'package:appp_sale_29092022/data/datasources/local/cache/app_cache.dart';
import 'package:appp_sale_29092022/views/cart/cart-view.dart';
import 'package:appp_sale_29092022/views/home/home-view.dart';
import 'package:appp_sale_29092022/views/sign-in/sigin-page.dart';
import 'package:appp_sale_29092022/views/sign-up/sign-up.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
  AppCache.init();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.white)
      ),
      routes: {
        VariableConstant.ROUTE_SIGNIN : (context) => SignInPage(),
        VariableConstant.ROUTE_SIGNUP : (context) => SignUpPage(),
        VariableConstant.ROUTE_HOME : (context) => HomeProductPage(),
       VariableConstant.ROUTE_CARTPAGE :(context)=> CartView()
      },
      initialRoute: VariableConstant.ROUTE_SIGNIN,
    );
  }
}
