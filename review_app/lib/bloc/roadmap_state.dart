import 'package:equatable/equatable.dart';
import '../models/roadmap_models.dart';

abstract class RoadmapState extends Equatable {
  const RoadmapState();

  @override
  List<Object?> get props => [];
}

class RoadmapLoading extends RoadmapState {}

class RoadmapLoaded extends RoadmapState {
  final RoadmapType currentRoadmapType;
  final List<WeekItem> springWeeks;
  final List<WeekItem> flutterWeeks;
  final List<AuditSkill> springAuditSkills;
  final List<AuditSkill> flutterAuditSkills;
  final List<ConceptMapping> conceptMappings;
  final int activeTabIndex;
  final int selectedWeekNumber;

  const RoadmapLoaded({
    required this.currentRoadmapType,
    required this.springWeeks,
    required this.flutterWeeks,
    required this.springAuditSkills,
    required this.flutterAuditSkills,
    required this.conceptMappings,
    this.activeTabIndex = 0,
    this.selectedWeekNumber = 1,
  });

  List<WeekItem> get activeWeeks {
    return currentRoadmapType == RoadmapType.springBackend ? springWeeks : flutterWeeks;
  }

  List<AuditSkill> get activeAuditSkills {
    return currentRoadmapType == RoadmapType.springBackend ? springAuditSkills : flutterAuditSkills;
  }

  int get completedWeeksCount {
    return activeWeeks.where((w) => w.isCompleted).length;
  }

  double get progressPercentage {
    if (activeWeeks.isEmpty) return 0.0;
    return completedWeeksCount / activeWeeks.length;
  }

  double get averageAuditScore {
    final skills = activeAuditSkills;
    if (skills.isEmpty) return 0.0;
    final total = skills.fold<int>(0, (sum, s) => sum + s.score);
    return total / skills.length;
  }

  List<IncidentScenario> get activeIncidentScenarios {
    final list = <IncidentScenario>[];
    for (var w in activeWeeks) {
      if (w.incidentDrill != null) {
        list.add(w.incidentDrill!);
      }
    }
    return list;
  }

  int get totalIncidentsCount => activeIncidentScenarios.length;

  int get solvedIncidentsCount {
    return activeIncidentScenarios.where((inc) => inc.selectedOptionIndex != null).length;
  }

  RoadmapLoaded copyWith({
    RoadmapType? currentRoadmapType,
    List<WeekItem>? springWeeks,
    List<WeekItem>? flutterWeeks,
    List<AuditSkill>? springAuditSkills,
    List<AuditSkill>? flutterAuditSkills,
    List<ConceptMapping>? conceptMappings,
    int? activeTabIndex,
    int? selectedWeekNumber,
  }) {
    return RoadmapLoaded(
      currentRoadmapType: currentRoadmapType ?? this.currentRoadmapType,
      springWeeks: springWeeks ?? this.springWeeks,
      flutterWeeks: flutterWeeks ?? this.flutterWeeks,
      springAuditSkills: springAuditSkills ?? this.springAuditSkills,
      flutterAuditSkills: flutterAuditSkills ?? this.flutterAuditSkills,
      conceptMappings: conceptMappings ?? this.conceptMappings,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      selectedWeekNumber: selectedWeekNumber ?? this.selectedWeekNumber,
    );
  }

  @override
  List<Object?> get props => [
        currentRoadmapType,
        springWeeks,
        flutterWeeks,
        springAuditSkills,
        flutterAuditSkills,
        conceptMappings,
        activeTabIndex,
        selectedWeekNumber,
      ];
}

class RoadmapError extends RoadmapState {
  final String message;
  const RoadmapError(this.message);

  @override
  List<Object?> get props => [message];
}
