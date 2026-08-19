import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/roadmap_bloc.dart';
import '../bloc/roadmap_event.dart';
import '../bloc/roadmap_state.dart';
import '../core/constants/app_colors.dart';
import '../models/roadmap_models.dart';

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
        final progressPct = (state.progressPercentage * 100).toStringAsFixed(0);
        final avgAuditScore = state.averageAuditScore.toStringAsFixed(1);
        final activeWeeks = state.activeWeeks;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Welcome Banner
              _buildWelcomeBanner(context, state, isSpring, progressPct),
              const SizedBox(height: 24),

              // KPI Stats Row
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: 'Tiến Độ Tuần',
                      value: '${state.completedWeeksCount} / ${activeWeeks.length}',
                      subtitle: '$progressPct% Hoàn Thành',
                      icon: Icons.checklist_rounded,
                      color: isSpring ? AppColors.springGreen : AppColors.flutterBlue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Điểm Audit TB',
                      value: '$avgAuditScore / 4.0',
                      subtitle: _getAuditRatingLabel(state.averageAuditScore),
                      icon: Icons.star_rate_rounded,
                      color: AppColors.accentAmber,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Incident Solved',
                      value: '${state.solvedIncidentsCount} / ${state.totalIncidentsCount}',
                      subtitle: 'Production Drills',
                      icon: Icons.warning_amber_rounded,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Concept Mappings',
                      value: '${state.conceptMappings.length}',
                      subtitle: 'Mobile ↔ Backend',
                      icon: Icons.swap_horiz_rounded,
                      color: AppColors.primaryCyan,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Charts & Quick Action Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Audit Skills Chart (3 flex)
                  Expanded(
                    flex: 3,
                    child: _buildAuditChartCard(context, state),
                  ),
                  const SizedBox(width: 24),
                  // Quick Actions & Next Week Focus (2 flex)
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        _buildQuickActionsCard(context, state),
                        const SizedBox(height: 24),
                        _buildCurrentFocusCard(context, state),
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

  String _getAuditRatingLabel(double score) {
    if (score >= 3.0) return 'Mức 3-4: Tech Owner / Senior';
    if (score >= 2.0) return 'Mức 2: Tự triển khai tốt';
    if (score >= 1.0) return 'Mức 1: Có khái niệm';
    return 'Mức 0: Chưa thực hành';
  }

  Widget _buildWelcomeBanner(
    BuildContext context,
    RoadmapLoaded state,
    bool isSpring,
    String progressPct,
  ) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isSpring
              ? [const Color(0xFF0F382C), const Color(0xFF1A2336)]
              : [const Color(0xFF0C2D48), const Color(0xFF1A2336)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSpring ? AppColors.springGreen.withValues(alpha: 0.4) : AppColors.flutterBlue.withValues(alpha: 0.4),
        ),
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
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: (isSpring ? AppColors.springGreen : AppColors.flutterBlue).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        state.currentRoadmapType.displayName,
                        style: TextStyle(
                          color: isSpring ? AppColors.springGreen : AppColors.flutterBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Dành cho Dev 4 YOE Mobile -> Backend Mastery',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'Tech Mastery Review Hub',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Lộ trình 12 tuần giúp bạn làm chủ từ JVM internals, Concurrency, Performance, Security tới Distributed Systems.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          // Circular Progress Gauge
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: state.progressPercentage,
                  strokeWidth: 10,
                  backgroundColor: AppColors.border,
                  color: isSpring ? AppColors.springGreen : AppColors.flutterBlue,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$progressPct%',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'Progress',
                        style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
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
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildAuditChartCard(BuildContext context, RoadmapLoaded state) {
    final skills = state.activeAuditSkills;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Biểu Đồ Tự Đánh Giá Năng Lực (Baseline Audit)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Thang điểm 0 (Chưa biết) tới 4 (Thiết kế / Review / Teach)',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () {
                  context.read<RoadmapBloc>().add(const ChangeActiveTab(4)); // Switch to Self-Audit tab
                },
                icon: const Icon(Icons.edit_note_rounded, size: 18),
                label: const Text('Chỉnh sửa Audit'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 280,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 4.0,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final skill = skills[group.x.toInt()];
                      return BarTooltipItem(
                        '${skill.category}: ${skill.title}\nScore: ${rod.toY.toInt()}/4',
                        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= skills.length) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            skills[idx].category.split(' ').first,
                            style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) => const FlLine(
                    color: AppColors.border,
                    strokeWidth: 1,
                  ),
                  drawVerticalLine: false,
                ),
                borderData: FlBorderData(show: false),
                barGroups: skills.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final skill = entry.value;
                  final color = skill.score >= 3
                      ? AppColors.accentEmerald
                      : (skill.score >= 2 ? AppColors.primaryCyan : AppColors.accentAmber);

                  return BarChartGroupData(
                    x: idx,
                    barRods: [
                      BarChartRodData(
                        toY: skill.score.toDouble(),
                        color: color,
                        width: 16,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
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

  Widget _buildQuickActionsCard(BuildContext context, RoadmapLoaded state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lối Tắt Ôn Tập',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          _buildActionButton(
            icon: Icons.map_rounded,
            label: 'Khám Phá Lộ Trình 12 Tuần',
            color: AppColors.primaryCyan,
            onTap: () => context.read<RoadmapBloc>().add(const ChangeActiveTab(1)),
          ),
          const SizedBox(height: 10),
          _buildActionButton(
            icon: Icons.health_and_safety_rounded,
            label: 'Thực Hành Incident Drills',
            color: AppColors.primaryPurple,
            onTap: () => context.read<RoadmapBloc>().add(const ChangeActiveTab(2)),
          ),
          const SizedBox(height: 10),
          _buildActionButton(
            icon: Icons.compare_arrows_rounded,
            label: 'So Sánh Mobile ↔ Backend',
            color: AppColors.accentAmber,
            onTap: () => context.read<RoadmapBloc>().add(const ChangeActiveTab(3)),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 13),
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: color.withValues(alpha: 0.7), size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentFocusCard(BuildContext context, RoadmapLoaded state) {
    final nextUncompletedWeek = state.activeWeeks.firstWhere(
      (w) => !w.isCompleted,
      orElse: () => state.activeWeeks.last,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
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
                'Mục Tiêu Tiếp Theo',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentAmber.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Tuần ${nextUncompletedWeek.weekNumber}',
                  style: const TextStyle(color: AppColors.accentAmber, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            nextUncompletedWeek.title,
            style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            nextUncompletedWeek.subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<RoadmapBloc>().add(const ChangeActiveTab(1));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryCyan,
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Bắt đầu học ngay', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
