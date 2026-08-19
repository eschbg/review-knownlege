import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/roadmap_bloc.dart';
import '../bloc/roadmap_state.dart';
import '../core/constants/app_colors.dart';
import '../models/roadmap_models.dart';

class ConceptMappingScreen extends StatelessWidget {
  const ConceptMappingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoadmapBloc, RoadmapState>(
      builder: (context, state) {
        if (state is! RoadmapLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final mappings = state.conceptMappings;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🔀 Cầu Nối Tư Duy Kiến Thức (Mobile ↔ Backend Mapping)',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tận dụng kinh nghiệm 4 năm Mobile để ánh xạ nhanh sang tư duy thiết kế và vận hành backend Spring Boot.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 24),
              ...mappings.map((mapping) => _buildMappingCard(context, mapping)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMappingCard(BuildContext context, ConceptMapping mapping) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryCyan.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  mapping.topicName,
                  style: const TextStyle(color: AppColors.primaryCyan, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Side-by-side comparison row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Flutter Side
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.flutterBlue.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.flutterBlue.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.phone_iphone_rounded, color: AppColors.flutterBlue, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Mobile Flutter Concept',
                            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.flutterBlue, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        mapping.flutterConcept,
                        style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          mapping.flutterSnippet,
                          style: const TextStyle(fontFamily: 'monospace', color: AppColors.flutterBlue, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 40.0),
                  child: Icon(Icons.swap_horiz_rounded, color: AppColors.textMuted, size: 28),
                ),
              ),
              const SizedBox(width: 16),
              // Spring Side
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.springGreen.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.springGreen.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.dns_rounded, color: AppColors.springGreen, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Backend Spring Concept',
                            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.springGreen, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        mapping.springConcept,
                        style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          mapping.springSnippet,
                          style: const TextStyle(fontFamily: 'monospace', color: AppColors.springGreen, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Key Insight Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.accentAmber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.accentAmber.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_rounded, color: AppColors.accentAmber, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    mapping.keyInsight,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
