import 'package:equatable/equatable.dart';
import 'incident_scenario.dart';
import 'roadmap_type.dart';

class WeekItem extends Equatable {
  final int weekNumber;
  final RoadmapType roadmapType;
  final String title;
  final String subtitle;
  final List<String> reviewTopics;
  final List<String> practices;
  final List<String> deliverables;
  final bool isCompleted;
  final String userNotes;
  final String prLink;
  final IncidentScenario? incidentDrill;

  const WeekItem({
    required this.weekNumber,
    required this.roadmapType,
    required this.title,
    required this.subtitle,
    required this.reviewTopics,
    required this.practices,
    required this.deliverables,
    this.isCompleted = false,
    this.userNotes = '',
    this.prLink = '',
    this.incidentDrill,
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
      deliverables: deliverables,
      isCompleted: isCompleted ?? this.isCompleted,
      userNotes: userNotes ?? this.userNotes,
      prLink: prLink ?? this.prLink,
      incidentDrill: incidentDrill ?? this.incidentDrill,
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
        deliverables,
        isCompleted,
        userNotes,
        prLink,
        incidentDrill,
      ];
}
