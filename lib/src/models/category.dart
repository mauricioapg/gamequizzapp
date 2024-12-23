class Category {
  final String idCategory;
  final String desc;
  final String image;

  Category(this.idCategory, this.desc, this.image);

  Category.fromJson(Map<String, dynamic> json)
      : idCategory = json['idCategory'],
      desc = json['desc'],
      image = json['image'];

  Map<String, dynamic> toJson() => {
    'desc': desc,
    'image': image
  };

  Map<String, dynamic> toMap() {
    return {
      'desc': desc,
      'image': image
    };
  }

  @override
  String toString() {
    return 'Category{ID: $idCategory DESCRIÇÃO: $desc}';
  }
}
