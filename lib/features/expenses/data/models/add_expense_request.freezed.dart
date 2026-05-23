// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_expense_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AddExpenseRequest _$AddExpenseRequestFromJson(Map<String, dynamic> json) {
  return _AddExpenseRequest.fromJson(json);
}

/// @nodoc
mixin _$AddExpenseRequest {
  String get text => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;

  /// Serializes this AddExpenseRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddExpenseRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddExpenseRequestCopyWith<AddExpenseRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddExpenseRequestCopyWith<$Res> {
  factory $AddExpenseRequestCopyWith(
    AddExpenseRequest value,
    $Res Function(AddExpenseRequest) then,
  ) = _$AddExpenseRequestCopyWithImpl<$Res, AddExpenseRequest>;
  @useResult
  $Res call({String text, double amount});
}

/// @nodoc
class _$AddExpenseRequestCopyWithImpl<$Res, $Val extends AddExpenseRequest>
    implements $AddExpenseRequestCopyWith<$Res> {
  _$AddExpenseRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddExpenseRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? text = null, Object? amount = null}) {
    return _then(
      _value.copyWith(
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AddExpenseRequestImplCopyWith<$Res>
    implements $AddExpenseRequestCopyWith<$Res> {
  factory _$$AddExpenseRequestImplCopyWith(
    _$AddExpenseRequestImpl value,
    $Res Function(_$AddExpenseRequestImpl) then,
  ) = __$$AddExpenseRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String text, double amount});
}

/// @nodoc
class __$$AddExpenseRequestImplCopyWithImpl<$Res>
    extends _$AddExpenseRequestCopyWithImpl<$Res, _$AddExpenseRequestImpl>
    implements _$$AddExpenseRequestImplCopyWith<$Res> {
  __$$AddExpenseRequestImplCopyWithImpl(
    _$AddExpenseRequestImpl _value,
    $Res Function(_$AddExpenseRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AddExpenseRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? text = null, Object? amount = null}) {
    return _then(
      _$AddExpenseRequestImpl(
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AddExpenseRequestImpl implements _AddExpenseRequest {
  const _$AddExpenseRequestImpl({required this.text, required this.amount});

  factory _$AddExpenseRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddExpenseRequestImplFromJson(json);

  @override
  final String text;
  @override
  final double amount;

  @override
  String toString() {
    return 'AddExpenseRequest(text: $text, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddExpenseRequestImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, text, amount);

  /// Create a copy of AddExpenseRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddExpenseRequestImplCopyWith<_$AddExpenseRequestImpl> get copyWith =>
      __$$AddExpenseRequestImplCopyWithImpl<_$AddExpenseRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AddExpenseRequestImplToJson(this);
  }
}

abstract class _AddExpenseRequest implements AddExpenseRequest {
  const factory _AddExpenseRequest({
    required final String text,
    required final double amount,
  }) = _$AddExpenseRequestImpl;

  factory _AddExpenseRequest.fromJson(Map<String, dynamic> json) =
      _$AddExpenseRequestImpl.fromJson;

  @override
  String get text;
  @override
  double get amount;

  /// Create a copy of AddExpenseRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddExpenseRequestImplCopyWith<_$AddExpenseRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
