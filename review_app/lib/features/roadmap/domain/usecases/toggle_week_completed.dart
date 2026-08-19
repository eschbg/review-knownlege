import 'package:equatable/equatable.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/roadmap_type.dart';
import '../repositories/roadmap_repository.dart';

class ToggleWeekParams extends Equatable {
  final RoadmapType type;
  final int weekNumber;
  final bool isCompleted;

  const ToggleWeekParams({
    required this.type,
    required this.weekNumber,
    required this.isCompleted,
  });

  @override
  List<Object?> get props => [type, weekNumber, isCompleted];
}

class ToggleWeekCompletedUseCase implements UseCase<void, ToggleWeekParams> {
  final RoadmapRepository repository;

  ToggleWeekCompletedUseCase(this.repository);

  @override
  Future<void> call(ToggleWeekParams params) async {
    await repository.toggleWeekCompleted(params.type, params.weekNumber, params.isCompleted);
  }
}
