extension ParseToString on RoadmapLanguage {
  String toShortString() {
    return toString().split('.').last;
  }
}

enum RoadmapLanguage { en, es, jp, ko }
