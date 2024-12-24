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
import 'package:gamequizzapp/src/widgets/progress_circular_widget.dart';

class AnswerScreen extends StatefulWidget {

  final String pathImage;
  final String text;
  final Color backGroundColor;
  final Category category;
  final String username;
  final String password;
  final String idUser;
  final User userLogged;
  final String idQuestionAnswered;

  const AnswerScreen(
      this.pathImage,
      this.text,
      this.backGroundColor,
      this.category,
      this.username,
      this.password,
      this.idUser,
      this.userLogged,
      this.idQuestionAnswered,
      {super.key});

  @override
  State<StatefulWidget> createState() => AnswerScreenState();
}

class AnswerScreenState extends State<AnswerScreen> {

  final QuestionWebClient questionWebClient = QuestionWebClient();
  final UserWebClient userWebClient = UserWebClient();
  Question? questionFound;
  bool waiting = false;

  @override
  void initState() {
    super.initState();
  }

  startTimer() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, _goToNextScreen);
  }

  Future<Question?> _getOneRandomQuestion(String username, String password, String idCategory, String idQuestionIgnore) async {
    try {
      final token = await ValidationToken.getToken(context, username, password);
      final question = await questionWebClient.getOneQuestion(token, idCategory, widget.idUser, idQuestionIgnore);
      return question;
    } catch (e) {
      debugPrint('Erro ao obter question: $e');
      return null;
    }
  }

  void _goToNextScreen() async {
    try {
          // Obter a questão de forma assíncrona
          questionFound = await _getOneRandomQuestion(
              widget.username,
              widget.password,
              widget.category.idCategory,
              widget.idQuestionAnswered
          );

          if(questionFound != null){

            // Verificar se a questão foi encontrada antes de continuar
            openQuestionScreen(
                  context,
                  widget.category,
                  widget.category.image,
                  questionFound!,
                  widget.username,
                  widget.password,
                  widget.idUser,
                  widget.userLogged
              );
          }
          else{
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
                CategoryScreen(widget.username, widget.password, widget.idUser, widget.userLogged)));
          }
    } on Exception {}
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
                        height: constraints.maxHeight * 0.085,
                        child: ElevatedButton(
                          onPressed: (){
                            setState(() {
                              waiting = !waiting;
                            });
                            _goToNextScreen();
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                          ),
                          child: waiting ? ProgressCircularWidget(
                            mensagem: '',
                            cor: widget.backGroundColor,
                            width: 16,
                            height: 16,
                          ): Text("Próxima pergunta", style: TextStyle(color: widget.backGroundColor, fontSize: 18)),
                        ),
                      ),
                      CustomLayout.columnSpacer(constraints.maxHeight * 0.02),
                      SizedBox(
                        width: constraints.maxWidth * 0.9,
                        height: constraints.maxHeight * 0.085,
                        child: ElevatedButton(
                          onPressed: (){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
                                CategoryScreen(widget.username, widget.password, widget.userLogged!.idUser, widget.userLogged)));
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
      Question chooseQuestion,
      String username,
      String password,
      String idUser,
      User userLogged,
      ) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
        QuestionScreen(category, pathImage, chooseQuestion, username, password, idUser, userLogged))
    );
  }

}
