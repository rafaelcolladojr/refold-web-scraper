import 'dart:convert';

import 'article_model.dart';
import 'article_section_model.dart';
import 'stage_model.dart';

String roadmapToJson(Roadmap data) => json.encode(data.toJson());

class Roadmap {
  Roadmap({
    required this.type,
    required this.lang,
    required this.stages,
  });

  String type;
  String lang;
  List<Stage> stages;

  factory Roadmap.fromJson(Map<String, dynamic> json) => Roadmap(
        type: json["type"],
        lang: json["lang"],
        stages: List<Stage>.from(json["stages"].map((x) => Stage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "lang": lang,
        "stages": List<dynamic>.from(stages.map((x) => x.toJson())),
      };

  List<Article> getAllArticles() {
    List<Article> articles = List.empty(growable: true);
    for (Stage stage in stages) {
      Article overview = stage.details.overview;
      articles.add(overview);
      for (ArticleSection section in stage.details.articleSections) {
        articles.addAll(section.articles);
      }
    }
    return articles;
  }
}
