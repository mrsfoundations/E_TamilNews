import 'package:intl/intl.dart';

class Article {
  final int? id;
  final String? title;
  final String? name;
  final String? content;
  final String? image;
  final String? video;
  // final String? embedded;
  final String? author;
  // final String? avatar;
  final String? category;
  final String? date;
  final String? link;
  final int? cat_id;


  Article(
      {this.id,
      this.title,
        this.name,
      this.content,
      this.image,
        this.video,
        // this.embedded,
      this.author,
        // this.avatar,
      this.category,
      this.date,
      this.link,
        this.cat_id,

  });

  factory Article.fromJson(Map<String, dynamic> json) {
    String content = json['content'] != null ? json['content']['rendered'] : "";

    String image = json["featured_media"] != null
        ? json["featured_media"]
        : "https://images.wallpaperscraft.com/image/surface_dark_background_texture_50754_1920x1080.jpg";
    String author = json["yoast_head_json"]["author"];
    String category = json["_embedded"]["wp:term"][0][0]["name"];
    int cat_id = json["_embedded"]["wp:term"][0][0]["id"];
    // String avatar = json["author"]["avatar"];
    String date = DateFormat('dd MMMM, yyyy', 'en_US')
        .format(DateTime.parse(json["date"]))
        .toString();


    return Article(
        id: json['id'],
        title: json['title']['rendered'],
        content: content,
        // embedded: json['embedded'],
      author: author,
        image: image,
         category:category,
        date: date,
        link: json["link"],
      cat_id:cat_id ,
       );
  }

  factory Article.fromDatabaseJson(Map<String, dynamic> data) => Article(
      id: data['id'],
      title: data['title'],
      content: data['content'],
      image: data['image'],
      // embedded: data['embedded'],
      author: data['author'],
      // avatar: data['avatar'],
      category: data['category'],
      date: data['date'],
      link: data['link'],
    cat_id: data['cat_id'],

  );

  Map<String, dynamic> toDatabaseJson() => {
        'id': this.id,
        'title': this.title,
        'content': this.content,
        'image': this.image,
        // 'embedded':this.embedded,
    'author':this.author,
        // 'avatar': this.avatar,
        'category': this.category,
        'date': this.date,
        'link': this.link,
    'cat_id':this.cat_id,

      };
}
