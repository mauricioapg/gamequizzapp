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

  Future<Question> getOneQuestion(String token, String idCategory, String idUser, String? idQuestionIgnore) async {
    // Construir a URL com o parâmetro opcional
    final Uri uri = Uri.parse('$baseAPIUrl/questions/category/$idCategory/user/$idUser').replace(
      queryParameters: idQuestionIgnore != null ? {'idQuestionIgnore': idQuestionIgnore} : null,
    );

    // Fazer a requisição
    final Response response = await client.get(
      uri,
      headers: {
        "Accept": "application/json; charset=UTF-8",
        "Authorization": "Bearer $token",
      },
    );

    // Processar a resposta
    final dynamic json = jsonDecode(response.body);

    // Mapear a resposta para o modelo Question
    Question question = Question.fromJson(json);

    return question;
  }


}
