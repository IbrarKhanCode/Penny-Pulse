import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';

/// Donut pie chart showing Needs (emerald) vs Wants (rose) split.
/// Receives raw totals; callers read [needsVsWantsProvider].
class NeedsVsWantsPieChart extends StatefulWidget {
  const NeedsVsWantsPieChart({
    super.key,
    required this.needsTotal,
    required this.wantsTotal,
  });

  final double needsTotal;
  final double wantsTotal;

  @override
  State<NeedsVsWantsPieChart> createState() => _NeedsVsWantsPieChartState();
}

class _NeedsVsWantsPieChartState extends State<NeedsVsWantsPieChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final total = widget.needsTotal + widget.wantsTotal;

    if (total == 0) {
      return const _EmptyChart(message: 'Add expenses to see the breakdown');
    }

    final needsPct = (widget.needsTotal / total * 100).toStringAsFixed(0);
    final wantsPct = (widget.wantsTotal / total * 100).toStringAsFixed(0);

    return Row(
      children: [
        // ── Donut chart ─────────────────────────────────────────────────────
        Expanded(
          flex: 5,
          child: SizedBox(
            height: 160,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (event, response) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          response == null ||
                          response.touchedSection == null) {
                        _touchedIndex = -1;
                        return;
                      }
                      _touchedIndex =
                          response.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                startDegreeOffset: -90,
                centerSpaceRadius: 44,
                sectionsSpace: 3,
                sections: [
                  if (widget.needsTotal > 0)
                    PieChartSectionData(
                      color: AppColors.emerald,
                      value: widget.needsTotal,
                      title: '$needsPct%',
                      radius: _touchedIndex == 0 ? 68 : 56,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  if (widget.wantsTotal > 0)
                    PieChartSectionData(
                      color: AppColors.rose,
                      value: widget.wantsTotal,
                      title: '$wantsPct%',
                      radius: _touchedIndex == 1 ? 68 : 56,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        // ── Legend ──────────────────────────────────────────────────────────
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LegendRow(
                color: AppColors.emerald,
                label: 'Needs',
                amount: formatCurrency(widget.needsTotal),
                isActive: _touchedIndex != 1,
              ),
              const SizedBox(height: 14),
              _LegendRow(
                color: AppColors.rose,
                label: 'Wants',
                amount: formatCurrency(widget.wantsTotal),
                isActive: _touchedIndex != 0,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Private helpers ──────────────────────────────────────────────────────────

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.color,
    required this.label,
    required this.amount,
    required this.isActive,
  });

  final Color color;
  final String label;
  final String amount;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isActive ? 1.0 : 0.4,
      duration: const Duration(milliseconds: 200),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
              Text(
                amount,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyChart extends StatelessWidget {
  const _EmptyChart({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Center(
        child: Text(
          message,
          style: const TextStyle(color: AppColors.textTertiary, fontSize: 13),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
