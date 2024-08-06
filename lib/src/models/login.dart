class Login {
  final String token;

  Login(this.token);

  Login.fromJson(Map<String, dynamic> json)
      : token = json['token'];

  Map<String, dynamic> toJson() => {
    'token': token
  };

  Map<String, dynamic> toMap() {
    return {
      'token': token
    };
  }

  @override
  String toString() {
    return 'TOKEN: $token';
  }
}
