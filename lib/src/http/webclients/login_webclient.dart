import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:gamequizzapp/src/http/webclients/webclient.dart';

class LoginWebClient {

  Future<String?> getToken(String username, String password) async {
    final Response response =
    await client.post(Uri.parse('$baseAPIUrl/login'), headers: {
      "Accept": "application/json; charset=UTF-8"
    },
        body: jsonEncode({
          "username": username,
          "password": password,
        })
    );

    String? responseToken;

    if(response.statusCode == 200){
      responseToken = response.body.substring(10, response.body.length -2);
    }

    return responseToken;
  }

}
