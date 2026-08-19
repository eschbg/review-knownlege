import 'package:equatable/equatable.dart';
import '../models/roadmap_models.dart';

abstract class RoadmapEvent extends Equatable {
  const RoadmapEvent();

  @override
  List<Object?> get props => [];
}

class LoadRoadmapData extends RoadmapEvent {}

class SwitchRoadmapType extends RoadmapEvent {
  final RoadmapType roadmapType;
  const SwitchRoadmapType(this.roadmapType);

  @override
  List<Object?> get props => [roadmapType];
}

class ChangeActiveTab extends RoadmapEvent {
  final int tabIndex;
  const ChangeActiveTab(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}

class UpdateAuditScore extends RoadmapEvent {
  final String skillId;
  final int newScore;
  const UpdateAuditScore(this.skillId, this.newScore);

  @override
  List<Object?> get props => [skillId, newScore];
}

class ToggleWeekCompleted extends RoadmapEvent {
  final RoadmapType roadmapType;
  final int weekNumber;
  const ToggleWeekCompleted(this.roadmapType, this.weekNumber);

  @override
  List<Object?> get props => [roadmapType, weekNumber];
}

class SaveWeekDeliverables extends RoadmapEvent {
  final RoadmapType roadmapType;
  final int weekNumber;
  final String prLink;
  final String userNotes;

  const SaveWeekDeliverables({
    required this.roadmapType,
    required this.weekNumber,
    required this.prLink,
    required this.userNotes,
  });

  @override
  List<Object?> get props => [roadmapType, weekNumber, prLink, userNotes];
}

class SubmitIncidentAnswer extends RoadmapEvent {
  final String scenarioId;
  final int optionIndex;

  const SubmitIncidentAnswer({
    required this.scenarioId,
    required this.optionIndex,
  });

  @override
  List<Object?> get props => [scenarioId, optionIndex];
}
