import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../auth/data/token_store.dart';

class BudgetStore {
  const BudgetStore(this._storage);

  final FlutterSecureStorage _storage;

  String _keyForUser(String userId) => 'budget_$userId';

  Future<double?> readBudget({required String userId}) async {
    final value = await _storage.read(key: _keyForUser(userId));
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    return double.tryParse(value);
  }

  Future<void> saveBudget({required String userId, required double budget}) {
    final normalized = budget.toStringAsFixed(2);
    return _storage.write(key: _keyForUser(userId), value: normalized);
  }

  Future<void> deleteBudget({required String userId}) {
    return _storage.delete(key: _keyForUser(userId));
  }
}

final budgetStoreProvider = Provider<BudgetStore>((ref) {
  return BudgetStore(ref.watch(secureStorageProvider));
});
