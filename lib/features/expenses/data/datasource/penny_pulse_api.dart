import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/networking/dio_provider.dart';
import '../models/add_expense_request.dart';
import '../models/api_message.dart';
import '../models/expense.dart';
import '../models/predict_request.dart';
import '../models/predict_response.dart';

class PennyPulseApi {
  const PennyPulseApi({required this.dio});

  final Dio dio;

  Future<ApiMessage> health() async {
    final res = await dio.get<Map<String, dynamic>>('/');
    return ApiMessage.fromJson(res.data!);
  }

  Future<PredictResponse> predict({required PredictRequest request}) async {
    final res = await dio.post<Map<String, dynamic>>(
      '/predict',
      data: request.toJson(),
    );
    return PredictResponse.fromJson(res.data!);
  }

  Future<Expense> addExpense({required AddExpenseRequest request}) async {
    final res = await dio.post<Map<String, dynamic>>(
      '/add-expense',
      data: request.toJson(),
    );
    return Expense.fromJson(res.data!);
  }

  Future<List<Expense>> history() async {
    final res = await dio.get<List<dynamic>>('/history');
    final raw = res.data ?? const [];
    return raw
        .cast<Map<String, dynamic>>()
        .map(Expense.fromJson)
        .toList(growable: false);
  }
}

final pennyPulseApiProvider = Provider<PennyPulseApi>((ref) {
  return PennyPulseApi(dio: ref.watch(dioProvider));
});
