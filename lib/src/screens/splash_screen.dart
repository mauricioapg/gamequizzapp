import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gamequizzapp/src/screens/login_screen.dart';
import 'package:gamequizzapp/src/widgets/progress_circular_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = const Duration(seconds: 5);
    return Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
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
