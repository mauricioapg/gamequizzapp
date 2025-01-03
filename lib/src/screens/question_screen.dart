import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gamequizzapp/src/constants/custom_layout.dart';
import 'package:gamequizzapp/src/http/webclients/user_webclient.dart';
import 'package:gamequizzapp/src/models/category.dart';
import 'package:gamequizzapp/src/models/question.dart';
import 'package:gamequizzapp/src/models/user.dart';
import 'package:gamequizzapp/src/screens/answer_screen.dart';
import 'package:gamequizzapp/src/service/validation_token.dart';
import 'package:gamequizzapp/src/widgets/dialog_message_widget.dart';
import 'package:gamequizzapp/src/widgets/list_tile_widget.dart';

class QuestionScreen extends StatefulWidget {
  final Category category;
  final String pathImage;
  final Question chooseQuestion;
  final String username;
  final String password;
  final String idUser;
  final User userLogged;

  const QuestionScreen(
      this.category,
      this.pathImage,
      this.chooseQuestion,
      this.username,
      this.password,
      this.idUser,
      this.userLogged, {
        super.key,
      });

  @override
  State<StatefulWidget> createState() {
    return QuestionScreenState();
  }
}

class QuestionScreenState extends State<QuestionScreen> with SingleTickerProviderStateMixin {
  final UserWebClient userWebClient = UserWebClient();
  String selectedAlternative = '';
  int selectedItem = 4;
  int _counter = 100;

  @override
  void initState() {
    super.initState();
    _incrementCounter();
  }

  void _incrementCounter() {
    Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          openAnswerScreen(
            context,
            "assets/images/time_finished.png",
            "Tempo Esgotado",
            Colors.orange,
            widget.category,
            widget.username,
            widget.password,
            widget.idUser,
            widget.userLogged,
            widget.chooseQuestion.idQuestion,
          );
        }
      });
    });
  }

  bool answerQuestion(String correctAnswer, String alternative, String idQuestion) {
    if (correctAnswer == alternative) {
      try {
        ValidationToken.getToken(context, widget.username, widget.password).then((token) async {
          if (token != null) {
            userWebClient.updateQuestionsAnswered(token, widget.idUser, idQuestion);
          }
        });
      } on Exception catch (e) {
        debugPrint("Exception encontrada aqui >> " + e.toString());
      }
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: SizedBox(
                height: 20,
                width: 20,
                child: Image.memory(base64Decode(widget.pathImage)),
              ),
            ),
            Text(widget.category.desc, style: const TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('Nível: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                      Text(widget.chooseQuestion.level, style: const TextStyle(fontSize: 16, color: Colors.black)),
                    ],
                  ),
                ),
                CustomLayout.vpad_8,
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: constraints.maxHeight * 0.2,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                            )
                          ],
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Text(widget.chooseQuestion.title, style: const TextStyle(fontSize: 20)),
                          ),
                        ),
                      ),
                      CustomLayout.vpad_16,
                      Expanded(
                        child: ListView.builder(
                          itemCount: widget.chooseQuestion.alternatives.length,
                          itemBuilder: (context, index) {
                            return ListTileWidget(
                              titleColor: Colors.black,
                              cardColor: index == selectedItem ? Colors.blue : Colors.black12,
                              title: widget.chooseQuestion.alternatives[index],
                              action: () {
                                selectedAlternative = widget.chooseQuestion.alternatives[index];
                                setState(() {
                                  selectedItem = index;
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        onPressed: () {},
        child: Text(
          _counter.toString(),
          style: const TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 8, right: 8),
        child: ElevatedButton(
          onPressed: () {
            if (answerQuestion(widget.chooseQuestion.answer, selectedAlternative, widget.chooseQuestion.idQuestion)) {
              openAnswerScreen(
                context,
                "assets/images/correct.png",
                "Resposta Correta",
                Colors.green,
                widget.category,
                widget.username,
                widget.password,
                widget.idUser,
                widget.userLogged,
                widget.chooseQuestion.idQuestion,
              );
            } else {
              openAnswerScreen(
                context,
                "assets/images/wrong.png",
                "Resposta Errada",
                Colors.red,
                widget.category,
                widget.username,
                widget.password,
                widget.idUser,
                widget.userLogged,
                widget.chooseQuestion.idQuestion,
              );
            }
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
            ),
            padding: MaterialStateProperty.all(const EdgeInsets.all(20.0)),
            backgroundColor: MaterialStateProperty.all(const Color(0xFF8B0000)),
          ),
          child: const Text(
            'Responder',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void openAnswerScreen(
      BuildContext context,
      String pathImage,
      String text,
      Color backGroundColor,
      Category category,
      String username,
      String password,
      String idUser,
      User userLogged,
      String idQuestionAnswered,
      ) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AnswerScreen(
          pathImage,
          text,
          backGroundColor,
          category,
          username,
          password,
          idUser,
          userLogged,
          idQuestionAnswered,
        ),
      ),
    );
  }
}
