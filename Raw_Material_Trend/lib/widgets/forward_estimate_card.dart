import 'package:flutter/material.dart';
import '../models/material_analysis.dart';
import '../theme/app_colors.dart';

class ForwardEstimateCard extends StatelessWidget {
  final List<ForecastHorizon> forecast;
  final bool isDark;

  const ForwardEstimateCard({
    super.key,
    required this.forecast,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.cardShadowDark : AppColors.cardShadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.primaryLight : AppColors.primary)
                      .withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.show_chart_rounded,
                  size: 16,
                  color: isDark ? AppColors.primaryLight : AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Price Outlook',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textDark : AppColors.textLight,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.primaryLight : AppColors.primary)
                      .withAlpha(15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Probabilistic estimate',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.primaryLight : AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Ranges reflect uncertainty — wider bands signal lower confidence.',
            style: TextStyle(
              fontSize: 11,
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
          ),
          const SizedBox(height: 16),
          ...forecast.asMap().entries.map((entry) {
            final i = entry.key;
            final h = entry.value;
            return Padding(
              padding: EdgeInsets.only(bottom: i < forecast.length - 1 ? 18 : 0),
              child: _HorizonRow(horizon: h, isDark: isDark),
            );
          }),
        ],
      ),
    );
  }
}

class _HorizonRow extends StatelessWidget {
  final ForecastHorizon horizon;
  final bool isDark;

  const _HorizonRow({required this.horizon, required this.isDark});

  @override
  Widget build(BuildContext context) {
    // Clamp values to a sensible display range (-30 to +50)
    const displayMin = -30.0;
    const displayMax = 50.0;
    const displayRange = displayMax - displayMin;

    final lowClamped = horizon.low.clamp(displayMin, displayMax);
    final highClamped = horizon.high.clamp(displayMin, displayMax);
    final midClamped = horizon.mid.clamp(displayMin, displayMax);

    final lowFrac = (lowClamped - displayMin) / displayRange;
    final highFrac = (highClamped - displayMin) / displayRange;
    final midFrac = (midClamped - displayMin) / displayRange;
    const zeroFrac = (0.0 - displayMin) / displayRange;

    final isNegativeMid = horizon.mid < 0;
    final midColor = isNegativeMid ? AppColors.down : AppColors.up;

    final confidencePct = (horizon.confidence * 100).round();
    final lineColor = isDark ? AppColors.primaryLight : AppColors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              horizon.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textDark : AppColors.textLight,
              ),
            ),
            Row(
              children: [
                Text(
                  '${horizon.low > 0 ? "+" : ""}${horizon.low.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
                Text(
                  ' to ',
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
                Text(
                  '${horizon.high > 0 ? "+" : ""}${horizon.high.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${horizon.mid > 0 ? "+" : ""}${horizon.mid.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: midColor,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Range bar
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            return SizedBox(
              height: 28,
              child: Stack(
                children: [
                  // Track
                  Positioned(
                    top: 10,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  // Zero line
                  Positioned(
                    top: 6,
                    left: zeroFrac * width - 1,
                    child: Container(
                      width: 2,
                      height: 14,
                      color: isDark
                          ? AppColors.textMutedDark
                          : AppColors.textMutedLight,
                    ),
                  ),
                  // Range fill (confidence band)
                  Positioned(
                    top: 10,
                    left: lowFrac * width,
                    width: (highFrac - lowFrac) * width,
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: lineColor.withAlpha(
                            (horizon.confidence * 100).round()),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  // Mid-point dot
                  Positioned(
                    top: 7,
                    left: (midFrac * width - 6).clamp(0, width - 12),
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: midColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: midColor.withAlpha(80),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '−30%',
              style: TextStyle(
                fontSize: 9,
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              ),
            ),
            Text(
              '0%',
              style: TextStyle(
                fontSize: 9,
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              ),
            ),
            Row(
              children: [
                Icon(Icons.info_outline_rounded,
                    size: 10,
                    color: isDark
                        ? AppColors.textMutedDark
                        : AppColors.textMutedLight),
                const SizedBox(width: 3),
                Text(
                  '$confidencePct% confidence',
                  style: TextStyle(
                    fontSize: 9,
                    color:
                        isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '+50%',
                  style: TextStyle(
                    fontSize: 9,
                    color: isDark
                        ? AppColors.textMutedDark
                        : AppColors.textMutedLight,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
