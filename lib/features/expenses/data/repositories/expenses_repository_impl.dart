import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../datasource/penny_pulse_api.dart';
import '../models/add_expense_request.dart';
import '../models/expense.dart';
import '../models/predict_request.dart';
import '../models/predict_response.dart';
import '../../domain/repositories/expenses_repository.dart';

class ExpensesRepositoryImpl implements ExpensesRepository {
  const ExpensesRepositoryImpl(this._api);

  final PennyPulseApi _api;

  @override
  Future<List<Expense>> getHistory() async {
    try {
      return await _api.history();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  @override
  Future<Expense> addExpense({
    required String text,
    required double amount,
  }) async {
    try {
      return await _api.addExpense(
        request: AddExpenseRequest(text: text, amount: amount),
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  @override
  Future<PredictResponse> predict({required String text}) async {
    try {
      return await _api.predict(request: PredictRequest(text: text));
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  @override
  Future<void> deleteExpense({required int expenseId}) async {
    try {
      await _api.deleteExpense(expenseId: expenseId);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  AppException _mapDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final detail = e.response?.data is Map
        ? (e.response!.data as Map)['detail']?.toString()
        : null;
    final message = detail ?? e.message ?? 'An unexpected error occurred';
    return AppException(message: message, statusCode: statusCode);
  }
}

final expensesRepositoryProvider = Provider<ExpensesRepository>((ref) {
  return ExpensesRepositoryImpl(ref.watch(pennyPulseApiProvider));
});
