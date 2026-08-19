import '../entities/audit_skill.dart';
import '../entities/concept_mapping.dart';
import '../entities/roadmap_type.dart';
import '../entities/week_item.dart';

abstract class RoadmapRepository {
  Future<List<WeekItem>> getWeeks(RoadmapType type);
  Future<List<AuditSkill>> getAuditSkills(RoadmapType type);
  Future<List<ConceptMapping>> getConceptMappings();
  
  Future<void> toggleWeekCompleted(RoadmapType type, int weekNumber, bool isCompleted);
  Future<void> saveWeekDeliverables(RoadmapType type, int weekNumber, String prLink, String userNotes);
  Future<void> updateAuditScore(String skillId, int score);
  Future<void> submitIncidentAnswer(RoadmapType type, String scenarioId, int optionIndex);
}
