import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/shell_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../auth/presentation/state/profile_provider.dart';
import '../../../budget/presentation/state/budget_notifier.dart';
import '../../data/models/expense.dart';
import '../state/expenses_controller.dart';
import '../widgets/expense_tile.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // 0 = Week, 1 = Month, 2 = Year
  int _chartRange = 0;

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(historyProvider);
    final profileAsync = ref.watch(profileProvider);
    final (needsTotal, wantsTotal) = ref.watch(needsVsWantsProvider);
    final budgetAsync = ref.watch(budgetProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.neonGreen,
        backgroundColor: AppColors.surface,
        onRefresh: () => ref.read(historyProvider.notifier).refresh(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // ── Status-bar space ─────────────────────────────────────────
            SliverToBoxAdapter(
              child: SizedBox(height: MediaQuery.of(context).padding.top + 8),
            ),

            // ── Header row ───────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'M—01',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: profileAsync.when(
                        data: (profile) => _UserBadge(email: profile.email),
                        loading: () => const _UserBadgeSkeleton(),
                        error: (_, __) => const _UserBadge(email: 'Account'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Hero text ────────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Good morning',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                          letterSpacing: -1,
                        ),
                        children: [
                          TextSpan(
                            text: 'YOUR ',
                            style: TextStyle(color: AppColors.textPrimary),
                          ),
                          TextSpan(
                            text: 'TOTAL\n',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                          TextSpan(
                            text: 'BALANCE',
                            style: TextStyle(color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Purple balance card ──────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: historyAsync.when(
                  loading: () => const _BalanceCardSkeleton(),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (expenses) => _BalanceCard(
                    expenses: expenses,
                    needsTotal: needsTotal,
                    wantsTotal: wantsTotal,
                    budget: budgetAsync.valueOrNull,
                  ),
                ),
              ),
            ),

            // ── Spending section ─────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'SPENDING',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        letterSpacing: 0.8,
                      ),
                    ),
                    Row(
                      children: [
                        _RangeChip(
                          label: 'W',
                          active: _chartRange == 0,
                          onTap: () => setState(() => _chartRange = 0),
                        ),
                        const SizedBox(width: 6),
                        _RangeChip(
                          label: 'M',
                          active: _chartRange == 1,
                          onTap: () => setState(() => _chartRange = 1),
                        ),
                        const SizedBox(width: 6),
                        _RangeChip(
                          label: 'Y',
                          active: _chartRange == 2,
                          onTap: () => setState(() => _chartRange = 2),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Bar chart ────────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              sliver: SliverToBoxAdapter(
                child: historyAsync.when(
                  loading: () => const _SpendingChartSkeleton(),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (expenses) =>
                      _SpendingBarChart(expenses: expenses, range: _chartRange),
                ),
              ),
            ),

            // ── Recent transactions header ───────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 4),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Transactions',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          ref.read(shellTabProvider.notifier).state = 1,
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          color: AppColors.neonGreen,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Recent list ──────────────────────────────────────────────
            historyAsync.when(
              loading: () => const SliverPadding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: _RecentTransactionsSkeleton(),
                ),
              ),
              error: (err, _) => SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    err.toString(),
                    style: const TextStyle(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              data: (expenses) {
                if (expenses.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 40,
                              color: AppColors.textTertiary,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'No transactions yet',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                final recent = expenses.take(4).toList();
                return SliverList.builder(
                  itemCount: recent.length,
                  itemBuilder: (context, i) => ExpenseTile(
                    expense: recent[i],
                    onTap: () => context.push('/detail', extra: recent[i]),
                  ),
                );
              },
            ),

            const SliverPadding(padding: EdgeInsets.only(bottom: 110)),
          ],
        ),
      ),
    );
  }
}

// ── Balance card (purple gradient) ───────────────────────────────────────────

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.expenses,
    required this.needsTotal,
    required this.wantsTotal,
    required this.budget,
  });

  final List<Expense> expenses;
  final double needsTotal;
  final double wantsTotal;
  final double? budget;

  @override
  Widget build(BuildContext context) {
    final totalSpent = expenses.fold<double>(0, (s, e) => s + e.amount);
    final hasBudget = budget != null;
    final available = hasBudget ? (budget! - totalSpent) : 0.0;
    final now = DateTime.now();
    final monthName = const [
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
    ][now.month - 1];

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF3D1275), Color(0xFF6B2BB8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                hasBudget ? 'AVAILABLE FUNDS' : 'SET YOUR BUDGET',
                style: const TextStyle(
                  color: Color(0xFFBBA8D8),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$monthName ${now.year}',
                  style: const TextStyle(
                    color: Color(0xFFBBA8D8),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Big amount
          RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
              children: [
                TextSpan(
                  text: _formatWhole(available),
                  style: const TextStyle(fontSize: 38),
                ),
                TextSpan(
                  text: _formatDecimal(available),
                  style: const TextStyle(
                    fontSize: 22,
                    color: Color(0xFFDDD0F0),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          // Sub-row: Needs | Expenses | Items
          Row(
            children: [
              _CardStat(
                label: 'NEEDS',
                value: '+${formatCurrency(needsTotal)}',
                color: AppColors.emerald,
              ),
              Container(
                width: 1,
                height: 28,
                color: Colors.white.withAlpha(40),
                margin: const EdgeInsets.symmetric(horizontal: 14),
              ),
              _CardStat(
                label: 'WANTS',
                value: '-${formatCurrency(wantsTotal)}',
                color: AppColors.rose,
              ),
              Container(
                width: 1,
                height: 28,
                color: Colors.white.withAlpha(40),
                margin: const EdgeInsets.symmetric(horizontal: 14),
              ),
              _CardStat(
                label: 'ITEMS',
                value: '${expenses.length}',
                color: AppColors.neonGreen,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _formatWhole(double amount) {
    final isNegative = amount < 0;
    final parts = amount.abs().toStringAsFixed(2).split('.');
    final whole = int.parse(parts[0]);
    final s = whole.toString();
    final result = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) result.write(',');
      result.write(s[i]);
    }
    final prefix = isNegative ? '-' : '';
    return 'PKR $prefix${result.toString()}';
  }

  static String _formatDecimal(double amount) =>
      '.${amount.toStringAsFixed(2).split('.')[1]}';
}

class _CardStat extends StatelessWidget {
  const _CardStat({
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFBBA8D8),
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _BalanceCardSkeleton extends StatelessWidget {
  const _BalanceCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return _Shimmer(
      child: Container(
        height: 176,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF121212), Color(0xFF232323)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ShimmerBlock(width: 102, height: 12, borderRadius: 10),
                _ShimmerBlock(width: 74, height: 20, borderRadius: 12),
              ],
            ),
            const SizedBox(height: 16),
            _ShimmerBlock(width: 154, height: 40, borderRadius: 14),
            const SizedBox(height: 16),
            Row(
              children: [
                _ShimmerBlock(width: 42, height: 24, borderRadius: 10),
                Container(
                  width: 1,
                  height: 24,
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(24),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                _ShimmerBlock(width: 48, height: 24, borderRadius: 10),
                Container(
                  width: 1,
                  height: 24,
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(24),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                _ShimmerBlock(width: 32, height: 24, borderRadius: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SpendingChartSkeleton extends StatelessWidget {
  const _SpendingChartSkeleton();

  @override
  Widget build(BuildContext context) {
    return _Shimmer(
      child: Container(
        height: 170,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF161616),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _ShimmerBlock(width: 86, height: 12, borderRadius: 10),
                _ShimmerBlock(width: 92, height: 28, borderRadius: 10),
              ],
            ),
            const SizedBox(height: 22),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  _ChartBarSkeleton(flex: 1, heightFactor: 0.42),
                  SizedBox(width: 10),
                  _ChartBarSkeleton(flex: 1, heightFactor: 0.66),
                  SizedBox(width: 10),
                  _ChartBarSkeleton(flex: 1, heightFactor: 0.48),
                  SizedBox(width: 10),
                  _ChartBarSkeleton(flex: 1, heightFactor: 0.82),
                  SizedBox(width: 10),
                  _ChartBarSkeleton(flex: 1, heightFactor: 0.58),
                  SizedBox(width: 10),
                  _ChartBarSkeleton(flex: 1, heightFactor: 0.74),
                  SizedBox(width: 10),
                  _ChartBarSkeleton(flex: 1, heightFactor: 0.52),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentTransactionsSkeleton extends StatelessWidget {
  const _RecentTransactionsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _TransactionSkeletonTile(),
        SizedBox(height: 12),
        _TransactionSkeletonTile(),
        SizedBox(height: 12),
        _TransactionSkeletonTile(),
        SizedBox(height: 12),
        _TransactionSkeletonTile(),
      ],
    );
  }
}

class _TransactionSkeletonTile extends StatelessWidget {
  const _TransactionSkeletonTile();

  @override
  Widget build(BuildContext context) {
    return _Shimmer(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF161616),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _ShimmerBlock(width: 120, height: 14, borderRadius: 10),
                  SizedBox(height: 8),
                  _ShimmerBlock(width: 82, height: 10, borderRadius: 8),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const _ShimmerBlock(width: 64, height: 16, borderRadius: 10),
          ],
        ),
      ),
    );
  }
}

class _UserBadge extends StatelessWidget {
  const _UserBadge({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.neonGreen, AppColors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              _initialFor(email),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 150),
            child: Text(
              email,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _initialFor(String email) {
    final trimmed = email.trim();
    if (trimmed.isEmpty) return '?';
    final localPart = trimmed.split('@').first;
    final source = localPart.isEmpty ? trimmed : localPart;
    return source[0].toUpperCase();
  }
}

class _UserBadgeSkeleton extends StatelessWidget {
  const _UserBadgeSkeleton();

  @override
  Widget build(BuildContext context) {
    return _Shimmer(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF161616),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            _ShimmerBlock(width: 34, height: 34, borderRadius: 17),
            SizedBox(width: 10),
            _ShimmerBlock(width: 110, height: 12, borderRadius: 10),
          ],
        ),
      ),
    );
  }
}

class _ChartBarSkeleton extends StatelessWidget {
  const _ChartBarSkeleton({required this.flex, required this.heightFactor});

  final int flex;
  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: heightFactor,
          widthFactor: 0.82,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}

class _Shimmer extends StatefulWidget {
  const _Shimmer({required this.child});

  final Widget child;

  @override
  State<_Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            final shimmer = _controller.value * 2 - 1;
            return LinearGradient(
              begin: Alignment(-1.2 + shimmer, -0.2),
              end: Alignment(1.2 + shimmer, 0.2),
              colors: [
                const Color(0xFF1B1B1B),
                const Color(0xFF3A3A3A),
                const Color(0xFF1B1B1B),
              ],
              stops: const [0.35, 0.5, 0.65],
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }
}

class _ShimmerBlock extends StatelessWidget {
  const _ShimmerBlock({
    required this.width,
    required this.height,
    this.borderRadius = 12,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

// ── Range chip ───────────────────────────────────────────────────────────────

class _RangeChip extends StatelessWidget {
  const _RangeChip({
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
        width: 30,
        height: 28,
        decoration: BoxDecoration(
          color: active ? AppColors.neonGreen : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: active ? AppColors.neonGreenDark : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ── Weekly / Monthly / Yearly spending bar chart ─────────────────────────────

class _SpendingBarChart extends StatefulWidget {
  const _SpendingBarChart({required this.expenses, required this.range});
  final List<Expense> expenses;
  final int range; // 0=Week, 1=Month, 2=Year

  @override
  State<_SpendingBarChart> createState() => _SpendingBarChartState();
}

class _SpendingBarChartState extends State<_SpendingBarChart> {
  int _touched = -1;

  @override
  Widget build(BuildContext context) {
    final data = _buildData();
    if (data.isEmpty || data.every((v) => v == 0)) {
      return const SizedBox(
        height: 160,
        child: Center(
          child: Text(
            'No spending data for this period',
            style: TextStyle(color: AppColors.textTertiary, fontSize: 13),
          ),
        ),
      );
    }

    final maxY = (data.reduce((a, b) => a > b ? a : b) * 1.3).clamp(
      1.0,
      double.infinity,
    );

    return SizedBox(
      height: 170,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          minY: 0,
          barTouchData: BarTouchData(
            touchCallback: (event, res) {
              setState(() {
                _touched =
                    (event.isInterestedForInteractions && res?.spot != null)
                    ? res!.spot!.touchedBarGroupIndex
                    : -1;
              });
            },
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => AppColors.surfaceVariant,
              tooltipPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              getTooltipItem: (group, _, rod, __) => BarTooltipItem(
                formatCurrency(rod.toY),
                const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxY / 3,
            getDrawingHorizontalLine: (_) =>
                const FlLine(color: AppColors.surfaceVariant, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (value, meta) {
                  final labels = _labels();
                  final i = value.toInt();
                  if (i < 0 || i >= labels.length) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      labels[i],
                      style: const TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: List.generate(data.length, (i) {
            final isToday = _isCurrent(i);
            final isTouched = i == _touched;
            final color = (isToday || isTouched)
                ? AppColors.purple
                : AppColors.surfaceVariant;
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: data[i],
                  color: color,
                  width: 18,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(6),
                  ),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxY,
                    color: AppColors.surface,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  List<double> _buildData() {
    final now = DateTime.now();
    switch (widget.range) {
      case 0: // Week — Mon–Sun (7 bars)
        final monday = DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(Duration(days: now.weekday - 1));
        final result = List<double>.filled(7, 0.0);
        for (final e in widget.expenses) {
          final d = DateTime(e.date.year, e.date.month, e.date.day);
          final diff = d.difference(monday).inDays;
          if (diff >= 0 && diff < 7) result[diff] += e.amount;
        }
        return result;
      case 1: // Month — 1–31 grouped into 4 weeks
        final result = List<double>.filled(4, 0.0);
        for (final e in widget.expenses) {
          if (e.date.year == now.year && e.date.month == now.month) {
            final week = ((e.date.day - 1) / 7).floor().clamp(0, 3);
            result[week] += e.amount;
          }
        }
        return result;
      case 2: // Year — 12 months
        final result = List<double>.filled(12, 0.0);
        for (final e in widget.expenses) {
          if (e.date.year == now.year) {
            result[e.date.month - 1] += e.amount;
          }
        }
        return result;
      default:
        return [];
    }
  }

  List<String> _labels() {
    switch (widget.range) {
      case 0:
        return ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
      case 1:
        return ['WK1', 'WK2', 'WK3', 'WK4'];
      case 2:
        return [
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
      default:
        return [];
    }
  }

  bool _isCurrent(int i) {
    final now = DateTime.now();
    switch (widget.range) {
      case 0:
        return i == now.weekday - 1;
      case 1:
        return i == ((now.day - 1) / 7).floor().clamp(0, 3);
      case 2:
        return i == now.month - 1;
      default:
        return false;
    }
  }
}
