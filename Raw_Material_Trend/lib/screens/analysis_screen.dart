import 'package:flutter/material.dart';
import '../data/materials_data.dart';
import '../data/mock_analysis_data.dart';
import '../models/material_item.dart';
import '../models/material_analysis.dart';
import '../theme/app_colors.dart';
import '../widgets/price_chart_widget.dart';
import '../widgets/driver_card.dart';
import '../widgets/forward_estimate_card.dart';
import '../widgets/recommendation_section.dart';

class AnalysisScreen extends StatelessWidget {
  final String materialId;

  const AnalysisScreen({super.key, required this.materialId});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final material = getMaterialById(materialId);
    final analysis = getAnalysis(materialId);

    if (material == null || analysis == null) {
      return _NotFoundScreen(isDark: isDark);
    }

    return _AnalysisView(
      material: material,
      analysis: analysis,
      isDark: isDark,
    );
  }
}

class _AnalysisView extends StatelessWidget {
  final MaterialItem material;
  final MaterialAnalysis analysis;
  final bool isDark;

  const _AnalysisView({
    required this.material,
    required this.analysis,
    required this.isDark,
  });

  String _formatCurrentPrice() {
    final p = analysis.currentPrice;
    if (p >= 10000) return '\$${p.toStringAsFixed(0)}';
    if (p >= 1000) return '\$${p.toStringAsFixed(0)}';
    if (p < 10) return '\$${p.toStringAsFixed(2)}';
    return '\$${p.toStringAsFixed(1)}';
  }

  Color get _categoryColor {
    switch (material.category) {
      case MaterialCategory.metals:
        return AppColors.metals;
      case MaterialCategory.energy:
        return AppColors.energy;
      case MaterialCategory.agriculture:
        return AppColors.agriculture;
      case MaterialCategory.chemicals:
        return AppColors.chemicals;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textColor = isDark ? AppColors.textDark : AppColors.textLight;
    final secondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final muted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    final change1W = analysis.priceChange1W;
    final change1M = analysis.priceChange1M;
    final change1WColor = change1W >= 0 ? AppColors.up : AppColors.down;
    final change1MColor = change1M >= 0 ? AppColors.up : AppColors.down;

    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            backgroundColor: surface,
            surfaceTintColor: Colors.transparent,
            shadowColor:
                isDark ? AppColors.cardShadowDark : AppColors.cardShadowLight,
            elevation: 1,
            pinned: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  color: isDark ? AppColors.textDark : AppColors.textLight,
                  size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(
              children: [
                Text(material.emoji,
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(
                  material.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _categoryColor.withAlpha(isDark ? 40 : 25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      material.categoryLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _categoryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Price hero
          SliverToBoxAdapter(
            child: Container(
              color: surface,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatCurrentPrice(),
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          material.unit,
                          style: TextStyle(fontSize: 12, color: muted),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _ChangeBadge(
                        label: '1W',
                        value: change1W,
                        color: change1WColor,
                        isDark: isDark,
                      ),
                      const SizedBox(width: 10),
                      _ChangeBadge(
                        label: '1M',
                        value: change1M,
                        color: change1MColor,
                        isDark: isDark,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded,
                              size: 11, color: muted),
                          const SizedBox(width: 4),
                          Text(
                            analysis.dataTimestamp,
                            style: TextStyle(fontSize: 10, color: muted),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    material.description,
                    style: TextStyle(
                        fontSize: 13, color: secondary, height: 1.4),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Section 1: Price Trend ──────────────────────────────
                _SectionHeader(
                  icon: Icons.candlestick_chart_rounded,
                  title: 'Price Trend',
                  isDark: isDark,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: border),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? AppColors.cardShadowDark
                            : AppColors.cardShadowLight,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: PriceChartWidget(
                    analysis: analysis,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(height: 24),

                // ── Section 2: Driver Analysis ──────────────────────────
                _SectionHeader(
                  icon: Icons.psychology_rounded,
                  title: 'What\'s Driving the Price',
                  subtitle: 'Tap any card for detail',
                  isDark: isDark,
                ),
                const SizedBox(height: 12),
                ...analysis.drivers.map((d) => DriverCard(
                      driver: d,
                      isDark: isDark,
                    )),
                const SizedBox(height: 24),

                // ── Section 3: Forward Estimate ─────────────────────────
                _SectionHeader(
                  icon: Icons.timeline_rounded,
                  title: 'Forward Estimate',
                  isDark: isDark,
                ),
                const SizedBox(height: 12),
                ForwardEstimateCard(
                  forecast: analysis.forecast,
                  isDark: isDark,
                ),
                const SizedBox(height: 24),

                // ── Section 4: Recommendations ──────────────────────────
                _SectionHeader(
                  icon: Icons.lightbulb_outline_rounded,
                  title: 'Scenario Analysis',
                  isDark: isDark,
                ),
                const SizedBox(height: 12),
                RecommendationSection(
                  recommendations: analysis.recommendations,
                  isDark: isDark,
                ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool isDark;

  const _SectionHeader({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.textDark : AppColors.textLight;
    final muted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final primary = isDark ? AppColors.primaryLight : AppColors.primary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 18, color: primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(width: 8),
          Text(
            subtitle!,
            style: TextStyle(fontSize: 12, color: muted),
          ),
        ],
      ],
    );
  }
}

class _ChangeBadge extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final bool isDark;

  const _ChangeBadge({
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final sign = value >= 0 ? '+' : '';
    final icon =
        value >= 0 ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded;
    final bg = value >= 0
        ? (isDark ? AppColors.upBgDark : AppColors.upBg)
        : (isDark ? AppColors.downBgDark : AppColors.downBg);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color.withAlpha(200),
            ),
          ),
          const SizedBox(width: 5),
          Icon(icon, size: 11, color: color),
          Text(
            '$sign${value.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotFoundScreen extends StatelessWidget {
  final bool isDark;
  const _NotFoundScreen({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor:
            isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Text(
          'Material not found.',
          style: TextStyle(
            color: isDark ? AppColors.textDark : AppColors.textLight,
          ),
        ),
      ),
    );
  }
}
