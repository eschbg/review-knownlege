import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../data/concept_mappings_data.dart';
import '../models/roadmap_models.dart';

class ConceptMappingScreen extends StatelessWidget {
  const ConceptMappingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mappings = ConceptMappingsData.getMappings();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cross-Domain Concept Matrix',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Technical Mental Model Bridge: Mobile Flutter ↔ Spring Backend',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.compare_arrows_rounded, color: AppColors.flutterBlue, size: 16),
                    SizedBox(width: 6),
                    Text('5 Core Paradigms', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Mapping Cards List
          ...mappings.map((mapping) => _buildMappingCard(context, mapping)),
        ],
      ),
    );
  }

  Widget _buildMappingCard(BuildContext context, ConceptMapping mapping) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Topic Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                const Icon(Icons.hub_outlined, color: AppColors.primaryIndigo, size: 18),
                const SizedBox(width: 10),
                Text(
                  mapping.topicName,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Side-by-side Paradigm Comparison Grid
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Flutter Paradigm Box
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.flutterBlue.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.phone_android_rounded, color: AppColors.flutterBlue, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  'Flutter / Mobile Paradigm',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.flutterBlue, fontSize: 12),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              mapping.flutterConcept,
                              style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
                            ),
                            const SizedBox(height: 12),
                            _buildCodeBlock(mapping.flutterSnippet, AppColors.flutterBlue),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Spring Paradigm Box
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.springGreen.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.dns_rounded, color: AppColors.springGreen, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  'Spring Backend Paradigm',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.springGreen, fontSize: 12),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              mapping.springConcept,
                              style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
                            ),
                            const SizedBox(height: 12),
                            _buildCodeBlock(mapping.springSnippet, AppColors.springGreen),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Key Insight Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.lightbulb_outline_rounded, color: AppColors.accentAmber, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          mapping.keyInsight,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.4),
                        ),
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

  Widget _buildCodeBlock(String code, Color accentColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF0C0C0E),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        code,
        style: TextStyle(
          fontFamily: 'monospace',
          color: accentColor,
          fontSize: 11,
          height: 1.4,
        ),
      ),
    );
  }
}
