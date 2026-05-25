import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/expenses_repository_impl.dart';
import '../repositories/expenses_repository.dart';

class DeleteExpense {
  const DeleteExpense(this._repository);

  final ExpensesRepository _repository;

  Future<void> call({required int expenseId}) =>
      _repository.deleteExpense(expenseId: expenseId);
}

final deleteExpenseUseCaseProvider = Provider<DeleteExpense>((ref) {
  return DeleteExpense(ref.watch(expensesRepositoryProvider));
});
