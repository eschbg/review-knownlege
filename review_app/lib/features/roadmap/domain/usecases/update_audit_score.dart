import 'package:equatable/equatable.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/roadmap_repository.dart';

class UpdateAuditScoreParams extends Equatable {
  final String skillId;
  final int newScore;

  const UpdateAuditScoreParams({
    required this.skillId,
    required this.newScore,
  });

  @override
  List<Object?> get props => [skillId, newScore];
}

class UpdateAuditScoreUseCase implements UseCase<void, UpdateAuditScoreParams> {
  final RoadmapRepository repository;

  UpdateAuditScoreUseCase(this.repository);

  @override
  Future<void> call(UpdateAuditScoreParams params) async {
    await repository.updateAuditScore(params.skillId, params.newScore);
  }
}
