enum RoadmapType {
  springBackend,
  mobileFlutter,
}

extension RoadmapTypeExtension on RoadmapType {
  String get displayName {
    switch (this) {
      case RoadmapType.springBackend:
        return 'Backend Spring Boot';
      case RoadmapType.mobileFlutter:
        return 'Mobile Flutter';
    }
  }

  String get shortCode {
    switch (this) {
      case RoadmapType.springBackend:
        return 'spring';
      case RoadmapType.mobileFlutter:
        return 'flutter';
    }
  }
}
