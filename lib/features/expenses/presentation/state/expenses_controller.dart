import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../data/models/expense.dart';
import '../../domain/usecases/add_expense.dart';
import '../../domain/usecases/delete_expense.dart';
import '../../domain/usecases/get_history.dart';
import '../../domain/usecases/predict_expense.dart';
import 'expenses_state.dart';

// ---------------------------------------------------------------------------
// History — AsyncNotifierProvider<HistoryNotifier, List<Expense>>
// ---------------------------------------------------------------------------

class HistoryNotifier extends AsyncNotifier<List<Expense>> {
  @override
  Future<List<Expense>> build() async {
    return ref.watch(getHistoryUseCaseProvider).call();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(getHistoryUseCaseProvider).call(),
    );
  }

  void clearCache() {
    state = const AsyncData([]);
  }

  /// Removes an expense with optimistic state update and server synchronization.
  Future<void> deleteExpense(int id) async {
    final previousState = state;
    final current = state.valueOrNull ?? [];
    
    // Optimistic UI update
    state = AsyncData(current.where((e) => e.id != id).toList());

    try {
      await ref.read(deleteExpenseUseCaseProvider).call(expenseId: id);
    } catch (e) {
      // Rollback UI state if server delete fails
      state = previousState;
      rethrow;
    }
  }
}

final historyProvider = AsyncNotifierProvider<HistoryNotifier, List<Expense>>(
  HistoryNotifier.new,
);

// ---------------------------------------------------------------------------
// Derived chart providers (computed from historyProvider)
// ---------------------------------------------------------------------------

/// Returns (needsTotal, wantsTotal) as a record.
final needsVsWantsProvider = Provider<(double, double)>((ref) {
  final historyAsync = ref.watch(historyProvider);
  return historyAsync.maybeWhen(
    data: (expenses) {
      double needs = 0, wants = 0;
      for (final e in expenses) {
        if (e.needWant.toLowerCase() == 'need') {
          needs += e.amount;
        } else {
          wants += e.amount;
        }
      }
      return (needs, wants);
    },
    orElse: () => (0.0, 0.0),
  );
});

/// Returns a map of {Category: totalAmount}, capitalised, sorted desc.
final categoryBreakdownProvider = Provider<Map<String, double>>((ref) {
  final historyAsync = ref.watch(historyProvider);
  return historyAsync.maybeWhen(
    data: (expenses) {
      final map = <String, double>{};
      for (final e in expenses) {
        final cat = e.category.isEmpty
            ? 'Other'
            : e.category[0].toUpperCase() + e.category.substring(1);
        map[cat] = (map[cat] ?? 0) + e.amount;
      }
      return map;
    },
    orElse: () => {},
  );
});

// ---------------------------------------------------------------------------
// Add-expense form — NotifierProvider<AddExpenseFormNotifier, AddExpenseFormState>
// ---------------------------------------------------------------------------

class AddExpenseFormNotifier extends Notifier<AddExpenseFormState> {
  @override
  AddExpenseFormState build() => const AddExpenseFormState();

  void setDescription(String value) =>
      state = state.copyWith(description: value, errorMessage: null);

  void setAmountText(String value) =>
      state = state.copyWith(amountText: value, errorMessage: null);

  Future<void> predict() async {
    if (state.description.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'Please enter a description first');
      return;
    }
    state = state.copyWith(isPredicting: true, errorMessage: null);
    try {
      final result = await ref
          .read(predictExpenseUseCaseProvider)
          .call(text: state.description.trim());
      state = state.copyWith(
        isPredicting: false,
        predictedCategory: result.category,
        predictedType: result.type,
      );
    } catch (e) {
      state = state.copyWith(
        isPredicting: false,
        errorMessage: e is AppException ? e.message : 'Prediction failed',
      );
    }
  }

  Future<Expense?> save() async {
    final desc = state.description.trim();
    final amount = double.tryParse(state.amountText.trim());

    if (desc.isEmpty || amount == null) {
      state = state.copyWith(
        errorMessage: 'Please enter a description and valid amount',
      );
      return null;
    }

    state = state.copyWith(isSaving: true, errorMessage: null);
    try {
      final expense = await ref
          .read(addExpenseUseCaseProvider)
          .call(text: desc, amount: amount);
      state = const AddExpenseFormState();
      return expense;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: e is AppException ? e.message : 'Failed to save expense',
      );
      return null;
    }
  }
}

final addExpenseFormProvider =
    NotifierProvider<AddExpenseFormNotifier, AddExpenseFormState>(
      AddExpenseFormNotifier.new,
    );
