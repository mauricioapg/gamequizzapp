import 'package:flutter/material.dart';
import 'package:gamequizzapp/src/http/webclients/category_webclient.dart';
import 'package:gamequizzapp/src/http/webclients/question_webclient.dart';
import 'package:gamequizzapp/src/http/webclients/user_webclient.dart';
import 'package:gamequizzapp/src/models/category.dart';
import 'package:gamequizzapp/src/models/question.dart';
import 'package:gamequizzapp/src/models/user.dart';
import 'package:gamequizzapp/src/screens/question_screen.dart';
import 'package:gamequizzapp/src/service/validation_token.dart';
import 'package:gamequizzapp/src/widgets/list_tile_widget.dart';
import 'package:gamequizzapp/src/widgets/progress_circular_widget.dart';

class CategoryScreen extends StatefulWidget {

  final List<Question> allQuestionsList;
  final String username;
  final String password;
  final String idUser;
  final User userLogged;

  const CategoryScreen(this.allQuestionsList, this.username, this.password, this.idUser, this.userLogged, {Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return CategoryScreenState();
  }
}

class CategoryScreenState extends State<CategoryScreen> {

  final List<Category> _categoryList = [];
  List<Question> questionsByCategory = [];
  final CategoryWebClient categoryWebClient = CategoryWebClient();
  final QuestionWebClient questionWebClient = QuestionWebClient();
  final UserWebClient userWebClient = UserWebClient();
  late Future _future;

  @override
  void initState() {
    super.initState();
    _future = _getCategoryList();
  }

  Future<List<Question>> _getQuestionsByCategory(String desc) async{
    debugPrint("allQuestionsList recebido >> " + widget.allQuestionsList.toString());
    try{
      await ValidationToken.getToken(context, widget.username, widget.password).then((token) async{
        for (var question in widget.allQuestionsList){
          if(question.category == desc){
            await userWebClient.getUserByUsername(widget.username, token!).then((user) {
              if(!user.questionsAnswered.contains(question.idQuestion)){
                setState(() {
                  questionsByCategory.add(question);
                });
              }
            });
          }
        }
      });
    }
    on Exception {}

    questionsByCategory.shuffle(); //Embaralha lista

    debugPrint("questionsByCategory >> " + questionsByCategory.toString());

    return questionsByCategory;
  }

  // List<Question> _getQuestionsByCategory(String desc){
  //   debugPrint("desc category >> " + desc);
  //   try{
  //     ValidationToken.getToken(context, widget.username, widget.password).then((token) async{
  //       for (var question in widget.allQuestionsList){
  //         debugPrint("cat >> " + question.category);
  //         if(question.category == desc){
  //           await userWebClient.getUserByUsername(widget.username, token!).then((user) {
  //             if(!user.questionsAnswered.contains(question.idQuestion)){
  //               setState(() {
  //                 questionsByCategory.add(question);
  //               });
  //             }
  //           });
  //         }
  //       }
  //     });
  //   }
  //   on Exception {}
  //
  //   questionsByCategory.shuffle(); //Embaralha lista
  //
  //   debugPrint("questionsByCategory >> " + questionsByCategory.toString());
  //
  //   return questionsByCategory;
  // }

  Future<List<Category>> _getCategoryList() async {
    try {
      await ValidationToken.getToken(context, widget.username, widget.password).then((token) async{
        if(token != null){
          await categoryWebClient.getCategoryiesList(token).then((categories) {
            for(int i=0; i < categories.length; i++){
              setState(() {
                _categoryList.add(categories[i]);
              });
            }
          });
        }
      });
    } on Exception {}
    return _categoryList;
  }

  String chooseLocationImage(String descCategory){
    String pathImage = '';
    switch(descCategory){
      case 'Geografia':
        pathImage = 'assets/images/geografia.png';
        break;
      case 'História':
        pathImage = 'assets/images/historia.png';
        break;
      case 'Matemática':
        pathImage = 'assets/images/matematica.png';
        break;
      case 'Conhecimentos Gerais':
        pathImage = 'assets/images/conhecimentos_gerais.png';
        break;
      case 'Literatura':
        pathImage = 'assets/images/literatura.png';
        break;
      case 'Música':
        pathImage = 'assets/images/musica.png';
        break;
      case 'Filmes e Séries':
        pathImage = 'assets/images/filmes_series.png';
        break;
      case 'Biologia':
        pathImage = 'assets/images/biologia.png';
        break;
      case 'Política':
        pathImage = 'assets/images/politica.png';
        break;
      case 'Quadrinhos':
        pathImage = 'assets/images/quadrinhos.png';
        break;
      case 'Esportes':
        pathImage = 'assets/images/esportes.png';
        break;
    }
    return pathImage;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        // backgroundColor: Colors.indigoAccent,
        appBar: AppBar(
          title: const Text('Categorias', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.black,
            actions: <Widget> [
              IconButton(
                icon: const Icon(Icons.account_circle, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
            // toolbarHeight: 150,
            // shadowColor: Colors.transparent,
            automaticallyImplyLeading: false),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 24, left: 8, right: 8),
          child: Center(
            child: Column(
              children: [
                FutureBuilder(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        debugPrint('ERRO: ${snapshot.stackTrace}');
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Text(
                              'Erro ao buscar dados: ${snapshot.error}',
                              style:
                              const TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ),
                        );
                      } else if (snapshot.hasData) {
                        return
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: _categoryList.isNotEmpty ?
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _categoryList.length,
                              itemBuilder: (context, index) {
                                return ListTileWidget(
                                  titleColor: Colors.black,
                                  cardColor: Colors.black12,
                                  locationImage: chooseLocationImage(_categoryList[index].desc),
                                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                                  title: _categoryList[index].desc,
                                  action: () {
                                    _getQuestionsByCategory(_categoryList[index].desc).then((list){
                                      if(list.isNotEmpty){
                                        debugPrint("chamando tela da pergunta");
                                        openQuestionScreen(
                                            context,
                                            _categoryList[index],
                                            chooseLocationImage(_categoryList[index].desc),
                                            _categoryList[index].desc,
                                            list,
                                            widget.username,
                                            widget.password,
                                            widget.idUser,
                                            widget.userLogged
                                        );
                                      }
                                      else{
                                        debugPrint('IS EMPTY: ');
                                      }
                                    });
                                    // if(){
                                    //   debugPrint("chamando tela da pergunta");
                                    //   openQuestionScreen(
                                    //       context,
                                    //       _categoryList[index],
                                    //       chooseLocationImage(_categoryList[index].desc),
                                    //       _categoryList[index].desc,
                                    //       _getQuestionsByCategory(_categoryList[index].desc),
                                    //       widget.username,
                                    //       widget.password,
                                    //       widget.idUser,
                                    //       widget.userLogged
                                    //   );
                                    // }
                                    // else{
                                    //   debugPrint('IS EMPTY: ');
                                    // }
                                  },
                                );
                              },
                            ) : const Text(
                              'Nenhum resultado encontrado',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          );
                      }
                    }
                    return const Center(
                      child: ProgressCircularWidget(mensagem: '', cor: Colors.blue),
                    );
                  },
                )
              ],
            ),
          )
        ),
      ),
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
      String idUser,
      User userLogged
      ) {
    Navigator.push(context, MaterialPageRoute(builder: (context) =>
        QuestionScreen(category, pathImage, listQuestion, username, password, idUser, userLogged)));
  }

}
