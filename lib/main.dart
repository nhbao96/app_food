import 'package:appp_sale_29092022/views/cart/cart-view.dart';
import 'package:appp_sale_29092022/views/home/home-view.dart';
import 'package:appp_sale_29092022/views/sign-in/sigin-page.dart';
import 'package:appp_sale_29092022/views/sign-up/sign-up.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
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
        "sign-in" : (context) => SignInPage(),
        "sign-up" : (context) => SignUpPage(),
        "home-page" : (context) => HomeProductPage(),
        "cart-page" :(context)=> CartView()
      },
      initialRoute: "sign-in",
    );
  }
}
