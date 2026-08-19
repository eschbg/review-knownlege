import '../../../../core/usecase/usecase.dart';
import '../entities/audit_skill.dart';
import '../entities/concept_mapping.dart';
import '../entities/roadmap_type.dart';
import '../entities/week_item.dart';
import '../repositories/roadmap_repository.dart';

class RoadmapDataResult {
  final List<WeekItem> springWeeks;
  final List<WeekItem> flutterWeeks;
  final List<AuditSkill> springAuditSkills;
  final List<AuditSkill> flutterAuditSkills;
  final List<ConceptMapping> conceptMappings;

  const RoadmapDataResult({
    required this.springWeeks,
    required this.flutterWeeks,
    required this.springAuditSkills,
    required this.flutterAuditSkills,
    required this.conceptMappings,
  });
}

class GetRoadmapData implements UseCase<RoadmapDataResult, NoParams> {
  final RoadmapRepository repository;

  GetRoadmapData(this.repository);

  @override
  Future<RoadmapDataResult> call(NoParams params) async {
    final springWeeks = await repository.getWeeks(RoadmapType.springBackend);
    final flutterWeeks = await repository.getWeeks(RoadmapType.mobileFlutter);
    final springSkills = await repository.getAuditSkills(RoadmapType.springBackend);
    final flutterSkills = await repository.getAuditSkills(RoadmapType.mobileFlutter);
    final mappings = await repository.getConceptMappings();

    return RoadmapDataResult(
      springWeeks: springWeeks,
      flutterWeeks: flutterWeeks,
      springAuditSkills: springSkills,
      flutterAuditSkills: flutterSkills,
      conceptMappings: mappings,
    );
  }
}
