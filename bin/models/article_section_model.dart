import 'article_model.dart';

class ArticleSection {
  ArticleSection({
    required this.id,
    required this.title,
    required this.articles,
  });

  String id;
  String title;
  List<Article> articles;

  factory ArticleSection.fromJson(Map<String, dynamic> json) => ArticleSection(
        id: json["id"],
        title: json["title"],
        articles: List<Article>.from(
            json["articles"].map((x) => Article.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
      };

  @override
  String toString() {
    String value = '$title';
    for (var element in articles) {
      value += '\n$element';
    }
    return value;
  }
}
