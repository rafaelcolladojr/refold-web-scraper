import 'article_model.dart';
import 'article_section_model.dart';

class StageDetails {
  StageDetails({
    required this.overview,
    required this.articleSections,
  });

  Article overview;
  List<ArticleSection> articleSections;

  factory StageDetails.fromJson(Map<String, dynamic> json) => StageDetails(
        overview: Article.fromJson(json["overview"]),
        articleSections: List<ArticleSection>.from(
            json["article-sections"].map((x) => ArticleSection.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "overview": overview.toJson(),
        "article-sections":
            List<dynamic>.from(articleSections.map((x) => x.toJson())),
      };

  @override
  String toString() {
    String value = '$overview';
    for (var element in articleSections) {
      value += '\n$element';
    }
    return value;
  }
}
