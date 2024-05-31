import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:gamequizzapp/src/http/webclients/webclient.dart';
import 'package:gamequizzapp/src/models/category.dart';

class CategoryWebClient {

  Future<List<Category>> getCategoryiesList(String token) async {
    final Response response =
    await client.get(Uri.parse('$baseAPIUrl/categories'), headers: {
      "Accept": "application/json; charset=UTF-8",
      "Authorization": "Bearer $token"
    });

    final List<dynamic> json = jsonDecode(response.body);
    final List<Category> categorylList = json.map((dynamic json) =>
        Category.fromJson(json)).toList();
    return categorylList;
  }
}
