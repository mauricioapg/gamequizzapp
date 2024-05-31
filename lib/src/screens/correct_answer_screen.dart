import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gamequizzapp/src/http/webclients/question_webclient.dart';
import 'package:gamequizzapp/src/models/question.dart';
import 'package:gamequizzapp/src/models/category.dart';
import 'package:gamequizzapp/src/screens/category_screen.dart';
import 'package:gamequizzapp/src/screens/question_screen.dart';
import 'package:gamequizzapp/src/service/validation_token.dart';

class CorrectAnswerScreen extends StatefulWidget {

  final String pathImage;
  final String text;
  final Color backGroundColor;
  final Category category;
  final String descNivel;
  final String username;
  final String password;
  final String idUser;

  const CorrectAnswerScreen(
      this.pathImage,
      this.text,
      this.backGroundColor,
      this.category,
      this.descNivel,
      this.username,
      this.password,
      this.idUser,
      {super.key});

  @override
  State<StatefulWidget> createState() => CorrectAnswerScreenState();
}

class CorrectAnswerScreenState extends State<CorrectAnswerScreen> {

  final QuestionWebClient questionWebClient = QuestionWebClient();
  List<Question> allQuestionsList = [];

  @override
  void initState() {
    super.initState();

    _getAllQuestions();
    startTimer();
  }

  startTimer() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, route);
  }

  route() {
    _getAllQuestions();
    if(allQuestionsList.isNotEmpty){
      openQuestionScreen(context, widget.category, widget.pathImage, widget.descNivel, allQuestionsList, widget.username, widget.password, widget.idUser);
    }
    else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
          CategoryScreen(allQuestionsList, widget.username, widget.password, widget.idUser)));
    }
  }

  Future<List<Question>> _getAllQuestions() async {
    try {
      ValidationToken.getToken(context, widget.username, widget.password).then((token) async {
        if(token != null){
          await questionWebClient.getAllQuestions(token).then((questions) {
            for(int i=0; i < questions.length; i++){
              if(questions[i].category == widget.category.idCategory){
                setState(() {
                  allQuestionsList.add(questions[i]);
                });
              }
            }
          });
        }
      });
    } on Exception {}

    allQuestionsList.shuffle();

    return allQuestionsList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: widget.backGroundColor,
        body:
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 140,
                    child: Image.asset(widget.pathImage),
                  ),
                  const Text(""),
                  Text(widget.text, style: const TextStyle(color: Colors.white, fontSize: 30))
                ],
              )
            )
      );
  }

  void openQuestionScreen(
      BuildContext context,
      Category category,
      String pathImage,
      String descNivel,
      List<Question> listQuestion,
      String username,
      String password,
      String idUser
      ) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
        QuestionScreen(category, pathImage, descNivel, listQuestion, username, password, idUser))
    );
  }

}
