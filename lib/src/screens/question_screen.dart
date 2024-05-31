import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:gamequizzapp/src/constants/custom_layout.dart';
import 'package:gamequizzapp/src/http/webclients/question_webclient.dart';
import 'package:gamequizzapp/src/http/webclients/user_webclient.dart';
import 'package:gamequizzapp/src/models/category.dart';
import 'package:gamequizzapp/src/models/question.dart';
import 'package:gamequizzapp/src/screens/correct_answer_screen.dart';
import 'package:gamequizzapp/src/service/validation_token.dart';
import 'package:gamequizzapp/src/widgets/dialog_message_widget.dart';
import 'package:gamequizzapp/src/widgets/list_tile_widget.dart';
import 'package:gamequizzapp/src/widgets/progress_circular_widget.dart';

class QuestionScreen extends StatefulWidget {

  final Category category;
  final String pathImage;
  final String descNivel;
  final List<Question> listQuestion;
  final String username;
  final String password;
  final String idUser;

  const QuestionScreen(this.category, this.pathImage, this.descNivel, this.listQuestion, this.username, this.password, this.idUser, {super.key});


  @override
  State<StatefulWidget> createState() {
    return QuestionScreenState();
  }
}

class QuestionScreenState extends State<QuestionScreen> with SingleTickerProviderStateMixin {

  final UserWebClient userWebClient = UserWebClient();
  String selectedAlternative = '';
  // String descNivel = '';
  int selectedItem = 4;
  int _counter = 10;

  @override
  void initState() {
    super.initState();
    _incrementCounter();
  }

  void _incrementCounter() {
    Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if(_counter > 0){
          _counter--;
        }
        else{
          openCorrectAnswerScreen(
              context,
              "assets/images/time_finished.png",
              "Tempo Esgotado",
              Colors.orange,
              widget.category,
              widget.descNivel,
              widget.username,
              widget.password,
              widget.idUser
          );
        }
      });
    });
  }

  bool answerQuestion(String correctAnswer, String alternative, String idQuestion){
    if(correctAnswer == alternative){

      try {
        ValidationToken.getToken(context, widget.username, widget.password).then((token) async {
          if(token != null){
            userWebClient.updateQuestionsAnswered(token, widget.idUser, idQuestion);
          }
        });
      } on Exception {}

      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: SizedBox(
                    height: 20,
                    width: 20,
                    child: Image.asset(widget.pathImage)
                )
              ),
              Text(widget.category.desc),
            ],
          ),
          // title: Text(widget.category.desc),
            backgroundColor: Colors.grey,
            // toolbarHeight: 150,
            // shadowColor: Colors.transparent,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
          child: Center(
            child: Column(
              children: [
                Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text('Nível: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        Text(widget.descNivel, style: const TextStyle(fontSize: 16, color: Colors.white))
                      ],
                    )
                ),
                CustomLayout.vpad_8,
                Column(
                  children: [
                    Container(
                      // padding: EdgeInsets.all(70),
                        height: 150,
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
                                color: Colors.grey ,
                              )
                            ]
                        ),
                        child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16, right: 16),
                              child: Text(widget.listQuestion[0].title, style: const TextStyle(fontSize: 20)),
                            )
                        )
                    ),
                    CustomLayout.vpad_16,
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.listQuestion[0].alternatives.length,
                      itemBuilder: (context, index) {
                        return ListTileWidget(
                          titleColor: Colors.white,
                          cardColor: index == selectedItem ? Colors.black12 : Colors.black,
                          title: widget.listQuestion[0].alternatives[index],
                          action: () {
                            selectedAlternative = widget.listQuestion[0].alternatives[index];
                            setState(() {
                              selectedItem = index;
                            });
                          },
                        );
                      },
                    )
                  ],
                )
              ],
            ),
          )
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        // isExtended: true
        child: Text(
            _counter.toString(),
            style: const TextStyle(color: Colors.black, fontSize: 20)),
        backgroundColor: Colors.yellow,
        onPressed: () {

        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 8, right: 8),
        child: ElevatedButton(
          onPressed: () {
            if(answerQuestion(widget.listQuestion[0].answer, selectedAlternative, widget.listQuestion[0].idQuestion)){
              openCorrectAnswerScreen(
                  context,
                  "assets/images/correct.png",
                  "Resposta Correta",
                  Colors.green,
                  widget.category,
                  widget.descNivel,
                  widget.username,
                  widget.password,
                  widget.idUser
              );

              // const DialogMessageWidget(
              //   title: "Título teste",
              //   content: "conteúdo",
              //   image: "image",
              //   textButton: "texto do botao",
              // );
              // Fluttertoast.showToast(
              //   msg: "Resposta certa!",
              //   toastLength: Toast.LENGTH_SHORT,
              //   gravity: ToastGravity.CENTER,
              // );
            }
            else{
              openCorrectAnswerScreen(
                  context,
                  "assets/images/wrong.png",
                  "Resposta Errada",
                  Colors.red,
                  widget.category,
                  widget.descNivel,
                  widget.username,
                  widget.password,
                  widget.idUser
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
            // backgroundColor: MaterialStateProperty.all(Colors.red),
            backgroundColor: MaterialStateProperty.all(const Color(0xFF8B0000)),
          ),
          child: const Text(
            'Responder',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      )
    );
  }

  void openCorrectAnswerScreen(
      BuildContext context,
      String pathImage,
      String text,
      Color backGroundColor,
      Category category,
      String descNivel,
      String username,
      String password,
      String idUser
      ) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
        CorrectAnswerScreen(pathImage, text, backGroundColor, category, descNivel, username, password, idUser))
    );
  }

}
