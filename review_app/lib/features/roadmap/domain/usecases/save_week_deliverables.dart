import 'package:equatable/equatable.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/roadmap_type.dart';
import '../repositories/roadmap_repository.dart';

class SaveDeliverablesParams extends Equatable {
  final RoadmapType type;
  final int weekNumber;
  final String prLink;
  final String userNotes;

  const SaveDeliverablesParams({
    required this.type,
    required this.weekNumber,
    required this.prLink,
    required this.userNotes,
  });

  @override
  List<Object?> get props => [type, weekNumber, prLink, userNotes];
}

class SaveWeekDeliverablesUseCase implements UseCase<void, SaveDeliverablesParams> {
  final RoadmapRepository repository;

  SaveWeekDeliverablesUseCase(this.repository);

  @override
  Future<void> call(SaveDeliverablesParams params) async {
    await repository.saveWeekDeliverables(
      params.type,
      params.weekNumber,
      params.prLink,
      params.userNotes,
    );
  }
}
