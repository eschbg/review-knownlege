import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/roadmap_type.dart';
import '../../domain/entities/week_item.dart';
import '../../domain/usecases/get_roadmap_data.dart';
import '../../domain/usecases/save_week_deliverables.dart';
import '../../domain/usecases/submit_incident_answer.dart';
import '../../domain/usecases/toggle_week_completed.dart';
import '../../domain/usecases/update_audit_score.dart';
import 'roadmap_event.dart';
import 'roadmap_state.dart';

class RoadmapBloc extends Bloc<RoadmapEvent, RoadmapState> {
  final GetRoadmapData getRoadmapData;
  final ToggleWeekCompletedUseCase toggleWeekCompletedUseCase;
  final SaveWeekDeliverablesUseCase saveWeekDeliverablesUseCase;
  final UpdateAuditScoreUseCase updateAuditScoreUseCase;
  final SubmitIncidentAnswerUseCase submitIncidentAnswerUseCase;

  RoadmapBloc({
    required this.getRoadmapData,
    required this.toggleWeekCompletedUseCase,
    required this.saveWeekDeliverablesUseCase,
    required this.updateAuditScoreUseCase,
    required this.submitIncidentAnswerUseCase,
  }) : super(RoadmapLoading()) {
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
      final result = await getRoadmapData(NoParams());

      emit(RoadmapLoaded(
        currentRoadmapType: RoadmapType.springBackend,
        springWeeks: result.springWeeks,
        flutterWeeks: result.flutterWeeks,
        springAuditSkills: result.springAuditSkills,
        flutterAuditSkills: result.flutterAuditSkills,
        conceptMappings: result.conceptMappings,
      ));
    } catch (e) {
      emit(RoadmapError('Failed to load roadmap data: $e'));
    }
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

      await updateAuditScoreUseCase(UpdateAuditScoreParams(
        skillId: event.skillId,
        newScore: event.newScore,
      ));

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

      WeekItem? targetWeek;
      for (var w in weeks) {
        if (w.weekNumber == event.weekNumber) {
          targetWeek = w;
          break;
        }
      }

      if (targetWeek == null) return;
      final newCompleted = !targetWeek.isCompleted;

      await toggleWeekCompletedUseCase(ToggleWeekParams(
        type: event.roadmapType,
        weekNumber: event.weekNumber,
        isCompleted: newCompleted,
      ));

      final updatedWeeks = weeks.map((w) {
        if (w.weekNumber == event.weekNumber) {
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

      await saveWeekDeliverablesUseCase(SaveDeliverablesParams(
        type: event.roadmapType,
        weekNumber: event.weekNumber,
        prLink: event.prLink,
        userNotes: event.userNotes,
      ));

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

      await submitIncidentAnswerUseCase(SubmitIncidentParams(
        type: currentState.currentRoadmapType,
        scenarioId: event.scenarioId,
        optionIndex: event.optionIndex,
      ));

      WeekItem updateWeek(WeekItem w) {
        if (w.incidentDrill?.id == event.scenarioId) {
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
