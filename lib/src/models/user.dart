class User {
  final String idUser;
  final String name;
  final String email;
  final String username;
  final String password;
  final String type;
  final String idLevel;
  final List<dynamic> questionsAnswered;

  User(this.idUser, this.name, this.email, this.username, this.password, this.type, this.idLevel, this.questionsAnswered);

  User.fromJson(Map<String, dynamic> json)
      : idUser = json['idUser'],
        name = json['name'],
        email = json['email'],
        username = json['username'],
        password = json['password'],
        type = json['type'],
        idLevel = json['idLevel'],
        questionsAnswered = json['questionsAnswered'];



  Map<String, dynamic> toJson() => {
    'idUser': idUser,
    'name': name,
    'email': email,
    'username': username,
    'password': password,
    'type': type,
    'idLevel': idLevel,
    'questionsAnswered': questionsAnswered
  };

  Map<String, dynamic> toMap() {
    return {
      'idUser': idUser,
      'name': name,
      'email': email,
      'username': username,
      'password': password,
      'type': type,
      'idLevel': idLevel,
      'questionsAnswered': questionsAnswered
    };
  }

  @override
  String toString() {
    return 'User{ID: $idUser NAME: $name EMAIL: $email USERNAME: $username PASSWORD: $password TYPE: $type IDLEVEL: $idLevel QUESTIONSANSWERED: $questionsAnswered}';
  }
}
