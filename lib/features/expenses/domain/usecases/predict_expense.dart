import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/predict_response.dart';
import '../../data/repositories/expenses_repository_impl.dart';
import '../repositories/expenses_repository.dart';

class PredictExpense {
  const PredictExpense(this._repository);

  final ExpensesRepository _repository;

  Future<PredictResponse> call({required String text}) =>
      _repository.predict(text: text);
}

final predictExpenseUseCaseProvider = Provider<PredictExpense>((ref) {
  return PredictExpense(ref.watch(expensesRepositoryProvider));
});
