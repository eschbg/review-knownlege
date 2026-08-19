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
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryIndigo),
                  ),
                  SizedBox(height: 16),
                  Text('Loading Mastery Workspace...', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
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
              // Sleek Sidebar (Linear / Vercel layout)
              _buildSidebar(context, loadedState),

              // Main Workspace Panel
              Expanded(
                child: Column(
                  children: [
                    // Top App Bar
                    _buildHeader(context, loadedState),

                    // Content View
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
    return Container(
      width: 240,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Workspace Header / Logo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.primaryIndigo.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.primaryIndigo.withValues(alpha: 0.4)),
                  ),
                  child: const Center(
                    child: Text(
                      'M',
                      style: TextStyle(color: AppColors.primaryIndigo, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mastery Hub',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white, letterSpacing: -0.2),
                    ),
                    Text(
                      'Senior Review Workspace',
                      style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Group 1: OVERVIEW & LEARNING
          _buildNavGroupHeader('LEARNING & DRILLS'),
          _buildNavItem(context, state, index: 0, icon: Icons.grid_view_rounded, label: 'Overview Dashboard'),
          _buildNavItem(context, state, index: 1, icon: Icons.format_list_bulleted_rounded, label: '12-Week Roadmap'),
          _buildNavItem(context, state, index: 2, icon: Icons.terminal_rounded, label: 'Incident Drills'),

          const SizedBox(height: 16),
          // Group 2: CROSS DOMAIN & AUDIT
          _buildNavGroupHeader('CROSS-DOMAIN & AUDIT'),
          _buildNavItem(context, state, index: 3, icon: Icons.swap_horiz_rounded, label: 'Mobile ↔ Backend'),
          _buildNavItem(context, state, index: 4, icon: Icons.fact_check_outlined, label: 'Self-Audit Matrix'),

          const Spacer(),

          // Bottom Active Mode Footer
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cardSurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: state.currentRoadmapType == RoadmapType.springBackend
                        ? AppColors.springGreen
                        : AppColors.flutterBlue,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    state.currentRoadmapType.displayName,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavGroupHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18, top: 8, bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: AppColors.textMuted,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    RoadmapLoaded state, {
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = state.activeTabIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: InkWell(
        onTap: () {
          context.read<RoadmapBloc>().add(ChangeActiveTab(index));
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.cardSurfaceHover : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.borderLight : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.textMuted,
                size: 18,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, RoadmapLoaded state) {
    final isSpring = state.currentRoadmapType == RoadmapType.springBackend;

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          // Breadcrumb Title
          Text(
            _getTabTitle(state.activeTabIndex),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Spacer(),

          // Roadmap Switcher Segmented Control
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                _buildSegmentButton(
                  context,
                  label: 'Spring Backend',
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
      borderRadius: BorderRadius.circular(6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cardSurface : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? AppColors.borderLight : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            if (isSelected) ...[
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(color: activeColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textMuted,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTabTitle(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return 'Overview Dashboard';
      case 1:
        return '12-Week Roadmap Explorer';
      case 2:
        return 'Production Incident Drills';
      case 3:
        return 'Concept Matrix (Mobile ↔ Backend)';
      case 4:
        return 'Baseline Self-Audit Matrix';
      default:
        return 'Mastery Workspace';
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
