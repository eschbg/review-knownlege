import 'package:flutter_test/flutter_test.dart';
import 'package:review_app/features/roadmap/data/datasources/roadmap_local_datasource.dart';
import 'package:review_app/features/roadmap/data/datasources/roadmap_static_datasource.dart';
import 'package:review_app/features/roadmap/data/repositories/roadmap_repository_impl.dart';
import 'package:review_app/features/roadmap/domain/usecases/get_roadmap_data.dart';
import 'package:review_app/features/roadmap/domain/usecases/save_week_deliverables.dart';
import 'package:review_app/features/roadmap/domain/usecases/submit_incident_answer.dart';
import 'package:review_app/features/roadmap/domain/usecases/toggle_week_completed.dart';
import 'package:review_app/features/roadmap/domain/usecases/update_audit_score.dart';
import 'package:review_app/main.dart';

void main() {
  testWidgets('App loads Tech Mastery Review Hub smoke test', (WidgetTester tester) async {
    final staticDataSource = RoadmapStaticDataSourceImpl();
    final localDataSource = RoadmapLocalDataSourceImpl();
    final repository = RoadmapRepositoryImpl(
      staticDataSource: staticDataSource,
      localDataSource: localDataSource,
    );

    await tester.pumpWidget(
      TechMasteryApp(
        getRoadmapData: GetRoadmapData(repository),
        toggleWeekCompletedUseCase: ToggleWeekCompletedUseCase(repository),
        saveWeekDeliverablesUseCase: SaveWeekDeliverablesUseCase(repository),
        updateAuditScoreUseCase: UpdateAuditScoreUseCase(repository),
        submitIncidentAnswerUseCase: SubmitIncidentAnswerUseCase(repository),
      ),
    );
  });
}
