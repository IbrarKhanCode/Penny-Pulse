import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_expense_request.freezed.dart';
part 'add_expense_request.g.dart';

@freezed
class AddExpenseRequest with _$AddExpenseRequest {
  const factory AddExpenseRequest({
    required String text,
    required double amount,
  }) = _AddExpenseRequest;

  factory AddExpenseRequest.fromJson(Map<String, dynamic> json) =>
      _$AddExpenseRequestFromJson(json);
}
