import 'package:flutter/material.dart';
import '../models/material_analysis.dart';
import '../theme/app_colors.dart';

class DriverCard extends StatefulWidget {
  final Driver driver;
  final bool isDark;

  const DriverCard({super.key, required this.driver, required this.isDark});

  @override
  State<DriverCard> createState() => _DriverCardState();
}

class _DriverCardState extends State<DriverCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _controller;
  late Animation<double> _expandAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _expandAnim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _directionColor {
    switch (widget.driver.direction) {
      case PriceDirection.up:
        return AppColors.up;
      case PriceDirection.down:
        return AppColors.down;
      case PriceDirection.neutral:
        return AppColors.neutral;
    }
  }

  Color get _directionBg {
    final isDark = widget.isDark;
    switch (widget.driver.direction) {
      case PriceDirection.up:
        return isDark ? AppColors.upBgDark : AppColors.upBg;
      case PriceDirection.down:
        return isDark ? AppColors.downBgDark : AppColors.downBg;
      case PriceDirection.neutral:
        return isDark ? AppColors.neutralBgDark : AppColors.neutralBg;
    }
  }

  IconData get _directionIcon {
    switch (widget.driver.direction) {
      case PriceDirection.up:
        return Icons.trending_up_rounded;
      case PriceDirection.down:
        return Icons.trending_down_rounded;
      case PriceDirection.neutral:
        return Icons.trending_flat_rounded;
    }
  }

  String get _magnitudeLabel {
    switch (widget.driver.magnitude) {
      case DriverMagnitude.strong:
        return 'Strong';
      case DriverMagnitude.moderate:
        return 'Moderate';
      case DriverMagnitude.mild:
        return 'Mild';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _expanded = !_expanded;
          _expanded ? _controller.forward() : _controller.reverse();
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: widget.isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: widget.isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.isDark
                  ? AppColors.cardShadowDark
                  : AppColors.cardShadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  // Direction indicator
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _directionBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(_directionIcon, color: _directionColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  // Headline + magnitude
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.driver.headline,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: widget.isDark
                                ? AppColors.textDark
                                : AppColors.textLight,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: _directionColor.withAlpha(20),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _magnitudeLabel,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: _directionColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Tap for detail',
                              style: TextStyle(
                                fontSize: 11,
                                color: widget.isDark
                                    ? AppColors.textMutedDark
                                    : AppColors.textMutedLight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Chevron
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: widget.isDark
                          ? AppColors.textMutedDark
                          : AppColors.textMutedLight,
                    ),
                  ),
                ],
              ),
            ),
            SizeTransition(
              sizeFactor: _expandAnim,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: Column(
                  children: [
                    Divider(
                      color: widget.isDark
                          ? AppColors.borderDark
                          : AppColors.borderLight,
                      height: 1,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.driver.explanation,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.6,
                        color: widget.isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
