import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../data/models/expense.dart';

class ExpenseTile extends StatelessWidget {
  const ExpenseTile({super.key, required this.expense, this.onTap});

  final Expense expense;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isNeed = expense.needWant.toLowerCase() == 'need';
    final amountColor = isNeed ? AppColors.neonGreen : AppColors.rose;
    final iconColor = isNeed ? AppColors.emerald : AppColors.rose;
    final containerColor = isNeed
        ? AppColors.emeraldContainer
        : AppColors.roseContainer;
    final timeStr = _formatTime(expense.date);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // ── Category icon ──────────────────────────────────────────────
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _categoryIcon(expense.category),
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // ── Description + meta ─────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.description.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_capitalise(expense.category)} • ${isNeed ? "Need" : "Want"}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // ── Amount + time ──────────────────────────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '-${formatCurrency(expense.amount)}',
                  style: TextStyle(
                    color: amountColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timeStr,
                  style: const TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _capitalise(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  static String _formatTime(DateTime d) {
    final hour = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final min = d.minute.toString().padLeft(2, '0');
    final period = d.hour < 12 ? 'AM' : 'PM';
    return '$hour:$min $period';
  }

  static IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'groceries':
      case 'food':
        return Icons.local_grocery_store_outlined;
      case 'transport':
      case 'transportation':
        return Icons.directions_car_outlined;
      case 'entertainment':
        return Icons.movie_outlined;
      case 'healthcare':
      case 'health':
        return Icons.medical_services_outlined;
      case 'utilities':
        return Icons.bolt_outlined;
      case 'shopping':
        return Icons.shopping_bag_outlined;
      case 'education':
        return Icons.school_outlined;
      case 'dining':
      case 'restaurant':
        return Icons.restaurant_outlined;
      case 'coffee':
      case 'drinks':
        return Icons.coffee_outlined;
      default:
        return Icons.receipt_outlined;
    }
  }
}
