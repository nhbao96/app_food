import 'package:appp_sale_29092022/common/bases/base_widget.dart';
import 'package:appp_sale_29092022/common/utils/extension.dart';
import 'package:appp_sale_29092022/common/widgets/loading_widget.dart';
import 'package:appp_sale_29092022/common/widgets/progress_listener_widget.dart';
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
        Provider(create: (context) => ApiRequest()),
        ProxyProvider<ApiRequest, AuthendicationRespository>(
          create: (context) => AuthendicationRespository(),
          update: (context, request, respository) {
            respository?.updateApiRequest(request);
            return respository!;
          },
        ),
        ProxyProvider<AuthendicationRespository, SignBloc>(
          create: (context) => SignBloc(),
          update: (context, respository, bloc) {
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
    _authendicationRespository = AuthendicationRespository();
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
        LoadingWidget(
          bloc: bloc,
          child: Column(
            children: [
              Expanded(
                  flex: 2,
                  child: Image.asset("assets/images/ic_hello_food.png")),
              Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildInputAccountWidget(_accountInputController),
                        _buildInputPasswordWidget(_passwordInputController),
                        _loginButton(MediaQuery.of(context).size.width * 0.5,
                         onClick:    () {
                          String email = _accountInputController.text.toString();
                          String pass = _passwordInputController.text.toString();
                          email = "baonh@gmail.com";
                          pass ="123456789";
                          if (email.isEmpty || pass.isEmpty) {
                            showMessage(
                                context,
                                "Message",
                                "Input is not empty",
                                [
                                  ElevatedButton(onPressed: () {
                                    Navigator.pop(context);
                                  }, child: Text("ok"))
                                ]
                            );
                            return;
                          }

                          bloc.eventSink.add(SignInEvent(email: email, password: pass));
                        })
                      ],
                    ),
                  )),
              Expanded(flex: 1, child: _signUpWidget()),
            ],
          ),
        ),
        ProgressListenerWidget<SignBloc>(
            child: Container(),
            callback: (event) {
              switch (event.runtimeType) {
                case SignInSuccessEvent:
                  _accountInputController.clear();
                  _passwordInputController.clear();
                  Navigator.pushReplacementNamed(context, "home-page", arguments: (event as SignInSuccessEvent).getToken().toString());
                  break;
                case SignInFailEvent:
                  _accountInputController.clear();
                  _passwordInputController.clear();
                  showMessage(context,"Notice",(event as SignInFailEvent).toString());
                  break;
                default:
                  break;
              }
            })
      ],
    ));
  }

  Widget _buildInputAccountWidget(TextEditingController textEditingController) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Colors.blue)),
          hintText: 'Input a your account',
        ),
      ),
    );
  }

  Widget _buildInputPasswordWidget(
      TextEditingController textEditingController) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: textEditingController,
        obscureText: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Colors.blue)),
          hintText: 'Input a your password',
        ),
      ),
    );
  }

  Widget _loginButton(double width, {Function? onClick = null}) {
    return Container(
      width: width,
      margin: EdgeInsets.only(top: 20),
      child: ElevatedButton(
        onPressed:()=>onClick?.call(),
        child: Text("Log in"),
      ),
    );
  }

  Widget _signUpWidget() {
    return Container(
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, "sign-up");
        },
        child: Text("Sign up a new account?"),
      ),
    );
  }
}
