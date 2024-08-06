import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:gamequizzapp/src/http/webclients/webclient.dart';

import '../../models/login.dart';

class LoginWebClient {

  // Future<String?> getToken(String username, String password) async {
  //   final Response response =
  //   await client.post(Uri.parse('$baseAPIUrl/login'), headers: {
  //     "Accept": "application/json; charset=UTF-8"
  //   },
  //       body: jsonEncode({
  //         "username": username,
  //         "password": password,
  //       })
  //   );
  //
  //   String? responseToken;
  //
  //   if(response.statusCode == 200){
  //     responseToken = response.body.substring(10, response.body.length -2);
  //   }
  //
  //   return responseToken;
  // }

  Future<dynamic?> getToken(String username, String password) async {
    final Response response =
    await client.post(Uri.parse('$baseAPIUrl/login'), headers: {
      "Content-type": "application/json"
    },
        body: jsonEncode({
          "username": username,
          "password": password,
        })
    );

    String? responseToken;

    Map<String, dynamic> json = jsonDecode(response.body);

    if(response.statusCode == 200){

      //GRAVAR TOKEN NA BASE DE DADOS LOCAL

      debugPrint("response >> " + Login.fromJson(json).token);
      responseToken = response.body.substring(10, response.body.length -2);
    }

    return responseToken;
  }

}
