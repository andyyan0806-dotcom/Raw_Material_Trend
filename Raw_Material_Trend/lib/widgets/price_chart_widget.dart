import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/material_analysis.dart';
import '../theme/app_colors.dart';

class PriceChartWidget extends StatefulWidget {
  final MaterialAnalysis analysis;
  final bool isDark;

  const PriceChartWidget({
    super.key,
    required this.analysis,
    required this.isDark,
  });

  @override
  State<PriceChartWidget> createState() => _PriceChartWidgetState();
}

class _PriceChartWidgetState extends State<PriceChartWidget> {
  TimeRange _selectedRange = TimeRange.oneYear;
  int? _expandedEventIndex;

  List<PricePoint> get _data => widget.analysis.dataForRange(_selectedRange);

  Color get _lineColor =>
      widget.isDark ? AppColors.chartLineDark : AppColors.chartLine;

  Color get _fillColor =>
      widget.isDark ? const Color(0x1A4A90D9) : const Color(0x141E3A5F);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRangeSelector(),
        const SizedBox(height: 12),
        _buildChart(),
        const SizedBox(height: 16),
        _buildEventMarkers(),
      ],
    );
  }

  Widget _buildRangeSelector() {
    const ranges = TimeRange.values;
    return Row(
      children: ranges.map((r) {
        final selected = r == _selectedRange;
        return GestureDetector(
          onTap: () => setState(() {
            _selectedRange = r;
          }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: selected
                  ? (widget.isDark ? AppColors.primaryLight : AppColors.primary)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected
                    ? Colors.transparent
                    : (widget.isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
            ),
            child: Text(
              r.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected
                    ? Colors.white
                    : (widget.isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChart() {
    final data = _data;
    if (data.isEmpty) return const SizedBox(height: 200);

    final values = data.map((p) => p.value).toList();
    final minVal = values.reduce((a, b) => a < b ? a : b);
    final maxVal = values.reduce((a, b) => a > b ? a : b);
    final padding = (maxVal - minVal) * 0.15;

    final spots = <FlSpot>[];
    for (int i = 0; i < data.length; i++) {
      spots.add(FlSpot(i.toDouble(), data[i].value));
    }

    // Show fewer labels based on range
    final labelStep = _selectedRange == TimeRange.oneYear
        ? 8
        : _selectedRange == TimeRange.sixMonths
            ? 4
            : _selectedRange == TimeRange.threeMonths
                ? 3
                : 1;

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          minY: minVal - padding,
          maxY: maxVal + padding,
          clipData: const FlClipData.all(),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: (maxVal - minVal + 2 * padding) / 4,
            getDrawingHorizontalLine: (_) => FlLine(
              color: widget.isDark
                  ? AppColors.borderDark.withAlpha(120)
                  : AppColors.borderLight,
              strokeWidth: 1,
              dashArray: [4, 4],
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 56,
                getTitlesWidget: (value, meta) {
                  if (value == meta.min || value == meta.max) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      _formatPrice(value),
                      style: TextStyle(
                        fontSize: 10,
                        color: widget.isDark
                            ? AppColors.textMutedDark
                            : AppColors.textMutedLight,
                      ),
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                interval: labelStep.toDouble(),
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= data.length) return const SizedBox();
                  if (idx % labelStep != 0) return const SizedBox();
                  return Text(
                    data[idx].label,
                    style: TextStyle(
                      fontSize: 9,
                      color: widget.isDark
                          ? AppColors.textMutedDark
                          : AppColors.textMutedLight,
                    ),
                  );
                },
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            enabled: true,
            touchCallback: (event, response) {},
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) =>
                  widget.isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              tooltipBorder: BorderSide(
                color: widget.isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
              tooltipRoundedRadius: 8,
              getTooltipItems: (spots) {
                return spots.map((s) {
                  final idx = s.spotIndex;
                  final point = data[idx];
                  return LineTooltipItem(
                    '${point.label}\n',
                    TextStyle(
                      fontSize: 11,
                      color: widget.isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                    children: [
                      TextSpan(
                        text: _formatPrice(point.value),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: widget.isDark ? AppColors.textDark : AppColors.textLight,
                        ),
                      ),
                    ],
                  );
                }).toList();
              },
            ),
            getTouchedSpotIndicator: (barData, indices) {
              return indices.map((_) {
                return TouchedSpotIndicatorData(
                  FlLine(color: _lineColor, strokeWidth: 1, dashArray: [4, 4]),
                  FlDotData(
                    getDotPainter: (spot, percent, bar, index) {
                      return FlDotCirclePainter(
                        radius: 5,
                        color: _lineColor,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                );
              }).toList();
            },
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.35,
              color: _lineColor,
              barWidth: 2.2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: _fillColor,
              ),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 300),
      ),
    );
  }

  Widget _buildEventMarkers() {
    // Only show events that fall within the current time range
    final data = _data;
    final totalPoints = widget.analysis.priceData1Y.length;
    final rangeStart = totalPoints - data.length;

    final visibleEvents = widget.analysis.events.where((e) {
      return e.weekIndex >= rangeStart;
    }).toList();

    if (visibleEvents.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Events',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: widget.isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: visibleEvents.asMap().entries.map((entry) {
            final i = entry.key;
            final event = entry.value;
            final expanded = _expandedEventIndex == i;
            final color = event.impact == PriceDirection.up
                ? AppColors.up
                : event.impact == PriceDirection.down
                    ? AppColors.down
                    : AppColors.neutral;
            final icon = event.impact == PriceDirection.up
                ? Icons.arrow_upward_rounded
                : event.impact == PriceDirection.down
                    ? Icons.arrow_downward_rounded
                    : Icons.remove_rounded;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _expandedEventIndex = expanded ? null : i;
                });
              },
              child: AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: color.withAlpha(widget.isDark ? 30 : 20),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: color.withAlpha(80)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon, size: 12, color: color),
                          const SizedBox(width: 5),
                          Text(
                            event.title,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: color,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            expanded
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            size: 14,
                            color: color.withAlpha(180),
                          ),
                        ],
                      ),
                      if (expanded) ...[
                        const SizedBox(height: 6),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            event.detail,
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.5,
                              color: widget.isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _formatPrice(double value) {
    if (value >= 10000) {
      return '\$${(value / 1000).toStringAsFixed(1)}k';
    } else if (value >= 1000) {
      return '\$${value.toStringAsFixed(0)}';
    } else if (value < 10) {
      return '\$${value.toStringAsFixed(2)}';
    } else {
      return '\$${value.toStringAsFixed(1)}';
    }
  }
}
