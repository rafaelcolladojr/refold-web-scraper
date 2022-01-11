import 'dart:convert';
import 'dart:io';

import 'domain/roadmap_parser.dart';
import 'models/article_model.dart';
import 'models/roadmap_model.dart';
import 'util/roadmap_type.dart';

void main(List<String> arguments) async {
  RoadmapParser roadmapParser = RoadmapParser();
  stdout.write('Fetching Roadmap info...');
  Roadmap roadmap = await roadmapParser.parseRoadmap(RoadmapType.detailed);
  print('done');

  stdout.write('Writing Roadmap info to JSON...');
  writeRoadmap(roadmap);
  print('done');
}

void writeRoadmap(Roadmap roadmap) async {
  await writeRoadmapJson(roadmap);
  roadmap.getAllArticles().forEach(writeArticleJson);
}

Future<void> writeRoadmapJson(Roadmap roadmap) async {
  // ex. detailed-en.json
  //final roadmapFilename = 'output/${roadmap.type}_${roadmap.lang}.json';
  String filename = 'output/${roadmap.type}.json';
  await File(filename).writeAsString(jsonEncode(roadmap.toJson()));
}

void writeArticleJson(Article article) {
  String filename = 'output/${article.id}.json';
  File(filename).writeAsString(jsonEncode(article.toJson()));
}
