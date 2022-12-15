import 'package:intl/intl.dart';

class CategoryArticle {
  final int? id;
  final String? name;


  CategoryArticle(
      {this.id,
        this.name,
      });

  factory CategoryArticle.fromJson(Map<String, dynamic> json) {
    String name = json['name'];

    int id = json["id"];

    return CategoryArticle(
        id: json['id'],
        name: json['name'],);
  }

  factory CategoryArticle.fromDatabaseJson(Map<String, dynamic> data) => CategoryArticle(
      id: data['id'],
      name: data['name'],

  );

  Map<String, dynamic> toDatabaseJson() => {
    'id': this.id,
    'name': this.name,
  };
}
