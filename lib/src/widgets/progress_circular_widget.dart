import 'package:flutter/material.dart';

class ProgressCircularWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final String mensagem;
  final Color cor;
  const ProgressCircularWidget({required this.mensagem, required this.cor, Key? key, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: width ?? 30,
              height: height ?? 30,
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(cor)),
            ),
            Text(mensagem)
          ],
        ),
      )
    );
  }
}
