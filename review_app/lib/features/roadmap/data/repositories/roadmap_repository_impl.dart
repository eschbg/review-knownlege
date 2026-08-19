import '../../domain/entities/audit_skill.dart';
import '../../domain/entities/concept_mapping.dart';
import '../../domain/entities/incident_scenario.dart';
import '../../domain/entities/roadmap_type.dart';
import '../../domain/entities/week_item.dart';
import '../../domain/repositories/roadmap_repository.dart';
import '../datasources/roadmap_local_datasource.dart';
import '../datasources/roadmap_static_datasource.dart';

class RoadmapRepositoryImpl implements RoadmapRepository {
  final RoadmapStaticDataSource staticDataSource;
  final RoadmapLocalDataSource localDataSource;

  RoadmapRepositoryImpl({
    required this.staticDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<WeekItem>> getWeeks(RoadmapType type) async {
    final weeks = staticDataSource.getWeeks(type);
    final restoredWeeks = <WeekItem>[];

    for (var w in weeks) {
      final isCompleted = await localDataSource.getWeekCompleted(type, w.weekNumber) ?? w.isCompleted;
      final notes = await localDataSource.getWeekNotes(type, w.weekNumber) ?? w.userNotes;
      final pr = await localDataSource.getWeekPR(type, w.weekNumber) ?? w.prLink;

      IncidentScenario? inc = w.incidentDrill;
      if (inc != null) {
        final ans = await localDataSource.getIncidentAnswer(type, inc.id);
        if (ans != null) {
          inc = inc.copyWith(selectedOptionIndex: ans);
        }
      }

      restoredWeeks.add(w.copyWith(
        isCompleted: isCompleted,
        userNotes: notes,
        prLink: pr,
        incidentDrill: inc,
      ));
    }

    return restoredWeeks;
  }

  @override
  Future<List<AuditSkill>> getAuditSkills(RoadmapType type) async {
    final skills = staticDataSource.getAuditSkills(type);
    final restoredSkills = <AuditSkill>[];

    for (var s in skills) {
      final savedScore = await localDataSource.getAuditScore(s.id) ?? s.score;
      restoredSkills.add(s.copyWith(score: savedScore));
    }

    return restoredSkills;
  }

  @override
  Future<List<ConceptMapping>> getConceptMappings() async {
    return staticDataSource.getConceptMappings();
  }

  @override
  Future<void> toggleWeekCompleted(RoadmapType type, int weekNumber, bool isCompleted) async {
    await localDataSource.setWeekCompleted(type, weekNumber, isCompleted);
  }

  @override
  Future<void> saveWeekDeliverables(RoadmapType type, int weekNumber, String prLink, String userNotes) async {
    await localDataSource.setWeekPR(type, weekNumber, prLink);
    await localDataSource.setWeekNotes(type, weekNumber, userNotes);
  }

  @override
  Future<void> updateAuditScore(String skillId, int score) async {
    await localDataSource.setAuditScore(skillId, score);
  }

  @override
  Future<void> submitIncidentAnswer(RoadmapType type, String scenarioId, int optionIndex) async {
    await localDataSource.setIncidentAnswer(type, scenarioId, optionIndex);
  }
}
