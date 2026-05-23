// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_expense_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddExpenseRequestImpl _$$AddExpenseRequestImplFromJson(
  Map<String, dynamic> json,
) => _$AddExpenseRequestImpl(
  text: json['text'] as String,
  amount: (json['amount'] as num).toDouble(),
);

Map<String, dynamic> _$$AddExpenseRequestImplToJson(
  _$AddExpenseRequestImpl instance,
) => <String, dynamic>{'text': instance.text, 'amount': instance.amount};
