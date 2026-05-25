import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../data/models/expense.dart';
import '../state/expenses_controller.dart';
import '../widgets/expense_tile.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  String _activeFilter = 'ALL';

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(historyProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Status-bar space ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: SizedBox(height: MediaQuery.of(context).padding.top + 8),
          ),

          // ── Header ───────────────────────────────────────────────────────
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 4,
                        backgroundColor: AppColors.neonGreen,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'ACTIVITY',
                        style: TextStyle(
                          color: AppColors.neonGreen,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    'TRANSACTIONS',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                      height: 1.1,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Track every dollar in and out',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Summary cards ────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            sliver: SliverToBoxAdapter(
              child: historyAsync.when(
                loading: () => const SizedBox(height: 80),
                error: (_, __) => const SizedBox.shrink(),
                data: (expenses) => _SummaryRow(expenses: expenses),
              ),
            ),
          ),

          // ── Filter chips ─────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 18, 0, 0),
            sliver: SliverToBoxAdapter(
              child: historyAsync.maybeWhen(
                data: (expenses) => _FilterChips(
                  categories: _buildCategories(expenses),
                  active: _activeFilter,
                  onChanged: (f) => setState(() => _activeFilter = f),
                ),
                orElse: () => const SizedBox.shrink(),
              ),
            ),
          ),

          // ── Transaction list ─────────────────────────────────────────────
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
                            : 'Something went wrong',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),
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
              final filtered = _applyFilter(expenses, _activeFilter);
              if (filtered.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.receipt_long_outlined,
                          size: 64,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _activeFilter == 'ALL'
                              ? 'No transactions yet'
                              : 'No $_activeFilter transactions',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Group by date label
              final grouped = _groupByDate(filtered);
              final keys = grouped.keys.toList();

              return SliverList.builder(
                itemCount: keys.length + 1,
                itemBuilder: (context, idx) {
                  if (idx == keys.length) {
                    return const SizedBox(height: 110);
                  }
                  final dateLabel = keys[idx];
                  final dayExpenses = grouped[dateLabel]!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                        child: Text(
                          dateLabel,
                          style: const TextStyle(
                            color: AppColors.textTertiary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      ...dayExpenses.map(
                        (expense) => Slidable(
                          key: ValueKey(expense.id),
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            extentRatio: 0.25,
                            children: [
                              SlidableAction(
                                onPressed: (context) async {
                                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                                  try {
                                    await ref
                                        .read(historyProvider.notifier)
                                        .deleteExpense(expense.id);
                                    scaffoldMessenger.showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Transaction deleted successfully',
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    scaffoldMessenger.showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          e is AppException
                                              ? e.message
                                              : 'Failed to delete transaction',
                                        ),
                                        backgroundColor: AppColors.rose,
                                      ),
                                    );
                                  }
                                },
                                backgroundColor: AppColors.rose,
                                foregroundColor: Colors.white,
                                icon: Icons.delete_outline_rounded,
                                label: 'Delete',
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ],
                          ),
                          child: ExpenseTile(
                            expense: expense,
                            onTap: () =>
                                context.push('/detail', extra: expense),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  List<String> _buildCategories(List<Expense> expenses) {
    final cats =
        expenses
            .map(
              (e) => e.category.isEmpty
                  ? 'Other'
                  : e.category[0].toUpperCase() + e.category.substring(1),
            )
            .toSet()
            .toList()
          ..sort();
    return ['ALL', 'EXPENSES', ...cats];
  }

  List<Expense> _applyFilter(List<Expense> expenses, String filter) {
    if (filter == 'ALL' || filter == 'EXPENSES') return expenses;
    return expenses.where((e) {
      final cat = e.category.isEmpty
          ? 'Other'
          : e.category[0].toUpperCase() + e.category.substring(1);
      return cat == filter;
    }).toList();
  }

  Map<String, List<Expense>> _groupByDate(List<Expense> expenses) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final result = <String, List<Expense>>{};
    for (final e in expenses) {
      final d = DateTime(e.date.year, e.date.month, e.date.day);
      final String label;
      if (d == today) {
        label = 'TODAY — ${_shortDate(e.date)}';
      } else if (d == yesterday) {
        label = 'YESTERDAY — ${_shortDate(e.date)}';
      } else {
        label = _shortDate(e.date).toUpperCase();
      }
      result.putIfAbsent(label, () => []).add(e);
    }
    return result;
  }

  String _shortDate(DateTime d) {
    final months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    return '${months[d.month - 1]} ${d.day}';
  }
}

// ── Summary row (Needs + Expenses) ───────────────────────────────────────────

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.expenses});
  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    final needsTotal = expenses
        .where((e) => e.needWant.toLowerCase() == 'need')
        .fold<double>(0, (s, e) => s + e.amount);
    final wantsTotal = expenses
        .where((e) => e.needWant.toLowerCase() == 'want')
        .fold<double>(0, (s, e) => s + e.amount);

    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            label: 'NEEDS',
            amount: needsTotal,
            pct: '+12%',
            color: AppColors.emerald,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            label: 'EXPENSES',
            amount: wantsTotal,
            pct: '-5%',
            color: AppColors.rose,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.pct,
    required this.color,
  });
  final String label;
  final double amount;
  final String pct;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withAlpha(30),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  pct,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            formatCurrency(amount),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Filter chips ─────────────────────────────────────────────────────────────

class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.categories,
    required this.active,
    required this.onChanged,
  });
  final List<String> categories;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final cat = categories[i];
          final isActive = cat == active;
          return GestureDetector(
            onTap: () => onChanged(cat),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isActive ? AppColors.neonGreen : AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isActive ? AppColors.neonGreen : AppColors.cardBorder,
                ),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  color: isActive
                      ? AppColors.neonGreenDark
                      : AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
