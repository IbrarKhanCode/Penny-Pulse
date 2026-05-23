import 'package:freezed_annotation/freezed_annotation.dart';

part 'expenses_state.freezed.dart';

@freezed
class AddExpenseFormState with _$AddExpenseFormState {
  const factory AddExpenseFormState({
    @Default('') String description,
    @Default('') String amountText,
    String? predictedCategory,
    String? predictedType,
    @Default(false) bool isPredicting,
    @Default(false) bool isSaving,
    String? errorMessage,
  }) = _AddExpenseFormState;
}
