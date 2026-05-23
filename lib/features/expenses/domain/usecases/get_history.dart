import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/expense.dart';
import '../../data/repositories/expenses_repository_impl.dart';
import '../repositories/expenses_repository.dart';

class GetHistory {
  const GetHistory(this._repository);

  final ExpensesRepository _repository;

  Future<List<Expense>> call() => _repository.getHistory();
}

final getHistoryUseCaseProvider = Provider<GetHistory>((ref) {
  return GetHistory(ref.watch(expensesRepositoryProvider));
});
