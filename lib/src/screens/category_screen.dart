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

  final String username;
  final String password;
  final String idUser;
  final User userLogged;

  const CategoryScreen(this.username, this.password, this.idUser, this.userLogged, {Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return CategoryScreenState();
  }
}

class CategoryScreenState extends State<CategoryScreen> {

  final List<Category> _categoryList = [];
  Question? questionFound;
  final CategoryWebClient categoryWebClient = CategoryWebClient();
  final QuestionWebClient questionWebClient = QuestionWebClient();
  final UserWebClient userWebClient = UserWebClient();
  late Future _futureCategoryList;

  @override
  void initState() {
    super.initState();
    _futureCategoryList = _getCategoryList();
  }

  Future<Question?> _getOneRandomQuestion(String username, String password, String idCategory) async {
    try {
      final token = await ValidationToken.getToken(context, username, password);
      final question = await questionWebClient.getOneQuestion(token, idCategory, widget.userLogged.idUser, null);
      return question;
    } catch (e) {
      debugPrint('Erro ao obter question: $e');
      return null;
    }
  }

  Future<List<Category>> _getCategoryList() async {
    try {
      await ValidationToken.getToken(context, widget.username, widget.password).then((token) async{
        await categoryWebClient.getCategoryiesList(token).then((categories) {
          for(int i=0; i < categories.length; i++){
            setState(() {
              _categoryList.add(categories[i]);
            });
          }
        });
            });
    } on Exception {}
    return _categoryList;
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
                  future: _futureCategoryList,
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
                                  locationImage: _categoryList[index].image,
                                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                                  title: _categoryList[index].desc,
                                  action: () async {
                                    // Obter a questão de forma assíncrona
                                    questionFound = await _getOneRandomQuestion(
                                      widget.username,
                                      widget.password,
                                      _categoryList[index].idCategory,
                                    );

                                    // Verificar se a questão foi encontrada antes de continuar
                                    if (questionFound != null) {
                                      openQuestionScreen(
                                        context,
                                        _categoryList[index],
                                        _categoryList[index].image,
                                        _categoryList[index].desc,
                                        questionFound!,
                                        widget.username,
                                        widget.password,
                                        widget.idUser,
                                        widget.userLogged,
                                      );
                                    } else {
                                      debugPrint("No question found.");
                                    }
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
      Question chooseQuestion,
      String username,
      String password,
      String idUser,
      User userLogged
      ) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
        QuestionScreen(category, pathImage, chooseQuestion, username, password, idUser, userLogged)));
  }

}
