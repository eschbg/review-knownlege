import 'package:equatable/equatable.dart';

enum RoadmapType { springBackend, mobileFlutter }

extension RoadmapTypeExt on RoadmapType {
  String get displayName {
    switch (this) {
      case RoadmapType.springBackend:
        return 'Backend Spring Boot';
      case RoadmapType.mobileFlutter:
        return 'Mobile Flutter';
    }
  }

  String get shortName {
    switch (this) {
      case RoadmapType.springBackend:
        return 'Spring Backend';
      case RoadmapType.mobileFlutter:
        return 'Flutter Mobile';
    }
  }
}

class AuditSkill extends Equatable {
  final String id;
  final String category;
  final String title;
  final String description;
  final RoadmapType roadmapType;
  final int score; // 0 to 4

  const AuditSkill({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.roadmapType,
    this.score = 0,
  });

  AuditSkill copyWith({int? score}) {
    return AuditSkill(
      id: id,
      category: category,
      title: title,
      description: description,
      roadmapType: roadmapType,
      score: score ?? this.score,
    );
  }

  @override
  List<Object?> get props => [id, category, title, description, roadmapType, score];
}

class IncidentOption extends Equatable {
  final int id;
  final String optionText;
  final String explanation;
  final bool isBestChoice;

  const IncidentOption({
    required this.id,
    required this.optionText,
    required this.explanation,
    required this.isBestChoice,
  });

  @override
  List<Object?> get props => [id, optionText, explanation, isBestChoice];
}

class IncidentScenario extends Equatable {
  final String id;
  final int weekNumber;
  final RoadmapType roadmapType;
  final String title;
  final String symptom;
  final List<IncidentOption> options;
  final String rootCause;
  final String prevention;
  final String postmortemTemplate;
  final int? selectedOptionIndex;

  const IncidentScenario({
    required this.id,
    required this.weekNumber,
    required this.roadmapType,
    required this.title,
    required this.symptom,
    required this.options,
    required this.rootCause,
    required this.prevention,
    required this.postmortemTemplate,
    this.selectedOptionIndex,
  });

  IncidentScenario copyWith({int? selectedOptionIndex}) {
    return IncidentScenario(
      id: id,
      weekNumber: weekNumber,
      roadmapType: roadmapType,
      title: title,
      symptom: symptom,
      options: options,
      rootCause: rootCause,
      prevention: prevention,
      postmortemTemplate: postmortemTemplate,
      selectedOptionIndex: selectedOptionIndex ?? this.selectedOptionIndex,
    );
  }

  @override
  List<Object?> get props => [
        id,
        weekNumber,
        roadmapType,
        title,
        symptom,
        options,
        rootCause,
        prevention,
        postmortemTemplate,
        selectedOptionIndex,
      ];
}

class WeekItem extends Equatable {
  final int weekNumber;
  final RoadmapType roadmapType;
  final String title;
  final String subtitle;
  final List<String> reviewTopics;
  final List<String> practices;
  final IncidentScenario? incidentDrill;
  final List<String> deliverables;
  final bool isCompleted;
  final String userNotes;
  final String prLink;

  const WeekItem({
    required this.weekNumber,
    required this.roadmapType,
    required this.title,
    required this.subtitle,
    required this.reviewTopics,
    required this.practices,
    this.incidentDrill,
    required this.deliverables,
    this.isCompleted = false,
    this.userNotes = '',
    this.prLink = '',
  });

  WeekItem copyWith({
    bool? isCompleted,
    String? userNotes,
    String? prLink,
    IncidentScenario? incidentDrill,
  }) {
    return WeekItem(
      weekNumber: weekNumber,
      roadmapType: roadmapType,
      title: title,
      subtitle: subtitle,
      reviewTopics: reviewTopics,
      practices: practices,
      incidentDrill: incidentDrill ?? this.incidentDrill,
      deliverables: deliverables,
      isCompleted: isCompleted ?? this.isCompleted,
      userNotes: userNotes ?? this.userNotes,
      prLink: prLink ?? this.prLink,
    );
  }

  @override
  List<Object?> get props => [
        weekNumber,
        roadmapType,
        title,
        subtitle,
        reviewTopics,
        practices,
        incidentDrill,
        deliverables,
        isCompleted,
        userNotes,
        prLink,
      ];
}

class ConceptMapping extends Equatable {
  final String id;
  final String topicName;
  final String flutterConcept;
  final String springConcept;
  final String keyInsight;
  final String flutterSnippet;
  final String springSnippet;

  const ConceptMapping({
    required this.id,
    required this.topicName,
    required this.flutterConcept,
    required this.springConcept,
    required this.keyInsight,
    required this.flutterSnippet,
    required this.springSnippet,
  });

  @override
  List<Object?> get props => [
        id,
        topicName,
        flutterConcept,
        springConcept,
        keyInsight,
        flutterSnippet,
        springSnippet,
      ];
}
