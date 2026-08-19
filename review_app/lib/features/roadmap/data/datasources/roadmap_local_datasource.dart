import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/roadmap_type.dart';

abstract class RoadmapLocalDataSource {
  Future<bool?> getWeekCompleted(RoadmapType type, int weekNumber);
  Future<void> setWeekCompleted(RoadmapType type, int weekNumber, bool isCompleted);

  Future<String?> getWeekNotes(RoadmapType type, int weekNumber);
  Future<void> setWeekNotes(RoadmapType type, int weekNumber, String notes);

  Future<String?> getWeekPR(RoadmapType type, int weekNumber);
  Future<void> setWeekPR(RoadmapType type, int weekNumber, String prLink);

  Future<int?> getAuditScore(String skillId);
  Future<void> setAuditScore(String skillId, int score);

  Future<int?> getIncidentAnswer(RoadmapType type, String scenarioId);
  Future<void> setIncidentAnswer(RoadmapType type, String scenarioId, int optionIndex);
}

class RoadmapLocalDataSourceImpl implements RoadmapLocalDataSource {
  SharedPreferences? _prefs;

  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  @override
  Future<bool?> getWeekCompleted(RoadmapType type, int weekNumber) async {
    final p = await prefs;
    return p.getBool('${type.name}_w${weekNumber}_completed');
  }

  @override
  Future<void> setWeekCompleted(RoadmapType type, int weekNumber, bool isCompleted) async {
    final p = await prefs;
    await p.setBool('${type.name}_w${weekNumber}_completed', isCompleted);
  }

  @override
  Future<String?> getWeekNotes(RoadmapType type, int weekNumber) async {
    final p = await prefs;
    return p.getString('${type.name}_w${weekNumber}_notes');
  }

  @override
  Future<void> setWeekNotes(RoadmapType type, int weekNumber, String notes) async {
    final p = await prefs;
    await p.setString('${type.name}_w${weekNumber}_notes', notes);
  }

  @override
  Future<String?> getWeekPR(RoadmapType type, int weekNumber) async {
    final p = await prefs;
    return p.getString('${type.name}_w${weekNumber}_pr');
  }

  @override
  Future<void> setWeekPR(RoadmapType type, int weekNumber, String prLink) async {
    final p = await prefs;
    await p.setString('${type.name}_w${weekNumber}_pr', prLink);
  }

  @override
  Future<int?> getAuditScore(String skillId) async {
    final p = await prefs;
    return p.getInt('audit_$skillId');
  }

  @override
  Future<void> setAuditScore(String skillId, int score) async {
    final p = await prefs;
    await p.setInt('audit_$skillId', score);
  }

  @override
  Future<int?> getIncidentAnswer(RoadmapType type, String scenarioId) async {
    final p = await prefs;
    return p.getInt('${type.name}_inc_${scenarioId}_ans');
  }

  @override
  Future<void> setIncidentAnswer(RoadmapType type, String scenarioId, int optionIndex) async {
    final p = await prefs;
    await p.setInt('${type.name}_inc_${scenarioId}_ans', optionIndex);
  }
}
