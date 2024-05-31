import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gamequizzapp/src/http/webclients/user_webclient.dart';
import 'package:gamequizzapp/src/widgets/dialog_message_widget.dart';

import '../constants/custom_layout.dart';
import '../http/webclients/level_webclient.dart';
import '../widgets/text_with_action_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {

  final UserWebClient userWebClient = UserWebClient();
  final LevelWebClient levelWebClient = LevelWebClient();
  final TextEditingController _controllerNameField = TextEditingController();
  final TextEditingController _controllerEmailField = TextEditingController();
  final TextEditingController _controllerUsernameField = TextEditingController();
  final TextEditingController _controllerPasswordField = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _register(String name, String email, String username, String password, String type, String descLevel) async {
    try {
      await levelWebClient.getLevelByDesc(descLevel).then((Level) async {
        await userWebClient.createUser(name, email, username, password, type, Level.idLevel).then((statusCode) {
          if(statusCode == 201){
            debugPrint("usuário criado com sucesso");
            DialogMessageWidget(
              title: "teste",
              content: "conteudo",
              image: "",
              textButton: "clicar",
            );
          }
          else{
            debugPrint("Erro ao criar usuário");
            DialogMessageWidget(
              title: "erro",
              content: "conteudo erro",
              image: "",
              textButton: "clicar",
            );
          }
        });
      });
    } on Exception {}
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
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
                      controllerField: _controllerNameField..text,
                      hintTextField: 'Informe seu nome',
                      // iconButton: const Icon(Icons.arrow_forward, color: Colors.white),
                      typeValidate: 'name',
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
                      controllerField: _controllerEmailField..text,
                      hintTextField: 'Informe seu email',
                      // iconButton: const Icon(Icons.arrow_forward, color: Colors.white),
                      typeValidate: 'email',
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
                      controllerField: _controllerUsernameField..text,
                      hintTextField: 'Informe seu usuário',
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
                      hintTextField: 'Informe sua senha',
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
                        _register(
                            _controllerNameField.text,
                            _controllerEmailField.text,
                            _controllerUsernameField.text,
                            _controllerPasswordField.text,
                          "USER",
                          "iniciante"
                        );
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(Colors.black),
                      ),
                      child: const Text("Cadastrar", style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  )
                ],
              );
            }
        )
      );
  }

}
