import 'package:equatable/equatable.dart';
import 'roadmap_type.dart';

class AuditSkill extends Equatable {
  final String id;
  final String category;
  final String title;
  final String description;
  final RoadmapType roadmapType;
  final int score;

  const AuditSkill({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.roadmapType,
    this.score = 0,
  });

  AuditSkill copyWith({
    int? score,
  }) {
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
