import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:gamequizzapp/src/http/webclients/webclient.dart';
import 'package:gamequizzapp/src/models/question.dart';

class QuestionWebClient {

  Future<List<Question>> getQuestionsByCategory(String category, String token) async {
    final Response response = await client.get(Uri.parse('$baseAPIUrl/questions/category/${category.toLowerCase()}'),
        headers: {"Accept": "application/json; charset=UTF-8", "Authorization": "Bearer $token"});

    final List<dynamic> json = jsonDecode(response.body);
    List<Question> questionList = json.map((dynamic json) => Question.fromJson(json)).toList();

    //Embaralha lista
    questionList.shuffle();

    return questionList;
  }

  Future<List<Question>> getAllQuestions(String token) async {
    final Response response = await client.get(Uri.parse('$baseAPIUrl/questions'),
        headers: {"Accept": "application/json; charset=UTF-8", "Authorization": "Bearer $token"});

    final List<dynamic> json = jsonDecode(response.body);
    List<Question> questionList = json.map((dynamic json) => Question.fromJson(json)).toList();

    return questionList;
  }

}
