import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:gamequizzapp/src/http/webclients/question_webclient.dart';
import 'package:gamequizzapp/src/http/webclients/user_webclient.dart';
import 'package:gamequizzapp/src/models/question.dart';
import 'package:gamequizzapp/src/models/user.dart';
import 'package:gamequizzapp/src/screens/category_screen.dart';
import 'package:gamequizzapp/src/screens/register_screen.dart';
import 'package:gamequizzapp/src/service/validation_token.dart';
import 'package:gamequizzapp/src/widgets/progress_circular_widget.dart';

import '../constants/custom_layout.dart';
import '../widgets/dialog_message_widget.dart';
import '../widgets/text_with_action_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {

  final UserWebClient userWebClient = UserWebClient();
  final QuestionWebClient questionWebClient = QuestionWebClient();
  final TextEditingController _controllerUsernameField = TextEditingController();
  final TextEditingController _controllerPasswordField = TextEditingController();
  User? userLogged;
  List<Question> allQuestionsList = [];

  @override
  void initState() {
    super.initState();
  }

  Future<User?> _login(String username, String password) async {
    try {
      ValidationToken.getToken(context, username, password).then((token) async {
        if(token != null){
          await userWebClient.getUserByUsername(username, token).then((user) {
            setState(() {
              userLogged = user;
            });
          });

          if(userLogged != null){
            _getAllQuestions(username, password);
          }
        }
        else{
          showDialog(
            context: context,
            builder: (contextDialog) {
              return DialogMessageWidget(
                  image: 'assets/images/error.png',
                  textButton: 'OK',
                  title: 'Erro!',
                  content: 'Credenciais inválidas',
                  contentHeight: 80,
                  functionSecond: () => Navigator.pop(context)
              );
            },
          );
        }
      });
    } on Exception {}
    return userLogged;
  }

  Future<List<Question>> _getAllQuestions(String username, String password) async {
    try {
      ValidationToken.getToken(context, username, password).then((token) async {
        if(token != null){
          await questionWebClient.getAllQuestions(token).then((questions) {
            for(int i=0; i < questions.length; i++){
              setState(() {
                allQuestionsList.add(questions[i]);
              });
            }

            if(allQuestionsList.isNotEmpty){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
                  CategoryScreen(allQuestionsList, username, password, userLogged!.idUser, userLogged!)));
            }

          });
        }
      });
    } on Exception {}
    return allQuestionsList;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(
            builder: (_, constraints){
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: SizedBox(
                      height: 160,
                      child: Image.asset("assets/images/logo.png"),
                    ),
                  ),
                  CustomLayout.columnSpacer(constraints.maxHeight * 0.06),
                  SizedBox(
                    width: constraints.maxWidth * 0.9,
                    child: TextWithActionWidget(
                      controllerField: _controllerUsernameField..text,
                      hintTextField: 'Usuário',
                      // iconButton: const Icon(Icons.arrow_forward, color: Colors.white),
                      typeValidate: 'username',
                      sizeContainerTop: constraints.maxHeight * 0.025,
                      sizeContainerBottom: constraints.maxHeight * 0.025,
                      sizeContainerLeft: constraints.maxWidth * 0.06,
                      sizeContainerRigth: constraints.maxWidth * 0.06,
                    ),
                  ),
                  CustomLayout.columnSpacer(constraints.maxHeight * 0.02),
                  SizedBox(
                    width: constraints.maxWidth * 0.9,
                    child: TextWithActionWidget(
                      controllerField: _controllerPasswordField..text,
                      hintTextField: 'Senha',
                      // iconButton: const Icon(Icons.arrow_forward, color: Colors.white),
                      typeValidate: 'password',
                      sizeContainerTop: constraints.maxHeight * 0.025,
                      sizeContainerBottom: constraints.maxHeight * 0.025,
                      sizeContainerLeft: constraints.maxWidth * 0.06,
                      sizeContainerRigth: constraints.maxWidth * 0.06,
                    ),
                  ),
                  CustomLayout.columnSpacer(constraints.maxHeight * 0.04),
                  SizedBox(
                    width: constraints.maxWidth * 0.9,
                    height: constraints.maxHeight * 0.065,
                    child: ElevatedButton(
                      onPressed: (){
                        _login(_controllerUsernameField.text, _controllerPasswordField.text);
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(Colors.black),
                      ),
                      child: const Text("Entrar", style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                  CustomLayout.columnSpacer(constraints.maxHeight * 0.02),
                  SizedBox(
                    width: constraints.maxWidth * 0.9,
                    height: constraints.maxHeight * 0.065,
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            const RegisterScreen()));
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(Colors.black12),
                      ),
                      child: const Text("Cadastre-se", style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  )
                ],
              );
            }
        )
      );
  }

}
