import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';

/// Vertical bar chart showing total spending per category.
/// Receives the breakdown map from [categoryBreakdownProvider].
class CategoryBarChart extends StatefulWidget {
  const CategoryBarChart({super.key, required this.data});

  /// {Category name: total amount}
  final Map<String, double> data;

  @override
  State<CategoryBarChart> createState() => _CategoryBarChartState();
}

class _CategoryBarChartState extends State<CategoryBarChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'No data yet',
            style: TextStyle(color: AppColors.textTertiary),
          ),
        ),
      );
    }

    // Sort desc, cap at 6 categories
    final entries =
        (widget.data.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value)))
            .take(6)
            .toList();

    final maxY = entries.first.value * 1.25;

    return SizedBox(
      height: 220,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          minY: 0,
        // ── Touch ───────────────────────────────────────────────────────────
          barTouchData: BarTouchData(
          touchCallback: (event, response) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  response == null ||
                  response.spot == null) {
                _touchedIndex = -1;
                return;
              }
              _touchedIndex = response.spot!.touchedBarGroupIndex;
            });
          },
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => AppColors.surfaceVariant,
            tooltipPadding: const EdgeInsets.all(8),
            tooltipMargin: 6,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final cat = entries[groupIndex].key;
              return BarTooltipItem(
                '$cat\n',
                const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                children: [
                  TextSpan(
                    text: formatCurrency(rod.toY),
                    style: const TextStyle(
                      color: AppColors.emerald,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        // ── Axes ────────────────────────────────────────────────────────────
          titlesData: FlTitlesData(
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= entries.length) {
                  return const SizedBox.shrink();
                }
                final name = entries[idx].key;
                final label = name.length > 7
                    ? '${name.substring(0, 6)}.'
                    : name;
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 48,
              interval: maxY / 4,
              getTitlesWidget: (value, meta) {
                if (value == 0 || value >= maxY) return const SizedBox.shrink();
                final label = value >= 1000
                  ? 'PKR ${(value / 1000).toStringAsFixed(1)}k'
                  : 'PKR ${value.toStringAsFixed(0)}';
                return Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
        ),
        // ── Grid / Border ────────────────────────────────────────────────────
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 4,
          getDrawingHorizontalLine: (_) =>
              const FlLine(color: AppColors.surfaceVariant, strokeWidth: 1),
        ),
        // ── Bars ─────────────────────────────────────────────────────────────
          barGroups: List.generate(entries.length, (i) {
          final isTouched = i == _touchedIndex;
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: entries[i].value,
                color: isTouched ? AppColors.emeraldDim : AppColors.emerald,
                width: 26,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(6),
                ),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: maxY,
                  color: AppColors.surfaceVariant,
                ),
              ),
            ],
          );
        }),
        ),
      ),
    );
  }
}
