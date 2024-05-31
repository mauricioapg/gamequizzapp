class Level {
  final String idLevel;
  final String desc;

  Level(this.idLevel, this.desc);

  Level.fromJson(Map<String, dynamic> json)
      : idLevel = json['idLevel'],
      desc = json['desc'];

  Map<String, dynamic> toJson() => {
    'desc': desc
  };

  Map<String, dynamic> toMap() {
    return {
      'desc': desc
    };
  }

  @override
  String toString() {
    return 'Level{ID: $idLevel DESCRIÇÃO: $desc}';
  }
}
