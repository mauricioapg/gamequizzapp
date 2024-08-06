import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gamequizzapp/src/constants/custom_layout.dart';
import 'package:gamequizzapp/src/http/webclients/question_webclient.dart';
import 'package:gamequizzapp/src/http/webclients/user_webclient.dart';
import 'package:gamequizzapp/src/models/question.dart';
import 'package:gamequizzapp/src/models/category.dart';
import 'package:gamequizzapp/src/models/user.dart';
import 'package:gamequizzapp/src/screens/category_screen.dart';
import 'package:gamequizzapp/src/screens/question_screen.dart';
import 'package:gamequizzapp/src/service/validation_token.dart';

class AnswerScreen extends StatefulWidget {

  final String pathImage;
  final String text;
  final Color backGroundColor;
  final Category category;
  final String username;
  final String password;
  final String idUser;
  final User userLogged;

  const AnswerScreen(
      this.pathImage,
      this.text,
      this.backGroundColor,
      this.category,
      this.username,
      this.password,
      this.idUser,
      this.userLogged,
      {super.key});

  @override
  State<StatefulWidget> createState() => AnswerScreenState();
}

class AnswerScreenState extends State<AnswerScreen> {

  final QuestionWebClient questionWebClient = QuestionWebClient();
  final UserWebClient userWebClient = UserWebClient();
  List<Question> allQuestionsList = [];

  @override
  void initState() {
    super.initState();

    _getAllQuestions();
    // startTimer();
  }

  startTimer() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, route);
  }

  route() {
    _getAllQuestions();
    if(allQuestionsList.isNotEmpty){
      openQuestionScreen(context, widget.category, widget.pathImage, allQuestionsList, widget.username, widget.password, widget.idUser, widget.userLogged);
    }
    else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
          CategoryScreen(allQuestionsList, widget.username, widget.password, widget.idUser, widget.userLogged)));
    }
  }

  Future<List<Question>> _getAllQuestions() async {
    try {
      ValidationToken.getToken(context, widget.username, widget.password).then((token) async {
        if(token != null){
          await questionWebClient.getAllQuestions(token).then((questions) async {
            for(int i=0; i < questions.length; i++){
              if(questions[i].category == widget.category.desc){
                await userWebClient.getUserByUsername(widget.username, token).then((user) {
                  if(!user.questionsAnswered.contains(questions[i].idQuestion)){
                    setState(() {
                      allQuestionsList.add(questions[i]);
                    });
                  }
                });
              }
            }
          });
        }
      });
    } on Exception catch(e) {
      debugPrint("Exception encontrada >> " + e.toString());
    }

    allQuestionsList.shuffle();

    return allQuestionsList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: widget.backGroundColor,
        body: LayoutBuilder(
            builder: (_, constraints){
              return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 140,
                        child: Image.asset(widget.pathImage),
                      ),
                      CustomLayout.columnSpacer(constraints.maxHeight * 0.01),
                      Text(widget.text, style: const TextStyle(color: Colors.white, fontSize: 30)),
                      CustomLayout.columnSpacer(constraints.maxHeight * 0.04),
                      SizedBox(
                        width: constraints.maxWidth * 0.9,
                        height: constraints.maxHeight * 0.065,
                        child: ElevatedButton(
                          onPressed: (){
                            route();
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                          ),
                          child: Text("Próxima pergunta", style: TextStyle(color: widget.backGroundColor, fontSize: 18)),
                        ),
                      ),
                      CustomLayout.columnSpacer(constraints.maxHeight * 0.02),
                      SizedBox(
                        width: constraints.maxWidth * 0.9,
                        height: constraints.maxHeight * 0.065,
                        child: ElevatedButton(
                          onPressed: (){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
                                CategoryScreen(allQuestionsList, widget.username, widget.password, widget.userLogged!.idUser, widget.userLogged)));
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                          ),
                          child: Text("Ir para tela principal", style: TextStyle(color: widget.backGroundColor, fontSize: 18)),
                        ),
                      )
                    ],
                  )
              );
            }
        )
      );
  }

  void openQuestionScreen(
      BuildContext context,
      Category category,
      String pathImage,
      List<Question> listQuestion,
      String username,
      String password,
      String idUser,
      User userLogged,
      ) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
        QuestionScreen(category, pathImage, listQuestion, username, password, idUser, userLogged))
    );
  }

}
