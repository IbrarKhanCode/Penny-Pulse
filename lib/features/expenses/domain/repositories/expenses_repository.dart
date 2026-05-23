import '../../data/models/expense.dart';
import '../../data/models/predict_response.dart';

abstract interface class ExpensesRepository {
  Future<List<Expense>> getHistory();

  Future<Expense> addExpense({required String text, required double amount});

  Future<PredictResponse> predict({required String text});
}
