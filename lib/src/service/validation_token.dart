// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../http/webclients/login_webclient.dart';
//
// class ValidationToken{
//
//   static final LoginWebClient loginWebClient = LoginWebClient();
//
//   static Future<String?> getToken(BuildContext context, String username, String password) async {
//
//     String? tokenAutentication = '';
//
//     await loginWebClient.getToken(username, password).then((token) async {
//       tokenAutentication = token;
//     });
//     return tokenAutentication;
//   }
//
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamequizzapp/src/database/dao/login_dao.dart';
import 'package:gamequizzapp/src/http/webclients/login_webclient.dart';
import 'package:gamequizzapp/src/http/webclients/user_webclient.dart';
import 'package:gamequizzapp/src/screens/category_screen.dart';
import 'package:gamequizzapp/src/screens/login_screen.dart';

class ValidationToken{

  static final LoginDAO dao = LoginDAO();
  static final LoginWebClient loginWebClient = LoginWebClient();
  static final UserWebClient userWebClient = UserWebClient();

  static Future<String> getToken(BuildContext context, String username, String password) async {

    String tokenAutentication = '';

    await dao.findTokenLocal().then((tokenLocal) async {
      if(tokenLocal.isNotEmpty){
        debugPrint('ENCONTROU TOKEN LOCAL');
        await dao.findTokenLocal().then((token) async {

          int tokenValidity = getTokenLocalValidity(token);

          if(tokenValidity <= 60){
            debugPrint('TOKEN VÁLIDO');
            String accessTokenLocal = token[0];
            tokenAutentication = accessTokenLocal;
          } else{
            debugPrint('TOKEN INVÁLIDO');
            loginWebClient.getToken(username, password).then((newToken){
              tokenAutentication = newToken;
              dao.deleteTokenLocal();
              dao.insertTokenLocal(newToken, username, password, 3600000, DateTime.now().toString());
            });
          }
        });
      }
      else{
        debugPrint('NENHUM TOKEN LOCAL SALVO');
        loginWebClient.getToken(username, password).then((newToken){
          tokenAutentication = newToken;
          dao.insertTokenLocal(newToken, username, password, 3600000, DateTime.now().toString());

          userWebClient.getUserByUsername(username, newToken).then((user) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
                CategoryScreen(username, password, user.idUser, user)));
          });
        });
      }
    });
    return tokenAutentication;
  }

  static int getTokenLocalValidity(List<String> token) {
    String dateSaved = token[2];
    String expiresIn = token[1];
    double convertExpiresIn = int.parse(expiresIn) / (1000 * 60);
    int difference = DateTime.now().difference(DateTime.parse(dateSaved)).inMinutes;
    // debugPrint('DATA GRAVADA: ' + token[2]);
    // debugPrint('DIF: $difference');
    // debugPrint('EXPIRES: $convertExpiresIn');
    return difference;
  }

}