import 'dart:convert';

import 'package:http/http.dart';
import 'package:gamequizzapp/src/http/webclients/webclient.dart';

import '../../models/level.dart';

class LevelWebClient {

  Future<Level> getLevelByDesc(String desc) async {
    final Response response =
    await client.get(Uri.parse('$baseAPIUrl/levels/public/$desc'), headers: {
      "Accept": "application/json; charset=UTF-8"
    });

    final Map<String, dynamic> json = jsonDecode(response.body);
    return Level.fromJson(json);
  }
}
