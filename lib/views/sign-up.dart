import 'package:appp_sale_29092022/common/bases/base_widget.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return PageContainer(child: _SignUpContainer(), providers: [],
    appBar: AppBar(title: Text("Sign Up"),),);
  }
}

class _SignUpContainer extends StatefulWidget {
  const _SignUpContainer({Key? key}) : super(key: key);

  @override
  State<_SignUpContainer> createState() => _SignUpContainerState();
}

class _SignUpContainerState extends State<_SignUpContainer> {
  late TextEditingController _inputAccountController;
  late TextEditingController _inputPasswordController;
  late TextEditingController _inputPassConfirmController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _inputAccountController = TextEditingController();
    _inputPasswordController = TextEditingController();
    _inputPassConfirmController = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Image.asset("assets/images/account.png")), flex: 1,),
              Expanded(child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        inputWidget("Input your account",_inputAccountController,false),
                        inputWidget("Input password",_inputPasswordController,true),
                        inputWidget("Re-Input password",_inputPassConfirmController,true),
                        ElevatedButton(onPressed: (){}, child: Text("Confirm"))
                      ],
                    ),
                  ),
                ],
              ),flex: 5,),
            ],
          ),
        ),
      ],
    ));
  }

  Widget inputWidget(String hint, TextEditingController textEditingController, bool isPwd){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      child: TextField(
        controller: textEditingController,
        obscureText: isPwd,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.blue)),
          hintText: hint,
        ),
      ),
    );
  }
}
