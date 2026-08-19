import 'package:equatable/equatable.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/roadmap_type.dart';
import '../repositories/roadmap_repository.dart';

class SubmitIncidentParams extends Equatable {
  final RoadmapType type;
  final String scenarioId;
  final int optionIndex;

  const SubmitIncidentParams({
    required this.type,
    required this.scenarioId,
    required this.optionIndex,
  });

  @override
  List<Object?> get props => [type, scenarioId, optionIndex];
}

class SubmitIncidentAnswerUseCase implements UseCase<void, SubmitIncidentParams> {
  final RoadmapRepository repository;

  SubmitIncidentAnswerUseCase(this.repository);

  @override
  Future<void> call(SubmitIncidentParams params) async {
    await repository.submitIncidentAnswer(params.type, params.scenarioId, params.optionIndex);
  }
}
