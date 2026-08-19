import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/incident_scenario.dart';
import '../../domain/entities/roadmap_type.dart';
import '../../domain/entities/week_item.dart';
import '../bloc/roadmap_bloc.dart';
import '../bloc/roadmap_event.dart';
import '../bloc/roadmap_state.dart';

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
            SizedBox(
              width: 300,
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(right: BorderSide(color: AppColors.border)),
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: weeks.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 6),
                  itemBuilder: (context, index) {
                    final item = weeks[index];
                    final isSelected = item.weekNumber == _selectedWeekNumber;
                    return _buildWeekTimelineItem(context, item, isSelected);
                  },
                ),
              ),
            ),
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
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cardSurfaceHover : AppColors.cardSurface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? activeColor : (item.isCompleted ? AppColors.springGreen.withValues(alpha: 0.4) : AppColors.border),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                context.read<RoadmapBloc>().add(
                      ToggleWeekCompleted(item.roadmapType, item.weekNumber),
                    );
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Icon(
                  item.isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                  color: item.isCompleted ? AppColors.springGreen : AppColors.textMuted,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WEEK ${item.weekNumber.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? activeColor : AppColors.textMuted,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.title.replaceAll(RegExp(r'Tuần \d+ — '), ''),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (item.incidentDrill != null)
              Container(
                margin: const EdgeInsets.only(left: 6),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryIndigo.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('DRILL', style: TextStyle(color: AppColors.primaryIndigo, fontSize: 9, fontWeight: FontWeight.bold)),
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                          color: activeColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'WEEK ${week.weekNumber.toString().padLeft(2, '0')}',
                          style: TextStyle(color: activeColor, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        isSpring ? 'Spring Backend' : 'Mobile Flutter',
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    week.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    week.subtitle,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            OutlinedButton.icon(
              onPressed: () {
                context.read<RoadmapBloc>().add(
                      ToggleWeekCompleted(week.roadmapType, week.weekNumber),
                    );
              },
              icon: Icon(
                week.isCompleted ? Icons.check_circle_rounded : Icons.circle_outlined,
                size: 16,
                color: week.isCompleted ? AppColors.springGreen : Colors.white,
              ),
              label: Text(
                week.isCompleted ? 'Completed' : 'Mark Completed',
                style: TextStyle(
                  color: week.isCompleted ? AppColors.springGreen : Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: week.isCompleted ? AppColors.springGreenBg.withValues(alpha: 0.2) : AppColors.cardSurface,
                side: BorderSide(
                  color: week.isCompleted ? AppColors.springGreen : AppColors.borderLight,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        _buildSectionCard(
          title: 'Review Topics & Core Concepts',
          icon: Icons.auto_stories_outlined,
          iconColor: AppColors.primaryCyan,
          child: Column(
            children: week.reviewTopics
                .map((topic) => Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryCyan,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              topic,
                              style: const TextStyle(fontSize: 14, height: 1.5, color: AppColors.textPrimary),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 20),

        _buildSectionCard(
          title: 'Practical Coding Exercises',
          icon: Icons.code_rounded,
          iconColor: AppColors.accentAmber,
          child: Column(
            children: week.practices
                .map((prac) => Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.terminal_rounded, color: AppColors.accentAmber, size: 16),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              prac,
                              style: const TextStyle(fontSize: 13, height: 1.4, color: AppColors.textPrimary),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 20),

        if (week.incidentDrill != null) ...[
          _buildIncidentShortcutCard(context, week.incidentDrill!),
          const SizedBox(height: 20),
        ],

        _buildDeliverablesCard(context, week),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
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
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryIndigo.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryIndigo.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.warning_amber_rounded, color: AppColors.primaryIndigo, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Incidents Drill: ${incident.title}',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    if (isSolved)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.springGreen.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('SOLVED', style: TextStyle(color: AppColors.springGreen, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  incident.symptom,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          OutlinedButton(
            onPressed: () {
              context.read<RoadmapBloc>().add(const ChangeActiveTab(2));
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: AppColors.borderLight),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Launch Drill', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliverablesCard(BuildContext context, WeekItem week) {
    final prController = TextEditingController(text: week.prLink);
    final notesController = TextEditingController(text: week.userNotes);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
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
              Icon(Icons.inventory_2_outlined, color: AppColors.flutterBlue, size: 18),
              SizedBox(width: 10),
              Text(
                'Week Deliverables & Artifact Evidence',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: week.deliverables.map((deliv) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(deliv, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          TextField(
            controller: prController,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              hintText: 'https://github.com/org/repo/pull/123',
              hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
              labelText: 'Pull Request / Repository Link',
              labelStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              prefixIcon: const Icon(Icons.link_rounded, color: AppColors.textMuted, size: 18),
              suffixIcon: week.prLink.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.open_in_new_rounded, size: 16, color: AppColors.flutterBlue),
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: notesController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Document key architectural tradeoffs and takeaways...',
              hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
              labelText: 'Architecture Decision Record (ADR) & Notes',
              labelStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
          const SizedBox(height: 16),

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
                const SnackBar(content: Text('Deliverables saved successfully!')),
              );
            },
            icon: const Icon(Icons.save_outlined, size: 16),
            label: const Text('Save Deliverables'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryIndigo,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }
}
