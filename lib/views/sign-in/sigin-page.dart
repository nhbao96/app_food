import 'package:appp_sale_29092022/common/bases/base_widget.dart';
import 'package:appp_sale_29092022/data/datasources/remote/api_request.dart';
import 'package:appp_sale_29092022/data/respositories/authendication_respository.dart';
import 'package:appp_sale_29092022/views/sign-in/sigin-bloc.dart';
import 'package:appp_sale_29092022/views/sign-in/signin-event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      child: _SignInContainer(),
      providers: [
        Provider(create: (context) => ApiRequest() ),
        ProxyProvider<ApiRequest,AuthendicationRespository>(
          create: (context)=>AuthendicationRespository(),
          update: (context,request,respository){
            respository?.updateApiRequest(request);
            return respository!;
          },
        ),
        ProxyProvider<AuthendicationRespository,SignBloc>(
          create: (context)=> SignBloc(),
          update: (context,respository,bloc){
            bloc?.updateRepository(respository);
            return bloc!;
          },
        )
      ],
      appBar: AppBar(
        title: Text("Sign-In"),
      ),
    );
  }
}

class _SignInContainer extends StatefulWidget {
  const _SignInContainer({Key? key}) : super(key: key);

  @override
  State<_SignInContainer> createState() => _SignInContainerState();
}

class _SignInContainerState extends State<_SignInContainer> {
  late SignBloc bloc;

  late TextEditingController _accountInputController;
  late TextEditingController _passwordInputController;
  late ApiRequest _apiRequest;
  late AuthendicationRespository _authendicationRespository;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    bloc = context.read();

    _accountInputController = TextEditingController();
    _accountInputController.text = "";
    _passwordInputController = TextEditingController();
    _passwordInputController.text = "";
    _apiRequest = ApiRequest();
    _authendicationRespository  = AuthendicationRespository();
    _authendicationRespository.updateApiRequest(_apiRequest);
  }

  @override
  void didUpdateWidget(covariant _SignInContainer oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
      children: [
        Column(
          children: [
            Expanded(
                flex: 2, child: Image.asset("assets/images/ic_hello_food.png")),
            Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildInputAccountWidget(),
                      _buildInputPasswordWidget(),
                      _loginButton(MediaQuery.of(context).size.width*0.5)
                    ],
                  ),
                )),
            Expanded(flex: 1, child: _signUpWidget()),
          ],
        )
      ],
    ));
  }

  Widget _buildInputAccountWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: TextField(
        controller: _accountInputController,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.blue)),
          hintText: 'Input a your account',
        ),
      ),
    );
  }

  Widget _buildInputPasswordWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: _passwordInputController,
        obscureText: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.blue)),
          hintText: 'Input a your password',
        ),
      ),
    );
  }

  Widget _loginButton(double width){
    return Container(
      width: width ,
      margin: EdgeInsets.only(top: 20),
      child: ElevatedButton(
        onPressed: (){
          bloc.eventSink.add(SignInEvent(email: _accountInputController.text, password: _passwordInputController.text));
          _accountInputController.text = "";
          _passwordInputController.text = "";
        },
        child: Text("Log in"),
      ),
    );
  }

  Widget _signUpWidget(){
    return Container(
      child: TextButton(onPressed: (){}, child: Text("Sign up a new account?"),),
    );
  }
}

