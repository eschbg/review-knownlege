import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/roadmap_bloc.dart';
import '../bloc/roadmap_event.dart';
import '../bloc/roadmap_state.dart';
import '../core/constants/app_colors.dart';
import '../models/roadmap_models.dart';
import 'concept_mapping_screen.dart';
import 'dashboard_screen.dart';
import 'incident_simulator_screen.dart';
import 'roadmap_explorer_screen.dart';
import 'self_audit_screen.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoadmapBloc, RoadmapState>(
      builder: (context, state) {
        if (state is RoadmapLoading) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primaryCyan),
                  SizedBox(height: 16),
                  Text('Đang khởi tạo dữ liệu Roadmap...', style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            ),
          );
        }

        if (state is RoadmapError) {
          return Scaffold(
            body: Center(
              child: Text(state.message, style: const TextStyle(color: AppColors.accentRose)),
            ),
          );
        }

        final loadedState = state as RoadmapLoaded;

        return Scaffold(
          body: Row(
            children: [
              // Left Permanent Navigation Sidebar
              _buildSidebar(context, loadedState),

              // Main Right Content Panel
              Expanded(
                child: Column(
                  children: [
                    // Top App Header Bar
                    _buildHeader(context, loadedState),

                    // Active Tab Screen View
                    Expanded(
                      child: _buildActiveTabContent(loadedState.activeTabIndex),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSidebar(BuildContext context, RoadmapLoaded state) {
    final navItems = [
      {'icon': Icons.dashboard_rounded, 'label': 'Dashboard Overview'},
      {'icon': Icons.map_rounded, 'label': 'Roadmap Explorer'},
      {'icon': Icons.health_and_safety_rounded, 'label': 'Incident Simulator'},
      {'icon': Icons.compare_arrows_rounded, 'label': 'Mobile ↔ Backend'},
      {'icon': Icons.fact_check_rounded, 'label': 'Self-Audit Scorecard'},
    ];

    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          // App Logo Header
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryCyan, AppColors.primaryPurple],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.auto_stories_rounded, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tech Mastery',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                      ),
                      Text(
                        'Review Hub',
                        style: TextStyle(fontSize: 12, color: AppColors.primaryCyan, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Navigation Links
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: navItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                final item = navItems[index];
                final isSelected = state.activeTabIndex == index;

                return InkWell(
                  onTap: () {
                    context.read<RoadmapBloc>().add(ChangeActiveTab(index));
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryCyan.withValues(alpha: 0.15) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.primaryCyan.withValues(alpha: 0.5) : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          item['icon'] as IconData,
                          color: isSelected ? AppColors.primaryCyan : AppColors.textMuted,
                          size: 20,
                        ),
                        const SizedBox(width: 14),
                        Text(
                          item['label'] as String,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Version Badge
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.textMuted),
                const SizedBox(width: 8),
                Text(
                  'v1.0.0 • Flutter Web',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, RoadmapLoaded state) {
    final isSpring = state.currentRoadmapType == RoadmapType.springBackend;

    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          // Breadcrumb Title
          Text(
            _getTabTitle(state.activeTabIndex),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Spacer(),

          // Roadmap Switcher Segmented Control
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                _buildSegmentButton(
                  context,
                  label: 'Backend Spring',
                  isSelected: isSpring,
                  activeColor: AppColors.springGreen,
                  onTap: () {
                    context.read<RoadmapBloc>().add(const SwitchRoadmapType(RoadmapType.springBackend));
                  },
                ),
                _buildSegmentButton(
                  context,
                  label: 'Mobile Flutter',
                  isSelected: !isSpring,
                  activeColor: AppColors.flutterBlue,
                  onTap: () {
                    context.read<RoadmapBloc>().add(const SwitchRoadmapType(RoadmapType.mobileFlutter));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? activeColor : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? activeColor : AppColors.textMuted,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  String _getTabTitle(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return 'Dashboard Overview';
      case 1:
        return 'Lộ Trình Ôn Tập 12 Tuần';
      case 2:
        return 'Thực Hành Incident Drills Sản Xuất';
      case 3:
        return 'Ma Trận Ánh Xạ Concept Mobile ↔ Backend';
      case 4:
        return 'Bảng Chấm Điểm Self-Audit Baseline';
      default:
        return 'Review Hub';
    }
  }

  Widget _buildActiveTabContent(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return const DashboardScreen();
      case 1:
        return const RoadmapExplorerScreen();
      case 2:
        return const IncidentSimulatorScreen();
      case 3:
        return const ConceptMappingScreen();
      case 4:
        return const SelfAuditScreen();
      default:
        return const DashboardScreen();
    }
  }
}
