import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/roadmap_type.dart';
import '../bloc/roadmap_bloc.dart';
import '../bloc/roadmap_event.dart';
import '../bloc/roadmap_state.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoadmapBloc, RoadmapState>(
      builder: (context, state) {
        if (state is! RoadmapLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final isSpring = state.currentRoadmapType == RoadmapType.springBackend;
        final themeColor = isSpring ? AppColors.springGreen : AppColors.flutterBlue;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroHeader(context, state, themeColor),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      title: 'Roadmap Progress',
                      value: '${state.completedWeeksCount} / ${state.activeWeeks.length}',
                      subtext: '${(state.progressPercentage * 100).toInt()}% completed',
                      progress: state.progressPercentage,
                      color: themeColor,
                      icon: Icons.trending_up_rounded,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildMetricCard(
                      title: 'Baseline Audit Score',
                      value: '${state.averageAuditScore.toStringAsFixed(1)} / 4.0',
                      subtext: _getAuditRatingLabel(state.averageAuditScore),
                      progress: (state.averageAuditScore / 4.0).clamp(0.0, 1.0),
                      color: AppColors.accentAmber,
                      icon: Icons.star_outline_rounded,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildMetricCard(
                      title: 'Incidents Resolved',
                      value: '${state.solvedIncidentsCount} / ${state.totalIncidentsCount}',
                      subtext: state.totalIncidentsCount > 0
                          ? '${((state.solvedIncidentsCount / state.totalIncidentsCount) * 100).toInt()}% triage rate'
                          : 'No incidents',
                      progress: state.totalIncidentsCount > 0
                          ? state.solvedIncidentsCount / state.totalIncidentsCount
                          : 0.0,
                      color: AppColors.primaryIndigo,
                      icon: Icons.shield_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildBarChartCard(context, state),
                  ),
                  const SizedBox(width: 20),

                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        _buildCurrentFocusCard(context, state, themeColor),
                        const SizedBox(height: 16),
                        _buildQuickActionList(context, state),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeroHeader(BuildContext context, RoadmapLoaded state, Color themeColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        color: themeColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        state.currentRoadmapType.displayName.toUpperCase(),
                        style: TextStyle(color: themeColor, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      '12-Week Senior Mastery Roadmap',
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Welcome to your Technical Review Hub',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Clean Architecture + Feature-First implementation structure.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              context.read<RoadmapBloc>().add(const ChangeActiveTab(1));
            },
            icon: const Icon(Icons.arrow_forward_rounded, size: 16),
            label: const Text('Open Explorer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.surface,
              foregroundColor: Colors.white,
              elevation: 0,
              side: const BorderSide(color: AppColors.borderLight),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtext,
    required double progress,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted),
              ),
              Icon(icon, color: AppColors.textMuted, size: 18),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5),
          ),
          const SizedBox(height: 6),
          Text(
            subtext,
            style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: AppColors.surface,
              color: color,
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChartCard(BuildContext context, RoadmapLoaded state) {
    final skills = state.activeAuditSkills;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Competency Self-Audit Profile',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Rating scale 0.0 - 4.0 across core engineering domains',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  context.read<RoadmapBloc>().add(const ChangeActiveTab(4));
                },
                child: const Text(
                  'Edit Audit →',
                  style: TextStyle(color: AppColors.primaryIndigo, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          SizedBox(
            height: 220,
            child: skills.isEmpty
                ? const Center(child: Text('No audit data', style: TextStyle(color: AppColors.textMuted)))
                : BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 4.0,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (group) => AppColors.surface,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final skill = skills[group.x.toInt()];
                            return BarTooltipItem(
                              '${skill.title}\nScore: ${rod.toY.toStringAsFixed(1)} / 4.0',
                              const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            getTitlesWidget: (value, meta) {
                              final idx = value.toInt();
                              if (idx >= 0 && idx < skills.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    'K${idx + 1}',
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 1.0,
                        getDrawingHorizontalLine: (value) => const FlLine(color: AppColors.border, strokeWidth: 1),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: skills.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final skill = entry.value;
                        return BarChartGroupData(
                          x: idx,
                          barRods: [
                            BarChartRodData(
                              toY: skill.score.toDouble(),
                              color: skill.score >= 3
                                  ? AppColors.springGreen
                                  : (skill.score >= 2 ? AppColors.flutterBlue : AppColors.accentAmber),
                              width: 14,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentFocusCard(BuildContext context, RoadmapLoaded state, Color themeColor) {
    final weeks = state.activeWeeks;
    final currentWeek = weeks.firstWhere(
      (w) => !w.isCompleted,
      orElse: () => weeks.last,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: themeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'CURRENT FOCUS',
                  style: TextStyle(color: themeColor, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              Text(
                'Week ${currentWeek.weekNumber}',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            currentWeek.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            currentWeek.subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 14),
          OutlinedButton(
            onPressed: () {
              context.read<RoadmapBloc>().add(const ChangeActiveTab(1));
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: AppColors.borderLight),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Continue Week Tasks', style: TextStyle(fontSize: 12)),
                SizedBox(width: 6),
                Icon(Icons.arrow_forward_rounded, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionList(BuildContext context, RoadmapLoaded state) {
    final actions = [
      {
        'title': 'Solve Incident Drills',
        'sub': '${state.solvedIncidentsCount}/${state.totalIncidentsCount} resolved',
        'tab': 2,
        'icon': Icons.terminal_rounded,
        'color': AppColors.primaryIndigo,
      },
      {
        'title': 'Mobile ↔ Backend Matrix',
        'sub': '5 core domain comparisons',
        'tab': 3,
        'icon': Icons.swap_horiz_rounded,
        'color': AppColors.flutterBlue,
      },
    ];

    return Column(
      children: actions.map((act) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: InkWell(
            onTap: () {
              context.read<RoadmapBloc>().add(ChangeActiveTab(act['tab'] as int));
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (act['color'] as Color).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(act['icon'] as IconData, color: act['color'] as Color, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          act['title'] as String,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 13),
                        ),
                        Text(
                          act['sub'] as String,
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 18),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getAuditRatingLabel(double score) {
    if (score >= 3.5) return 'Architect / Tech Lead';
    if (score >= 2.5) return 'Senior / Production-Ready';
    if (score >= 1.5) return 'Mid-level Engineer';
    return 'Baseline / Review Required';
  }
}
