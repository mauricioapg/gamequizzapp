class Question {
  final String idQuestion;
  final String title;
  final List<dynamic> alternatives;
  final String answer;
  final dynamic level;
  final dynamic category;

  Question(this.idQuestion, this.title, this.alternatives, this.answer, this.level, this.category);

  Question.fromJson(Map<String, dynamic> json)
      : idQuestion = json['idQuestion'],
        title = json['title'],
        category = json['category'],
        level = json['level'],
        alternatives = json['alternatives'],
        answer = json['answer'];



  Map<String, dynamic> toJson() => {
    'idQuestion': idQuestion,
    'title': title,
    'category': category,
    'level': level,
    'alternatives': alternatives,
    'answer': answer,
  };

  Map<String, dynamic> toMap() {
    return {
      'idQuestion': idQuestion,
      'title': title,
      'alternatives': alternatives,
      'answer': answer,
      'level': level,
      'category': category
    };
  }

  @override
  String toString() {
    return 'Question{ID: $idQuestion  TÍTULO: $title ALTERNATIVAS: $alternatives ANSWER: $answer NÍVEL: $level}';
  }
}
