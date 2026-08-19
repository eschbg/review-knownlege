import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/incident_scenario.dart';
import '../bloc/roadmap_bloc.dart';
import '../bloc/roadmap_event.dart';
import '../bloc/roadmap_state.dart';

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
            child: Text('No incident scenarios available in this roadmap.', style: TextStyle(color: AppColors.textMuted)),
          );
        }

        final currentIncident = incidents[_selectedIndex.clamp(0, incidents.length - 1)];

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 280,
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(right: BorderSide(color: AppColors.border)),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      color: AppColors.surface,
                      child: Row(
                        children: [
                          const Icon(Icons.terminal_rounded, color: AppColors.primaryIndigo, size: 18),
                          const SizedBox(width: 8),
                          const Text(
                            'Incident Drills',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primaryIndigo.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${state.solvedIncidentsCount}/${incidents.length}',
                              style: const TextStyle(color: AppColors.primaryIndigo, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(10),
                        itemCount: incidents.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 6),
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
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.cardSurfaceHover : AppColors.cardSurface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected ? AppColors.primaryIndigo : AppColors.border,
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isSolved ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                                    color: isSolved ? AppColors.springGreen : AppColors.accentAmber,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'WEEK ${inc.weekNumber.toString().padLeft(2, '0')}',
                                          style: const TextStyle(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          inc.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                            color: Colors.white,
                                            fontSize: 12,
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
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryIndigo.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'WEEK ${incident.weekNumber.toString().padLeft(2, '0')} DRILL',
                style: const TextStyle(color: AppColors.primaryIndigo, fontWeight: FontWeight.bold, fontSize: 11),
              ),
            ),
            const SizedBox(width: 12),
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
        const SizedBox(height: 20),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF0C0C0E),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.accentRose.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.report_problem_outlined, color: AppColors.accentRose, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'PRODUCTION SYMPTOM LOG',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentRose,
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                incident.symptom,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        const Text(
          'Select Triage Strategy:',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 12),

        Column(
          children: incident.options.asMap().entries.map((entry) {
            final idx = entry.key;
            final option = entry.value;
            final isSelected = incident.selectedOptionIndex == idx;

            Color optionBorderColor = AppColors.border;
            Color optionBgColor = AppColors.cardSurface;

            if (hasAnswered) {
              if (option.isBestChoice) {
                optionBorderColor = AppColors.springGreen;
                optionBgColor = AppColors.springGreenBg.withValues(alpha: 0.15);
              } else if (isSelected && !option.isBestChoice) {
                optionBorderColor = AppColors.accentRose;
                optionBgColor = AppColors.accentRose.withValues(alpha: 0.15);
              }
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: InkWell(
                onTap: () {
                  context.read<RoadmapBloc>().add(
                        SubmitIncidentAnswer(
                          scenarioId: incident.id,
                          optionIndex: idx,
                        ),
                      );
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: optionBgColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: optionBorderColor, width: isSelected ? 1.5 : 1),
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
                                    : (isSelected ? Icons.cancel_rounded : Icons.radio_button_unchecked_rounded))
                                : Icons.radio_button_unchecked_rounded,
                            color: hasAnswered
                                ? (option.isBestChoice
                                    ? AppColors.springGreen
                                    : (isSelected ? AppColors.accentRose : AppColors.textMuted))
                                : AppColors.textMuted,
                            size: 18,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              option.optionText,
                              style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      if (hasAnswered) ...[
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Text(
                            option.explanation,
                            style: TextStyle(
                              fontSize: 12,
                              color: option.isBestChoice ? AppColors.springGreen : AppColors.textSecondary,
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

        if (hasAnswered) ...[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.search_rounded, color: AppColors.flutterBlue, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Root Cause Analysis (RCA)',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  incident.rootCause,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Long-term Prevention:',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  incident.prevention,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0C0C0E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Postmortem Report Markdown Template',
                      style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold, color: AppColors.textSecondary, fontSize: 12),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: incident.postmortemTemplate));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Postmortem template copied!')),
                        );
                      },
                      icon: const Icon(Icons.copy_outlined, size: 14, color: AppColors.flutterBlue),
                      label: const Text('Copy Template', style: TextStyle(color: AppColors.flutterBlue, fontSize: 11)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.borderLight),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    incident.postmortemTemplate,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      color: AppColors.flutterBlue,
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
