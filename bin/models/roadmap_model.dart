import 'dart:convert';

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
}
