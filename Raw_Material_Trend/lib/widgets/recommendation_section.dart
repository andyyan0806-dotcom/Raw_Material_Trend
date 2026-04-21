import 'package:flutter/material.dart';
import '../models/material_analysis.dart';
import '../theme/app_colors.dart';

class RecommendationSection extends StatelessWidget {
  final List<Recommendation> recommendations;
  final bool isDark;

  const RecommendationSection({
    super.key,
    required this.recommendations,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header with visual separator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.recommendationBgDark
                : AppColors.recommendationBgLight,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            border: Border.all(
              color: isDark
                  ? AppColors.recommendationBorderDark
                  : AppColors.recommendationBorderLight,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.primaryLight : AppColors.primary)
                      .withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.lightbulb_outline_rounded,
                  size: 16,
                  color: isDark ? AppColors.primaryLight : AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scenario Analysis',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textDark : AppColors.textLight,
                      ),
                    ),
                    Text(
                      'Conditional guidance — not financial advice',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark
                            ? AppColors.textMutedDark
                            : AppColors.textMutedLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Cards
        Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: isDark
                    ? AppColors.recommendationBorderDark
                    : AppColors.recommendationBorderLight,
              ),
              right: BorderSide(
                color: isDark
                    ? AppColors.recommendationBorderDark
                    : AppColors.recommendationBorderLight,
              ),
            ),
          ),
          child: Column(
            children: recommendations.map((rec) {
              return _RecommendationCard(rec: rec, isDark: isDark);
            }).toList(),
          ),
        ),
        // Disclaimer footer
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.recommendationBgDark
                : AppColors.recommendationBgLight,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            border: Border.all(
              color: isDark
                  ? AppColors.recommendationBorderDark
                  : AppColors.recommendationBorderLight,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.shield_outlined,
                size: 13,
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  'These scenarios are analytical in nature and do not constitute financial, '
                  'investment, or procurement advice. All commodity markets carry risk. '
                  'Consult qualified advisors before making material purchasing decisions.',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.5,
                    color:
                        isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final Recommendation rec;
  final bool isDark;

  const _RecommendationCard({required this.rec, required this.isDark});

  Color get _accentColor {
    switch (rec.scenario) {
      case RecommendationScenario.upside:
        return AppColors.up;
      case RecommendationScenario.downside:
        return AppColors.down;
      case RecommendationScenario.base:
        return isDark ? AppColors.primaryLight : AppColors.primary;
    }
  }

  IconData get _icon {
    switch (rec.scenario) {
      case RecommendationScenario.upside:
        return Icons.arrow_circle_up_outlined;
      case RecommendationScenario.downside:
        return Icons.arrow_circle_down_outlined;
      case RecommendationScenario.base:
        return Icons.radio_button_checked_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.recommendationBgDark
            : AppColors.recommendationBgLight,
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? AppColors.recommendationBorderDark
                : AppColors.recommendationBorderLight,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left accent bar + icon
          Column(
            children: [
              Icon(_icon, color: _accentColor, size: 20),
              const SizedBox(height: 6),
              Container(
                width: 2,
                height: 50,
                decoration: BoxDecoration(
                  color: _accentColor.withAlpha(60),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Scenario label
                Text(
                  rec.scenarioLabel,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _accentColor,
                  ),
                ),
                const SizedBox(height: 6),
                // Trigger
                _buildLabelRow(
                  icon: Icons.flash_on_rounded,
                  label: 'If:',
                  text: rec.trigger,
                ),
                const SizedBox(height: 8),
                // Action
                _buildLabelRow(
                  icon: Icons.check_circle_outline_rounded,
                  label: 'Consider:',
                  text: rec.action,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelRow({
    required IconData icon,
    required String label,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 12,
          color: _accentColor.withAlpha(180),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: _accentColor.withAlpha(200),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
        ),
      ],
    );
  }
}
