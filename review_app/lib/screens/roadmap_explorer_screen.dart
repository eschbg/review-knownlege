import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/roadmap_bloc.dart';
import '../bloc/roadmap_event.dart';
import '../bloc/roadmap_state.dart';
import '../core/constants/app_colors.dart';
import '../models/roadmap_models.dart';

class RoadmapExplorerScreen extends StatefulWidget {
  const RoadmapExplorerScreen({super.key});

  @override
  State<RoadmapExplorerScreen> createState() => _RoadmapExplorerScreenState();
}

class _RoadmapExplorerScreenState extends State<RoadmapExplorerScreen> {
  int _selectedWeekNumber = 1;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoadmapBloc, RoadmapState>(
      builder: (context, state) {
        if (state is! RoadmapLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final weeks = state.activeWeeks;
        final selectedWeek = weeks.firstWhere(
          (w) => w.weekNumber == _selectedWeekNumber,
          orElse: () => weeks.first,
        );

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Week Timeline List (1/3 width)
            SizedBox(
              width: 340,
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(right: BorderSide(color: AppColors.border)),
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: weeks.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = weeks[index];
                    final isSelected = item.weekNumber == _selectedWeekNumber;
                    return _buildWeekTimelineItem(context, item, isSelected);
                  },
                ),
              ),
            ),

            // Right Week Detail Panel (2/3 width)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(28),
                child: _buildWeekDetailContent(context, selectedWeek, state),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWeekTimelineItem(BuildContext context, WeekItem item, bool isSelected) {
    final isSpring = item.roadmapType == RoadmapType.springBackend;
    final activeColor = isSpring ? AppColors.springGreen : AppColors.flutterBlue;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedWeekNumber = item.weekNumber;
        });
      },
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withValues(alpha: 0.15) : AppColors.cardSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? activeColor : (item.isCompleted ? AppColors.accentEmerald.withValues(alpha: 0.5) : AppColors.border),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Checkbox Completed Button
            IconButton(
              icon: Icon(
                item.isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                color: item.isCompleted ? AppColors.accentEmerald : AppColors.textMuted,
                size: 22,
              ),
              onPressed: () {
                context.read<RoadmapBloc>().add(
                      ToggleWeekCompleted(item.roadmapType, item.weekNumber),
                    );
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tuần ${item.weekNumber}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? activeColor : AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.title.replaceAll(RegExp(r'Tuần \d+ — '), ''),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (item.incidentDrill != null)
              Container(
                margin: const EdgeInsets.only(left: 4),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.flash_on_rounded, color: AppColors.primaryPurple, size: 14),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekDetailContent(BuildContext context, WeekItem week, RoadmapLoaded state) {
    final isSpring = week.roadmapType == RoadmapType.springBackend;
    final activeColor = isSpring ? AppColors.springGreen : AppColors.flutterBlue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header info
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: activeColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'TUẦN ${week.weekNumber}',
                style: TextStyle(color: activeColor, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                week.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                context.read<RoadmapBloc>().add(
                      ToggleWeekCompleted(week.roadmapType, week.weekNumber),
                    );
              },
              icon: Icon(
                week.isCompleted ? Icons.check_circle_rounded : Icons.circle_outlined,
                size: 18,
              ),
              label: Text(week.isCompleted ? 'Đã Hoàn Thành' : 'Đánh Dấu Hoàn Thành'),
              style: ElevatedButton.styleFrom(
                backgroundColor: week.isCompleted ? AppColors.accentEmerald : AppColors.cardSurface,
                foregroundColor: week.isCompleted ? Colors.black : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          week.subtitle,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 15),
        ),
        const SizedBox(height: 28),

        // Section 1: Review Topics
        _buildDetailCard(
          title: '📚 Kiến Thức Cần Review',
          color: AppColors.primaryBlue,
          child: Column(
            children: week.reviewTopics
                .map((topic) => Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.arrow_right_rounded, color: AppColors.primaryBlue, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              topic,
                              style: const TextStyle(fontSize: 14, height: 1.4, color: AppColors.textPrimary),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 20),

        // Section 2: Practices
        _buildDetailCard(
          title: '⚡ Bài Tập Thực Hành',
          color: AppColors.accentAmber,
          child: Column(
            children: week.practices
                .map((prac) => Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.code_rounded, color: AppColors.accentAmber, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              prac,
                              style: const TextStyle(fontSize: 14, height: 1.4, color: AppColors.textPrimary),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 20),

        // Section 3: Incident Drill Shortcut
        if (week.incidentDrill != null) ...[
          _buildIncidentShortcutCard(context, week.incidentDrill!),
          const SizedBox(height: 20),
        ],

        // Section 4: Deliverables & Evidence Input
        _buildDeliverableCard(context, week),
      ],
    );
  }

  Widget _buildDetailCard({
    required String title,
    required Color color,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildIncidentShortcutCard(BuildContext context, IncidentScenario incident) {
    final isSolved = incident.selectedOptionIndex != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryPurple.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: AppColors.primaryPurple, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '🔥 Tình Huống Sự Cố: ${incident.title}',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSolved)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accentEmerald.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Đã Giải Quuyết',
                    style: TextStyle(color: AppColors.accentEmerald, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            incident.symptom,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: () {
              context.read<RoadmapBloc>().add(const ChangeActiveTab(2)); // Go to Incident Simulator
            },
            icon: const Icon(Icons.play_arrow_rounded, size: 18),
            label: const Text('Mở Trình Giải Đố Sự Cố'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliverableCard(BuildContext context, WeekItem week) {
    final prController = TextEditingController(text: week.prLink);
    final notesController = TextEditingController(text: week.userNotes);

    return Container(
      width: double.infinity,
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
            '📦 Bằng Chứng Hoàn Thành (Deliverables)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryCyan),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: week.deliverables.map((deliv) {
              return Chip(
                label: Text(deliv, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary)),
                backgroundColor: AppColors.surface,
                side: const BorderSide(color: AppColors.border),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // PR Link Input
          TextField(
            controller: prController,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              labelText: 'Link Pull Request / GitHub Repository',
              labelStyle: const TextStyle(color: AppColors.textMuted),
              prefixIcon: const Icon(Icons.link_rounded, color: AppColors.primaryCyan),
              suffixIcon: week.prLink.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.open_in_new_rounded, size: 18),
                      onPressed: () async {
                        final uri = Uri.parse(week.prLink);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        }
                      },
                    )
                  : null,
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 12),

          // Notes / ADR Input
          TextField(
            controller: notesController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              labelText: 'Ghi chú học tập / Architecture Decision Record (ADR)',
              labelStyle: const TextStyle(color: AppColors.textMuted),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 14),

          ElevatedButton.icon(
            onPressed: () {
              context.read<RoadmapBloc>().add(
                    SaveWeekDeliverables(
                      roadmapType: week.roadmapType,
                      weekNumber: week.weekNumber,
                      prLink: prController.text,
                      userNotes: notesController.text,
                    ),
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã lưu bằng chứng bài tập!')),
              );
            },
            icon: const Icon(Icons.save_rounded, size: 18),
            label: const Text('Lưu Bằng Chứng'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryCyan,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}
