import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gamequizzapp/src/models/user.dart';
import 'package:http/http.dart';
import 'package:gamequizzapp/src/http/webclients/webclient.dart';

class UserWebClient {

  Future<User> getUserByUsername(String username, String token) async {
    final Response response = await client.get(Uri.parse('$baseAPIUrl/users/username/$username'),
        headers: {"Accept": "application/json; charset=UTF-8", "Authorization": "Bearer $token"});

    debugPrint("BODY >> ${response.body}");

    final Map<String, dynamic> json = jsonDecode(response.body);
    return User.fromJson(json);
  }

  Future<int> updateQuestionsAnswered(String token, String idUser, String idQuestion) async {
    final Response response = await client.put(
        Uri.parse("$baseAPIUrl/users/$idUser/question/$idQuestion"),
        headers: {
          "Content-type" : "application/json",
          "Authorization": "Bearer $token"
        });
    return response.statusCode;
  }

  Future<int> createUser(String name, String email, String username, String password, String type, String idLevel) async {
    final Response response = await client.post(
        Uri.parse('$baseAPIUrl/users/public/create'),
        headers: {
          "Content-type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "username": username,
          "password": password,
          "type": type,
          "idLevel": idLevel
        })
    );

    switch (response.statusCode) {
      case 201:
        return response.statusCode;
      case 400:
        return response.statusCode;
      case 404:
        throw HttpException(
            '${response.statusCode.toString()} - Server not found');
      case 409:
        return response.statusCode;
      default:
        throw HttpException(response.statusCode.toString());
    }
  }

}
