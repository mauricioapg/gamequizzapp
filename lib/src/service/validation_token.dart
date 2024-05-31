import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../http/webclients/login_webclient.dart';

class ValidationToken{

  static final LoginWebClient loginWebClient = LoginWebClient();

  static Future<String?> getToken(BuildContext context, String username, String password) async {

    String? tokenAutentication = '';

    await loginWebClient.getToken(username, password).then((token) async {
      tokenAutentication = token;
    });
    return tokenAutentication;
  }

}