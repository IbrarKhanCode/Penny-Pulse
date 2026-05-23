import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/expense.dart';
import '../../data/repositories/expenses_repository_impl.dart';
import '../repositories/expenses_repository.dart';

class AddExpense {
  const AddExpense(this._repository);

  final ExpensesRepository _repository;

  Future<Expense> call({required String text, required double amount}) =>
      _repository.addExpense(text: text, amount: amount);
}

final addExpenseUseCaseProvider = Provider<AddExpense>((ref) {
  return AddExpense(ref.watch(expensesRepositoryProvider));
});
