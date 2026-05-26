import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/state/profile_provider.dart';
import '../../data/budget_store.dart';

class BudgetNotifier extends AsyncNotifier<double?> {
  @override
  Future<double?> build() async {
    final profile = await ref.watch(profileProvider.future);
    return ref
        .watch(budgetStoreProvider)
        .readBudget(userId: profile.id.toString());
  }

  Future<void> saveBudget(double value) async {
    final profile = await ref.read(profileProvider.future);
    await ref
        .read(budgetStoreProvider)
        .saveBudget(userId: profile.id.toString(), budget: value);
    state = AsyncData(value);
  }

  Future<void> clearBudget() async {
    final profile = await ref.read(profileProvider.future);
    await ref
        .read(budgetStoreProvider)
        .deleteBudget(userId: profile.id.toString());
    state = const AsyncData(null);
  }
}

final budgetProvider = AsyncNotifierProvider<BudgetNotifier, double?>(
  BudgetNotifier.new,
);
