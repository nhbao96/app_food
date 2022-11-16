import 'package:appp_sale_29092022/common/bases/base_widget.dart';
import 'package:appp_sale_29092022/data/datasources/remote/api_request.dart';
import 'package:appp_sale_29092022/data/respositories/authendication_respository.dart';
import 'package:appp_sale_29092022/views/sign-up/signup-bloc.dart';
import 'package:appp_sale_29092022/views/sign-up/signup-event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return PageContainer(child: _SignUpContainer(),
      providers: [
        Provider(create: (context)=>ApiRequest()),
        ProxyProvider<ApiRequest,AuthendicationRespository>(
          create: (context)=>AuthendicationRespository(),
          update: (context,request, authenRepo){
            authenRepo?.updateApiRequest(request);
            return authenRepo!;
          },
        ),
        ProxyProvider<AuthendicationRespository,SignUpBloc>(
          create: (context)=>SignUpBloc(),
          update: (context,respository,signupbloc){
            signupbloc?.updateAuthenRespo(respository);
            return signupbloc!;
          },
        )
      ],
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
  late TextEditingController _inputNameController;
  late TextEditingController _inputPhoneController;
  late TextEditingController _inputAddressController;

  late SignUpBloc bloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _inputAccountController = TextEditingController();
    _inputPasswordController = TextEditingController();
    _inputPassConfirmController = TextEditingController();
    _inputNameController = TextEditingController();
    _inputPhoneController = TextEditingController();
    _inputAddressController = TextEditingController();
    bloc = context.read();
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
              Expanded(child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    inputWidget("Input your account",_inputAccountController,false,TextInputType.text),
                    inputWidget("Input password",_inputPasswordController,true,TextInputType.text),
                    inputWidget("Re-Input password",_inputPassConfirmController,true,TextInputType.text),
                    inputWidget("Input your name",_inputNameController,false,TextInputType.text),
                    inputWidget("Input your phone",_inputPhoneController,false,TextInputType.phone),
                    inputWidget("Input your address",_inputAddressController,false,TextInputType.text),
                    SizedBox(height: 20,),
                    ElevatedButton(onPressed: (){
                      handleConfirmBtn();
                    }, child: Text("Confirm"))
                  ],
                ),
              ),flex: 5,),
            ],
          ),
        ),
      ],
    ));
  }

  Widget inputWidget(String hint, TextEditingController textEditingController, bool isPwd, TextInputType textInputType){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextField(
        keyboardType:textInputType,
        controller: textEditingController,
        obscureText: isPwd,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.blue)),
          hintText: hint,
        ),
      ),
    );
  }

  void showNotiScafoldMessage(String message){
    if(!message.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void handleConfirmBtn() {
    String messageErr = "";
    if(_inputAccountController.text.isEmpty){
      messageErr = "please input your account !";
    }else if(_inputPasswordController.text.isEmpty){
      messageErr = "please input your password !";
    }else if(_inputPassConfirmController.text.isEmpty){
      messageErr = "please confirm your password !";
    }else if(_inputNameController.text.isEmpty){
      messageErr = "please input your name !";
    }else if(_inputPhoneController.text.isEmpty){
      messageErr = "please input your phone number !";
    }else if(_inputAddressController.text.isEmpty){
      messageErr = "please input your address !";
    }else{
      if(_inputPassConfirmController.text != _inputPassConfirmController.text){
        messageErr ="the password is not match!";
      }else{
        bloc.eventSink.add(SignUpEvent(email: _inputAccountController.text,
                                      password: _inputPasswordController.text,
                                      name: _inputNameController.text,
                                      phone: _inputPhoneController.text,
                                      address: _inputAddressController.text));
      }
    }
    showNotiScafoldMessage(messageErr);
  }

  void showNotiDialog(String message){
    showNotiDialog(message);
  }
}
