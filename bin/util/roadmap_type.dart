extension ParseToString on RoadmapType {
  String toShortString() {
    if (this == RoadmapType.detailed) {
      return 'roadmap'; // website path
    }
    return toString().split('.').last;
  }
}

enum RoadmapType { detailed, simplified }
