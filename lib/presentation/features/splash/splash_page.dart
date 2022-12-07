
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../common/constants/variable_constant.dart';
import '../../../data/datasources/local/cache/app_cache.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(const Duration(seconds: 2), () {
      String token = AppCache.getString(VariableConstant.TOKEN);
      if (token.isEmpty) {
        Navigator.pushReplacementNamed(context, "sign-in");
      } else {
        Navigator.pushReplacementNamed(context, "home");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.blueGrey,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Lottie.asset('assets/animations/animation_splash.json',
                  animate: true, repeat: true),
              Text("Welcome",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white))
            ],
          )),
    );
  }
}
