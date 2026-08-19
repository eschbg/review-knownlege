import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/roadmap_bloc.dart';
import '../bloc/roadmap_event.dart';
import '../bloc/roadmap_state.dart';
import '../core/constants/app_colors.dart';
import '../models/roadmap_models.dart';

class IncidentSimulatorScreen extends StatefulWidget {
  const IncidentSimulatorScreen({super.key});

  @override
  State<IncidentSimulatorScreen> createState() => _IncidentSimulatorScreenState();
}

class _IncidentSimulatorScreenState extends State<IncidentSimulatorScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoadmapBloc, RoadmapState>(
      builder: (context, state) {
        if (state is! RoadmapLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final incidents = state.activeIncidentScenarios;
        if (incidents.isEmpty) {
          return const Center(
            child: Text('Không có bài tập Incident nào trong lộ trình này.'),
          );
        }

        final currentIncident = incidents[_selectedIndex.clamp(0, incidents.length - 1)];

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Incident Selector Drawer
            SizedBox(
              width: 300,
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(right: BorderSide(color: AppColors.border)),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      color: AppColors.surface,
                      child: Row(
                        children: [
                          const Icon(Icons.health_and_safety_rounded, color: AppColors.primaryPurple, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            'Incident Drills',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryPurple.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${state.solvedIncidentsCount}/${incidents.length}',
                              style: const TextStyle(color: AppColors.primaryPurple, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: incidents.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final inc = incidents[index];
                          final isSelected = index == _selectedIndex;
                          final isSolved = inc.selectedOptionIndex != null;

                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primaryPurple.withValues(alpha: 0.15) : AppColors.cardSurface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? AppColors.primaryPurple : AppColors.border,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isSolved ? Icons.check_circle_rounded : Icons.warning_amber_rounded,
                                    color: isSolved ? AppColors.accentEmerald : AppColors.accentAmber,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Tuần ${inc.weekNumber}',
                                          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                        ),
                                        Text(
                                          inc.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                            color: Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Right Main Player Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(28),
                child: _buildScenarioPlayer(context, currentIncident),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildScenarioPlayer(BuildContext context, IncidentScenario incident) {
    final hasAnswered = incident.selectedOptionIndex != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'TUẦN ${incident.weekNumber} DRILL',
                style: const TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                incident.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Symptom Box (Alert)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.accentRose.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.accentRose.withValues(alpha: 0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.report_problem_rounded, color: AppColors.accentRose, size: 22),
                  SizedBox(width: 10),
                  Text(
                    'Hiện Tượng / Triệu Chứng Sự Cố (Symptom Log)',
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentRose, fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                incident.symptom,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, height: 1.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // Options Triage
        const Text(
          'Chọn Hướng Xử Lý Triage Khắc Phục:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 14),

        Column(
          children: incident.options.asMap().entries.map((entry) {
            final idx = entry.key;
            final option = entry.value;
            final isSelected = incident.selectedOptionIndex == idx;

            Color optionBorderColor = AppColors.border;
            Color optionBgColor = AppColors.cardSurface;

            if (hasAnswered) {
              if (option.isBestChoice) {
                optionBorderColor = AppColors.accentEmerald;
                optionBgColor = AppColors.accentEmerald.withValues(alpha: 0.15);
              } else if (isSelected && !option.isBestChoice) {
                optionBorderColor = AppColors.accentRose;
                optionBgColor = AppColors.accentRose.withValues(alpha: 0.15);
              }
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: InkWell(
                onTap: () {
                  context.read<RoadmapBloc>().add(
                        SubmitIncidentAnswer(
                          scenarioId: incident.id,
                          optionIndex: idx,
                        ),
                      );
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: optionBgColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: optionBorderColor, width: isSelected ? 2 : 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            hasAnswered
                                ? (option.isBestChoice
                                    ? Icons.check_circle_rounded
                                    : (isSelected ? Icons.cancel_rounded : Icons.circle_outlined))
                                : Icons.radio_button_unchecked_rounded,
                            color: hasAnswered
                                ? (option.isBestChoice
                                    ? AppColors.accentEmerald
                                    : (isSelected ? AppColors.accentRose : AppColors.textMuted))
                                : AppColors.textMuted,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              option.optionText,
                              style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      if (hasAnswered) ...[
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 32.0),
                          child: Text(
                            option.explanation,
                            style: TextStyle(
                              fontSize: 13,
                              color: option.isBestChoice ? AppColors.accentEmerald : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        // Show Analysis & Postmortem when answered
        if (hasAnswered) ...[
          const SizedBox(height: 28),
          // Root Cause Analysis Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.search_rounded, color: AppColors.primaryBlue, size: 22),
                    SizedBox(width: 10),
                    Text(
                      'Phân Tích Nguyên Nhân Gốc (Root Cause Analysis)',
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue, fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  incident.rootCause,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Biện Pháp Phòng Ngừa Dài Hạn (Prevention):',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 6),
                Text(
                  incident.prevention,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Postmortem Template Box
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '📄 Postmortem Report Template',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy_rounded, color: AppColors.primaryCyan, size: 18),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: incident.postmortemTemplate));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Đã copy mẫu Postmortem Report!')),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    incident.postmortemTemplate,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      color: AppColors.primaryCyan,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
