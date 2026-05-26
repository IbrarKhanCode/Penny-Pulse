import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../budget/presentation/state/budget_notifier.dart';
import '../../../budget/presentation/widgets/budget_dialog.dart';
import '../state/expenses_controller.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  bool _isMonthly = true;

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(historyProvider);
    final budgetAsync = ref.watch(budgetProvider);
    final currentBudget = budgetAsync.valueOrNull;
    // Watch derived providers to keep state fresh
    ref.watch(needsVsWantsProvider);
    ref.watch(categoryBreakdownProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Status-bar space ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: SizedBox(height: MediaQuery.of(context).padding.top + 8),
          ),

          // ── Header ───────────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                          height: 1.1,
                        ),
                        children: [
                          TextSpan(
                            text: 'YOUR M—01\n',
                            style: TextStyle(color: AppColors.textPrimary),
                          ),
                          TextSpan(
                            text: 'BUDGET',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _ToggleTab(
                              label: 'MONTHLY',
                              active: _isMonthly,
                              onTap: () => setState(() => _isMonthly = true),
                            ),
                            _ToggleTab(
                              label: 'YEARLY',
                              active: !_isMonthly,
                              onTap: () => setState(() => _isMonthly = false),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      PopupMenuButton<_BudgetAction>(
                        tooltip: 'Budget options',
                        color: AppColors.surface,
                        icon: const Icon(
                          Icons.more_vert_rounded,
                          color: AppColors.textSecondary,
                        ),
                        onSelected: (action) =>
                            _handleBudgetAction(context, action, currentBudget),
                        itemBuilder: (context) {
                          final hasBudget = currentBudget != null;
                          return [
                            PopupMenuItem(
                              value: hasBudget
                                  ? _BudgetAction.edit
                                  : _BudgetAction.set,
                              child: Text(
                                hasBudget ? 'Edit budget' : 'Set budget',
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            if (hasBudget)
                              const PopupMenuItem(
                                value: _BudgetAction.clear,
                                child: Text(
                                  'Remove budget',
                                  style: TextStyle(color: AppColors.rose),
                                ),
                              ),
                          ];
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Content ──────────────────────────────────────────────────────
          historyAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.neonGreen,
                  strokeWidth: 2,
                ),
              ),
            ),
            error: (err, _) => SliverFillRemaining(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.wifi_off_rounded,
                        size: 52,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        err is Exception
                            ? err.toString()
                            : 'Could not load data',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: () =>
                            ref.read(historyProvider.notifier).refresh(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            data: (expenses) {
              if (budgetAsync.isLoading) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.neonGreen,
                      strokeWidth: 2,
                    ),
                  ),
                );
              }
              if (currentBudget == null) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.pie_chart_outline_rounded,
                          size: 64,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No budget set yet',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Set a budget to view your analytics',
                          style: TextStyle(
                            color: AppColors.textTertiary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: 142,
                          height: 40,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              textStyle: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                              minimumSize: const Size(0, 40),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () async {
                              final value = await BudgetDialog.show(context);
                              if (value == null || !context.mounted) {
                                return;
                              }
                              await ref
                                  .read(budgetProvider.notifier)
                                  .saveBudget(value);
                            },
                            child: const Text('Set Budget'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (expenses.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.pie_chart_outline_rounded,
                          size: 64,
                          color: AppColors.textTertiary,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No expenses yet',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Add expenses to see your budget analytics',
                          style: TextStyle(
                            color: AppColors.textTertiary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Filter by period
              final now = DateTime.now();
              final periodExpenses = _isMonthly
                  ? expenses
                        .where(
                          (e) =>
                              e.date.year == now.year &&
                              e.date.month == now.month,
                        )
                        .toList()
                  : expenses.where((e) => e.date.year == now.year).toList();

              final totalSpent = periodExpenses.fold<double>(
                0,
                (s, e) => s + e.amount,
              );
              final budget = budgetAsync.valueOrNull;
              final totalBudget = budget ?? totalSpent;
              final remaining = totalBudget - totalSpent;
              final needsPeriod = periodExpenses
                  .where((e) => e.needWant.toLowerCase() == 'need')
                  .fold<double>(0, (s, e) => s + e.amount);
              final wantsPeriod = periodExpenses
                  .where((e) => e.needWant.toLowerCase() == 'want')
                  .fold<double>(0, (s, e) => s + e.amount);

              // Category breakdown for the period
              final catMap = <String, double>{};
              for (final e in periodExpenses) {
                final cat = e.category.isEmpty
                    ? 'Other'
                    : e.category[0].toUpperCase() + e.category.substring(1);
                catMap[cat] = (catMap[cat] ?? 0) + e.amount;
              }
              final sortedCats = catMap.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value));

              // Spent % of budget (or total spent if no budget yet)
              final usedPct = totalBudget > 0
                  ? (totalSpent / totalBudget * 100).round()
                  : 0;

              return SliverList(
                delegate: SliverChildListDelegate([
                  // ── Gauge card ─────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: _GaugeCard(
                      usedPct: usedPct,
                      spent: totalSpent,
                      total: totalBudget,
                      left: remaining,
                      isMonthly: _isMonthly,
                    ),
                  ),

                  // ── Categories header ──────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'CATEGORIES',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.textTertiary,
                          size: 18,
                        ),
                      ],
                    ),
                  ),

                  // ── Category rows ──────────────────────────────────────
                  ...sortedCats.map(
                    (entry) => _CategoryRow(
                      name: entry.key,
                      amount: entry.value,
                      total: totalSpent,
                    ),
                  ),

                  const SizedBox(height: 110),
                ]),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _handleBudgetAction(
    BuildContext context,
    _BudgetAction action,
    double? currentBudget,
  ) async {
    if (action == _BudgetAction.clear) {
      final confirmed = await _confirmClearBudget(context);
      if (confirmed != true || !context.mounted) {
        return;
      }
      await ref.read(budgetProvider.notifier).clearBudget();
      return;
    }

    final value = await BudgetDialog.show(
      context,
      initialValue: action == _BudgetAction.edit ? currentBudget : null,
    );
    if (value == null || !context.mounted) {
      return;
    }
    await ref.read(budgetProvider.notifier).saveBudget(value);
  }

  Future<bool?> _confirmClearBudget(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Remove budget?',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'Your budget will be cleared for this account.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.rose),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}

enum _BudgetAction { set, edit, clear }

// ── Toggle tab ───────────────────────────────────────────────────────────────

class _ToggleTab extends StatelessWidget {
  const _ToggleTab({
    required this.label,
    required this.active,
    required this.onTap,
  });
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? AppColors.neonGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? AppColors.neonGreenDark : AppColors.textTertiary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

// ── Gauge card ────────────────────────────────────────────────────────────────

class _GaugeCard extends StatelessWidget {
  const _GaugeCard({
    required this.usedPct,
    required this.spent,
    required this.total,
    required this.left,
    required this.isMonthly,
  });
  final int usedPct;
  final double spent;
  final double total;
  final double left;
  final bool isMonthly;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.purpleContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.purple.withAlpha(60)),
      ),
      child: Column(
        children: [
          // Percentage gauge
          SizedBox(
            width: 130,
            height: 130,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: usedPct / 100,
                    strokeWidth: 10,
                    backgroundColor: AppColors.surface,
                    valueColor: const AlwaysStoppedAnimation(
                      AppColors.neonGreen,
                    ),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$usedPct%',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),
                    Text(
                      isMonthly ? 'SPENT\nTHIS MONTH' : 'SPENT\nTHIS YEAR',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: total > 0 ? usedPct / 100 : 0,
              minHeight: 6,
              backgroundColor: AppColors.surface,
              valueColor: const AlwaysStoppedAnimation(AppColors.neonGreen),
            ),
          ),
          const SizedBox(height: 16),
          // Stats row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _GaugeStat(
                  label: 'SPENT',
                  value: formatCurrency(spent),
                  color: AppColors.rose,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _GaugeStat(
                  label: 'BUDGET',
                  value: formatCurrency(total),
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _GaugeStat(
                  label: 'LEFT',
                  value: formatCurrency(left),
                  color: AppColors.emerald,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GaugeStat extends StatelessWidget {
  const _GaugeStat({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            maxLines: 1,
            style: TextStyle(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Category row ─────────────────────────────────────────────────────────────

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.name,
    required this.amount,
    required this.total,
  });
  final String name;
  final double amount;
  final double total;

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? amount / total : 0.0;
    final color = _colorForCategory(name);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_iconForCategory(name), color: color, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      '${(pct * 100).round()}% of total',
                      style: const TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                formatCurrency(amount),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct.toDouble(),
              minHeight: 5,
              backgroundColor: AppColors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }

  static Color _colorForCategory(String cat) {
    final lower = cat.toLowerCase();
    if (lower.contains('food') ||
        lower.contains('grocer') ||
        lower.contains('dining') ||
        lower.contains('restaurant')) {
      return const Color(0xFFF59E0B);
    }
    if (lower.contains('transport') ||
        lower.contains('uber') ||
        lower.contains('car')) {
      return AppColors.purple;
    }
    if (lower.contains('entertainment') || lower.contains('movie')) {
      return const Color(0xFF06B6D4);
    }
    if (lower.contains('health') ||
        lower.contains('medical') ||
        lower.contains('pharmacy')) {
      return AppColors.emerald;
    }
    if (lower.contains('shopping') || lower.contains('cloth')) {
      return AppColors.rose;
    }
    return AppColors.purpleLight;
  }

  static IconData _iconForCategory(String cat) {
    final lower = cat.toLowerCase();
    if (lower.contains('food') ||
        lower.contains('grocer') ||
        lower.contains('dining') ||
        lower.contains('restaurant')) {
      return Icons.restaurant_outlined;
    }
    if (lower.contains('transport') ||
        lower.contains('uber') ||
        lower.contains('car')) {
      return Icons.directions_car_outlined;
    }
    if (lower.contains('entertainment') || lower.contains('movie')) {
      return Icons.movie_outlined;
    }
    if (lower.contains('health') ||
        lower.contains('medical') ||
        lower.contains('pharmacy')) {
      return Icons.medical_services_outlined;
    }
    if (lower.contains('shopping') || lower.contains('cloth')) {
      return Icons.shopping_bag_outlined;
    }
    return Icons.category_outlined;
  }
}
