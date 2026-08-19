import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'features/roadmap/data/datasources/roadmap_local_datasource.dart';
import 'features/roadmap/data/datasources/roadmap_static_datasource.dart';
import 'features/roadmap/data/repositories/roadmap_repository_impl.dart';
import 'features/roadmap/domain/usecases/get_roadmap_data.dart';
import 'features/roadmap/domain/usecases/save_week_deliverables.dart';
import 'features/roadmap/domain/usecases/submit_incident_answer.dart';
import 'features/roadmap/domain/usecases/toggle_week_completed.dart';
import 'features/roadmap/domain/usecases/update_audit_score.dart';
import 'features/roadmap/presentation/bloc/roadmap_bloc.dart';
import 'features/roadmap/presentation/bloc/roadmap_event.dart';
import 'features/roadmap/presentation/screens/main_layout.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final staticDataSource = RoadmapStaticDataSourceImpl();
  final localDataSource = RoadmapLocalDataSourceImpl();
  final repository = RoadmapRepositoryImpl(
    staticDataSource: staticDataSource,
    localDataSource: localDataSource,
  );

  final getRoadmapData = GetRoadmapData(repository);
  final toggleWeekCompletedUseCase = ToggleWeekCompletedUseCase(repository);
  final saveWeekDeliverablesUseCase = SaveWeekDeliverablesUseCase(repository);
  final updateAuditScoreUseCase = UpdateAuditScoreUseCase(repository);
  final submitIncidentAnswerUseCase = SubmitIncidentAnswerUseCase(repository);

  runApp(
    TechMasteryApp(
      getRoadmapData: getRoadmapData,
      toggleWeekCompletedUseCase: toggleWeekCompletedUseCase,
      saveWeekDeliverablesUseCase: saveWeekDeliverablesUseCase,
      updateAuditScoreUseCase: updateAuditScoreUseCase,
      submitIncidentAnswerUseCase: submitIncidentAnswerUseCase,
    ),
  );
}

class TechMasteryApp extends StatelessWidget {
  final GetRoadmapData getRoadmapData;
  final ToggleWeekCompletedUseCase toggleWeekCompletedUseCase;
  final SaveWeekDeliverablesUseCase saveWeekDeliverablesUseCase;
  final UpdateAuditScoreUseCase updateAuditScoreUseCase;
  final SubmitIncidentAnswerUseCase submitIncidentAnswerUseCase;

  const TechMasteryApp({
    super.key,
    required this.getRoadmapData,
    required this.toggleWeekCompletedUseCase,
    required this.saveWeekDeliverablesUseCase,
    required this.updateAuditScoreUseCase,
    required this.submitIncidentAnswerUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoadmapBloc(
        getRoadmapData: getRoadmapData,
        toggleWeekCompletedUseCase: toggleWeekCompletedUseCase,
        saveWeekDeliverablesUseCase: saveWeekDeliverablesUseCase,
        updateAuditScoreUseCase: updateAuditScoreUseCase,
        submitIncidentAnswerUseCase: submitIncidentAnswerUseCase,
      )..add(LoadRoadmapData()),
      child: MaterialApp(
        title: 'Tech Mastery Review Hub',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const MainLayout(),
      ),
    );
  }
}
