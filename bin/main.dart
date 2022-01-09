import 'dart:convert';
import 'dart:io';

import 'domain/roadmap_parser.dart';
import 'models/roadmap_model.dart';

void main(List<String> arguments) async {
  RoadmapParser roadmapParser = RoadmapParser();
  Roadmap roadmap = await roadmapParser.parseRoadmap();

  writeRoadmap(roadmap);
}

void writeRoadmap(Roadmap roadmap) async {
  Map<String, dynamic> roadmapJson = roadmap.toJson();

  // ex. detailed-en.json
  final filename = 'output/${roadmapJson["type"]}-${roadmapJson["lang"]}.json';
  var file = await File(filename).writeAsString(jsonEncode(roadmapJson));

  file.toString();
}
