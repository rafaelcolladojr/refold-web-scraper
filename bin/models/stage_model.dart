import 'stage_details_model.dart';

class Stage {
  Stage({
    required this.id,
    required this.subtitle,
    required this.headline,
    required this.intro,
    required this.details,
  });

  String id;
  String subtitle;
  String headline;
  String intro;
  StageDetails details;

  factory Stage.fromJson(Map<String, dynamic> json) => Stage(
        id: json["id"],
        subtitle: json["subtitle"],
        headline: json["headline"],
        intro: json["intro"],
        details: StageDetails.fromJson(json["details"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subtitle": subtitle,
        "headline": headline,
        "intro": intro,
        "details": details.toJson(),
      };

  @override
  String toString() {
    return '$subtitle: $headline\n$intro\n$details';
  }
}
