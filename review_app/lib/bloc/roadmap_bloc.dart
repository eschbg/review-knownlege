import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/concept_mappings_data.dart';
import '../data/flutter_roadmap_data.dart';
import '../data/spring_roadmap_data.dart';
import '../models/roadmap_models.dart';
import 'roadmap_event.dart';
import 'roadmap_state.dart';

class RoadmapBloc extends Bloc<RoadmapEvent, RoadmapState> {
  SharedPreferences? _prefs;

  RoadmapBloc() : super(RoadmapLoading()) {
    on<LoadRoadmapData>(_onLoadRoadmapData);
    on<SwitchRoadmapType>(_onSwitchRoadmapType);
    on<ChangeActiveTab>(_onChangeActiveTab);
    on<UpdateAuditScore>(_onUpdateAuditScore);
    on<ToggleWeekCompleted>(_onToggleWeekCompleted);
    on<SaveWeekDeliverables>(_onSaveWeekDeliverables);
    on<SubmitIncidentAnswer>(_onSubmitIncidentAnswer);
  }

  Future<void> _onLoadRoadmapData(
    LoadRoadmapData event,
    Emitter<RoadmapState> emit,
  ) async {
    try {
      _prefs = await SharedPreferences.getInstance();

      // Load initial datasets
      var springSkills = SpringRoadmapData.getAuditSkills();
      var flutterSkills = FlutterRoadmapData.getAuditSkills();
      var springWeeks = SpringRoadmapData.getWeeks();
      var flutterWeeks = FlutterRoadmapData.getWeeks();
      var mappings = ConceptMappingsData.getMappings();

      // Restore stored scores
      springSkills = springSkills.map((skill) {
        final savedScore = _prefs?.getInt('audit_${skill.id}') ?? skill.score;
        return skill.copyWith(score: savedScore);
      }).toList();

      flutterSkills = flutterSkills.map((skill) {
        final savedScore = _prefs?.getInt('audit_${skill.id}') ?? skill.score;
        return skill.copyWith(score: savedScore);
      }).toList();

      // Restore stored completion & deliverables
      springWeeks = _restoreWeekItems(springWeeks, RoadmapType.springBackend);
      flutterWeeks = _restoreWeekItems(flutterWeeks, RoadmapType.mobileFlutter);

      emit(RoadmapLoaded(
        currentRoadmapType: RoadmapType.springBackend,
        springWeeks: springWeeks,
        flutterWeeks: flutterWeeks,
        springAuditSkills: springSkills,
        flutterAuditSkills: flutterSkills,
        conceptMappings: mappings,
      ));
    } catch (e) {
      emit(RoadmapError('Không thể tải dữ liệu: $e'));
    }
  }

  List<WeekItem> _restoreWeekItems(List<WeekItem> weeks, RoadmapType type) {
    final prefix = type.name;
    return weeks.map((w) {
      final isCompleted = _prefs?.getBool('${prefix}_w${w.weekNumber}_completed') ?? w.isCompleted;
      final notes = _prefs?.getString('${prefix}_w${w.weekNumber}_notes') ?? w.userNotes;
      final prLink = _prefs?.getString('${prefix}_w${w.weekNumber}_pr') ?? w.prLink;

      IncidentScenario? inc = w.incidentDrill;
      if (inc != null) {
        final selectedOpt = _prefs?.getInt('${prefix}_inc_${inc.id}_ans');
        if (selectedOpt != null) {
          inc = inc.copyWith(selectedOptionIndex: selectedOpt);
        }
      }

      return w.copyWith(
        isCompleted: isCompleted,
        userNotes: notes,
        prLink: prLink,
        incidentDrill: inc,
      );
    }).toList();
  }

  void _onSwitchRoadmapType(
    SwitchRoadmapType event,
    Emitter<RoadmapState> emit,
  ) {
    if (state is RoadmapLoaded) {
      final currentState = state as RoadmapLoaded;
      emit(currentState.copyWith(currentRoadmapType: event.roadmapType));
    }
  }

  void _onChangeActiveTab(
    ChangeActiveTab event,
    Emitter<RoadmapState> emit,
  ) {
    if (state is RoadmapLoaded) {
      final currentState = state as RoadmapLoaded;
      emit(currentState.copyWith(activeTabIndex: event.tabIndex));
    }
  }

  Future<void> _onUpdateAuditScore(
    UpdateAuditScore event,
    Emitter<RoadmapState> emit,
  ) async {
    if (state is RoadmapLoaded) {
      final currentState = state as RoadmapLoaded;
      await _prefs?.setInt('audit_${event.skillId}', event.newScore);

      final updatedSpring = currentState.springAuditSkills.map((s) {
        return s.id == event.skillId ? s.copyWith(score: event.newScore) : s;
      }).toList();

      final updatedFlutter = currentState.flutterAuditSkills.map((s) {
        return s.id == event.skillId ? s.copyWith(score: event.newScore) : s;
      }).toList();

      emit(currentState.copyWith(
        springAuditSkills: updatedSpring,
        flutterAuditSkills: updatedFlutter,
      ));
    }
  }

  Future<void> _onToggleWeekCompleted(
    ToggleWeekCompleted event,
    Emitter<RoadmapState> emit,
  ) async {
    if (state is RoadmapLoaded) {
      final currentState = state as RoadmapLoaded;
      final isSpring = event.roadmapType == RoadmapType.springBackend;
      final weeks = isSpring ? currentState.springWeeks : currentState.flutterWeeks;

      final updatedWeeks = weeks.map((w) {
        if (w.weekNumber == event.weekNumber) {
          final newCompleted = !w.isCompleted;
          _prefs?.setBool('${event.roadmapType.name}_w${w.weekNumber}_completed', newCompleted);
          return w.copyWith(isCompleted: newCompleted);
        }
        return w;
      }).toList();

      if (isSpring) {
        emit(currentState.copyWith(springWeeks: updatedWeeks));
      } else {
        emit(currentState.copyWith(flutterWeeks: updatedWeeks));
      }
    }
  }

  Future<void> _onSaveWeekDeliverables(
    SaveWeekDeliverables event,
    Emitter<RoadmapState> emit,
  ) async {
    if (state is RoadmapLoaded) {
      final currentState = state as RoadmapLoaded;
      final isSpring = event.roadmapType == RoadmapType.springBackend;
      final weeks = isSpring ? currentState.springWeeks : currentState.flutterWeeks;

      await _prefs?.setString('${event.roadmapType.name}_w${event.weekNumber}_notes', event.userNotes);
      await _prefs?.setString('${event.roadmapType.name}_w${event.weekNumber}_pr', event.prLink);

      final updatedWeeks = weeks.map((w) {
        if (w.weekNumber == event.weekNumber) {
          return w.copyWith(userNotes: event.userNotes, prLink: event.prLink);
        }
        return w;
      }).toList();

      if (isSpring) {
        emit(currentState.copyWith(springWeeks: updatedWeeks));
      } else {
        emit(currentState.copyWith(flutterWeeks: updatedWeeks));
      }
    }
  }

  Future<void> _onSubmitIncidentAnswer(
    SubmitIncidentAnswer event,
    Emitter<RoadmapState> emit,
  ) async {
    if (state is RoadmapLoaded) {
      final currentState = state as RoadmapLoaded;

      WeekItem updateWeek(WeekItem w) {
        if (w.incidentDrill?.id == event.scenarioId) {
          _prefs?.setInt('${w.roadmapType.name}_inc_${event.scenarioId}_ans', event.optionIndex);
          final updatedDrill = w.incidentDrill!.copyWith(selectedOptionIndex: event.optionIndex);
          return w.copyWith(incidentDrill: updatedDrill);
        }
        return w;
      }

      final updatedSpring = currentState.springWeeks.map(updateWeek).toList();
      final updatedFlutter = currentState.flutterWeeks.map(updateWeek).toList();

      emit(currentState.copyWith(
        springWeeks: updatedSpring,
        flutterWeeks: updatedFlutter,
      ));
    }
  }
}
