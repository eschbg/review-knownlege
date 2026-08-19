import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/audit_skill.dart';
import '../bloc/roadmap_bloc.dart';
import '../bloc/roadmap_event.dart';
import '../bloc/roadmap_state.dart';

class SelfAuditScreen extends StatelessWidget {
  const SelfAuditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoadmapBloc, RoadmapState>(
      builder: (context, state) {
        if (state is! RoadmapLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final skills = state.activeAuditSkills;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Baseline Self-Audit Scorecard',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: -0.3,
                            ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Honest evidence-based rating (Scale 0 - 4) across 11 core competencies.',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.cardSurface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star_rounded, color: AppColors.accentAmber, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Average: ${state.averageAuditScore.toStringAsFixed(1)} / 4.0',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              _buildRatingLegend(),
              const SizedBox(height: 24),

              ...skills.map((skill) => _buildSkillAuditCard(context, skill)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRatingLegend() {
    final levels = [
      {'level': '0', 'desc': 'Unaware / No experience'},
      {'level': '1', 'desc': 'Conceptual knowledge'},
      {'level': '2', 'desc': 'Can implement independently'},
      {'level': '3', 'desc': 'Debug & optimize in prod'},
      {'level': '4', 'desc': 'Architect & guide team'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: levels.map((lvl) {
          return Row(
            children: [
              Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Text(
                  lvl['level']!,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary, fontSize: 10),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                lvl['desc']!,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSkillAuditCard(BuildContext context, AuditSkill skill) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        skill.category,
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      skill.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  skill.description,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),

          Row(
            children: List.generate(5, (scoreValue) {
              final isSelected = skill.score == scoreValue;
              final color = scoreValue >= 3
                  ? AppColors.springGreen
                  : (scoreValue >= 2 ? AppColors.flutterBlue : AppColors.accentAmber);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: InkWell(
                  onTap: () {
                    context.read<RoadmapBloc>().add(
                          UpdateAuditScore(skill.id, scoreValue),
                        );
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    width: 34,
                    height: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? color : AppColors.surface,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected ? color : AppColors.border,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Text(
                      scoreValue.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.black : AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
