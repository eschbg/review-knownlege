import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/roadmap_bloc.dart';
import '../bloc/roadmap_event.dart';
import '../bloc/roadmap_state.dart';
import '../core/constants/app_colors.dart';
import '../models/roadmap_models.dart';

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
                        '📝 Tự Đánh Giá Năng Lực Đầu Vào (Baseline Self-Audit)',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Đánh giá thực chất dựa trên bằng chứng code/incident đã làm. Thang 0-4.',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.accentAmber.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.accentAmber.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star_rounded, color: AppColors.accentAmber, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'ĐTB: ${state.averageAuditScore.toStringAsFixed(1)} / 4.0',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentAmber, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Rating Scale Legend Box
              _buildRatingLegend(),
              const SizedBox(height: 28),

              // Audit Cards List
              ...skills.map((skill) => _buildSkillAuditCard(context, skill)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRatingLegend() {
    final levels = [
      {'level': '0', 'desc': 'Chưa biết / Chưa từng làm'},
      {'level': '1', 'desc': 'Biết khái niệm'},
      {'level': '2', 'desc': 'Có thể tự triển khai'},
      {'level': '3', 'desc': 'Có thể debug & tối ưu prod'},
      {'level': '4', 'desc': 'Thiết kế, review & hướng dẫn'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: levels.map((lvl) {
          return Row(
            children: [
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primaryCyan.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  lvl['level']!,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryCyan, fontSize: 11),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                lvl['desc']!,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSkillAuditCard(BuildContext context, AuditSkill skill) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryCyan.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        skill.category,
                        style: const TextStyle(color: AppColors.primaryCyan, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      skill.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  skill.description,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),

          // Rating score buttons (0 to 4)
          Row(
            children: List.generate(5, (scoreValue) {
              final isSelected = skill.score == scoreValue;
              final color = scoreValue >= 3
                  ? AppColors.accentEmerald
                  : (scoreValue >= 2 ? AppColors.primaryCyan : AppColors.accentAmber);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: InkWell(
                  onTap: () {
                    context.read<RoadmapBloc>().add(
                          UpdateAuditScore(skill.id, scoreValue),
                        );
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? color : AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? color : AppColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      scoreValue.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.black : AppColors.textSecondary,
                        fontSize: 14,
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
