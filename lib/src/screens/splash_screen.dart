import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gamequizzapp/src/database/dao/login_dao.dart';
import 'package:gamequizzapp/src/http/webclients/user_webclient.dart';
import 'package:gamequizzapp/src/screens/category_screen.dart';
import 'package:gamequizzapp/src/screens/login_screen.dart';
import 'package:gamequizzapp/src/service/validation_token.dart';
import 'package:gamequizzapp/src/widgets/progress_circular_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  static final LoginDAO dao = LoginDAO();
  final UserWebClient userWebClient = UserWebClient();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = const Duration(seconds: 5);
    return Timer(duration, _verifyTokenLogin);
  }

  void _verifyTokenLogin() async {
    try {
      await dao.findTokenLocal().then((tokenLocal) async {
        if(tokenLocal.isNotEmpty){
          await dao.findTokenLocal().then((token) async {

            int tokenValidity = ValidationToken.getTokenLocalValidity(token);

            if(tokenValidity <= 60){
              await userWebClient.getUserByUsername(token[3], token[0]).then((user) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
                    CategoryScreen(token[3], token[4], user.idUser, user)));
              });
            } else{
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            }
          });
        }
        else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
        }
      });
    } on Exception {}
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(
            builder: (_, constraints){
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                      height: 50,
                      child: Text('Carregando...', style: TextStyle(color: Colors.black))
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: ProgressCircularWidget(mensagem: '', cor: Colors.black))
                ],
              );
            }
        )
      );
  }

}
