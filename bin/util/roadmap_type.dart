extension ParseToString on RoadmapType {
  String toShortString() {
    return toString().split('.').last;
  }
}

enum RoadmapType { detailed, simplified }
