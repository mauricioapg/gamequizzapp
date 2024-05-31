import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamequizzapp/src/screens/splash_screen.dart';

class QuizzGameApp extends StatelessWidget {
  const QuizzGameApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuizzGame',
      theme: ThemeData(
        fontFamily: 'Helvetica',
      ),
      home: const SplashScreen(),
      locale: const Locale('pt','BR'),
    );
  }
}
