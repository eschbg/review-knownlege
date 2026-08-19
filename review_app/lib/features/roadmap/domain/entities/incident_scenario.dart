import 'package:equatable/equatable.dart';
import 'roadmap_type.dart';

class IncidentOption extends Equatable {
  final int? id;
  final String optionText;
  final bool isBestChoice;
  final String explanation;

  const IncidentOption({
    this.id,
    required this.optionText,
    required this.isBestChoice,
    required this.explanation,
  });

  @override
  List<Object?> get props => [id, optionText, isBestChoice, explanation];
}

class IncidentScenario extends Equatable {
  final String id;
  final int weekNumber;
  final RoadmapType? roadmapType;
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
    this.roadmapType,
    required this.title,
    required this.symptom,
    required this.options,
    required this.rootCause,
    required this.prevention,
    required this.postmortemTemplate,
    this.selectedOptionIndex,
  });

  IncidentScenario copyWith({
    int? selectedOptionIndex,
  }) {
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
