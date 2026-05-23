import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../state/expenses_controller.dart';
import '../widgets/amount_field.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _descController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _descController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(addExpenseFormProvider);
    final formNotifier = ref.read(addExpenseFormProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
        ),
        title: const Text(
          'ADD EXPENSE',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 16,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Description
            _FieldLabel(label: 'Description'),
            const SizedBox(height: 8),
            TextField(
              controller: _descController,
              onChanged: formNotifier.setDescription,
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'e.g. Whole Foods salad',
                prefixIcon: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.textTertiary,
                  size: 20,
                ),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.cardBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.cardBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: AppColors.purpleLight,
                    width: 2,
                  ),
                ),
                hintStyle: const TextStyle(color: AppColors.textTertiary),
              ),
            ),
            const SizedBox(height: 20),

            // Amount
            _FieldLabel(label: 'Amount'),
            const SizedBox(height: 8),
            AmountField(
              controller: _amountController,
              onChanged: formNotifier.setAmountText,
            ),
            const SizedBox(height: 28),

            // AI Predict button
            OutlinedButton.icon(
              onPressed: formState.isPredicting ? null : formNotifier.predict,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.purpleLight,
                side: const BorderSide(color: AppColors.purple),
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: formState.isPredicting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.purpleLight,
                      ),
                    )
                  : const Icon(Icons.auto_awesome_rounded, size: 18),
              label: Text(
                formState.isPredicting
                    ? 'Predicting...'
                    : 'AI Predict Category',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),

            // Prediction result
            if (formState.predictedCategory != null) ...[
              const SizedBox(height: 16),
              _PredictionCard(
                category: formState.predictedCategory!,
                type: formState.predictedType ?? '',
              ),
            ],

            // Error
            if (formState.errorMessage != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.roseContainer,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.rose.withAlpha(80)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.rose,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        formState.errorMessage!,
                        style: const TextStyle(
                          color: AppColors.rose,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 32),

            // Save button
            FilledButton.icon(
              onPressed: formState.isSaving
                  ? null
                  : () async {
                      final expense = await formNotifier.save();
                      if (expense != null && context.mounted) {
                        ref.read(historyProvider.notifier).refresh();
                        context.pop();
                      }
                    },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.neonGreen,
                foregroundColor: AppColors.neonGreenDark,
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: formState.isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.neonGreenDark,
                      ),
                    )
                  : const Icon(Icons.check_rounded, size: 20),
              label: Text(
                formState.isSaving ? 'Saving...' : 'Save Expense',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _PredictionCard extends StatelessWidget {
  const _PredictionCard({required this.category, required this.type});
  final String category;
  final String type;

  @override
  Widget build(BuildContext context) {
    final isNeed = type.toLowerCase() == 'need';
    final color = isNeed ? AppColors.emerald : AppColors.rose;
    final bgColor = isNeed
        ? AppColors.emeraldContainer
        : AppColors.roseContainer;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome_rounded, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI PREDICTION',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${category.toUpperCase()}  •  ${isNeed ? "Need" : "Want"}',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isNeed ? Icons.check_rounded : Icons.favorite_rounded,
              color: color,
              size: 14,
            ),
          ),
        ],
      ),
    );
  }
}
