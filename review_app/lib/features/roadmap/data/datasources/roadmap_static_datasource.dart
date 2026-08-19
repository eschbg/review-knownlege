import '../../domain/entities/audit_skill.dart';
import '../../domain/entities/concept_mapping.dart';
import '../../domain/entities/roadmap_type.dart';
import '../../domain/entities/week_item.dart';
import '../../../../data/concept_mappings_data.dart';
import '../../../../data/flutter_roadmap_data.dart';
import '../../../../data/spring_roadmap_data.dart';

abstract class RoadmapStaticDataSource {
  List<WeekItem> getWeeks(RoadmapType type);
  List<AuditSkill> getAuditSkills(RoadmapType type);
  List<ConceptMapping> getConceptMappings();
}

class RoadmapStaticDataSourceImpl implements RoadmapStaticDataSource {
  @override
  List<WeekItem> getWeeks(RoadmapType type) {
    if (type == RoadmapType.springBackend) {
      return SpringRoadmapData.getWeeks();
    } else {
      return FlutterRoadmapData.getWeeks();
    }
  }

  @override
  List<AuditSkill> getAuditSkills(RoadmapType type) {
    if (type == RoadmapType.springBackend) {
      return SpringRoadmapData.getAuditSkills();
    } else {
      return FlutterRoadmapData.getAuditSkills();
    }
  }

  @override
  List<ConceptMapping> getConceptMappings() {
    return ConceptMappingsData.getMappings();
  }
}
