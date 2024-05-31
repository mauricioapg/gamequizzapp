class Category {
  final String idCategory;
  final String desc;

  Category(this.idCategory, this.desc);

  Category.fromJson(Map<String, dynamic> json)
      : idCategory = json['idCategory'],
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
    return 'Category{ID: $idCategory DESCRIÇÃO: $desc}';
  }
}
