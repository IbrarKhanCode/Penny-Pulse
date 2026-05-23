// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expenses_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AddExpenseFormState {
  String get description => throw _privateConstructorUsedError;
  String get amountText => throw _privateConstructorUsedError;
  String? get predictedCategory => throw _privateConstructorUsedError;
  String? get predictedType => throw _privateConstructorUsedError;
  bool get isPredicting => throw _privateConstructorUsedError;
  bool get isSaving => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of AddExpenseFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddExpenseFormStateCopyWith<AddExpenseFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddExpenseFormStateCopyWith<$Res> {
  factory $AddExpenseFormStateCopyWith(
    AddExpenseFormState value,
    $Res Function(AddExpenseFormState) then,
  ) = _$AddExpenseFormStateCopyWithImpl<$Res, AddExpenseFormState>;
  @useResult
  $Res call({
    String description,
    String amountText,
    String? predictedCategory,
    String? predictedType,
    bool isPredicting,
    bool isSaving,
    String? errorMessage,
  });
}

/// @nodoc
class _$AddExpenseFormStateCopyWithImpl<$Res, $Val extends AddExpenseFormState>
    implements $AddExpenseFormStateCopyWith<$Res> {
  _$AddExpenseFormStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddExpenseFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
    Object? amountText = null,
    Object? predictedCategory = freezed,
    Object? predictedType = freezed,
    Object? isPredicting = null,
    Object? isSaving = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            amountText: null == amountText
                ? _value.amountText
                : amountText // ignore: cast_nullable_to_non_nullable
                      as String,
            predictedCategory: freezed == predictedCategory
                ? _value.predictedCategory
                : predictedCategory // ignore: cast_nullable_to_non_nullable
                      as String?,
            predictedType: freezed == predictedType
                ? _value.predictedType
                : predictedType // ignore: cast_nullable_to_non_nullable
                      as String?,
            isPredicting: null == isPredicting
                ? _value.isPredicting
                : isPredicting // ignore: cast_nullable_to_non_nullable
                      as bool,
            isSaving: null == isSaving
                ? _value.isSaving
                : isSaving // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AddExpenseFormStateImplCopyWith<$Res>
    implements $AddExpenseFormStateCopyWith<$Res> {
  factory _$$AddExpenseFormStateImplCopyWith(
    _$AddExpenseFormStateImpl value,
    $Res Function(_$AddExpenseFormStateImpl) then,
  ) = __$$AddExpenseFormStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String description,
    String amountText,
    String? predictedCategory,
    String? predictedType,
    bool isPredicting,
    bool isSaving,
    String? errorMessage,
  });
}

/// @nodoc
class __$$AddExpenseFormStateImplCopyWithImpl<$Res>
    extends _$AddExpenseFormStateCopyWithImpl<$Res, _$AddExpenseFormStateImpl>
    implements _$$AddExpenseFormStateImplCopyWith<$Res> {
  __$$AddExpenseFormStateImplCopyWithImpl(
    _$AddExpenseFormStateImpl _value,
    $Res Function(_$AddExpenseFormStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AddExpenseFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
    Object? amountText = null,
    Object? predictedCategory = freezed,
    Object? predictedType = freezed,
    Object? isPredicting = null,
    Object? isSaving = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$AddExpenseFormStateImpl(
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        amountText: null == amountText
            ? _value.amountText
            : amountText // ignore: cast_nullable_to_non_nullable
                  as String,
        predictedCategory: freezed == predictedCategory
            ? _value.predictedCategory
            : predictedCategory // ignore: cast_nullable_to_non_nullable
                  as String?,
        predictedType: freezed == predictedType
            ? _value.predictedType
            : predictedType // ignore: cast_nullable_to_non_nullable
                  as String?,
        isPredicting: null == isPredicting
            ? _value.isPredicting
            : isPredicting // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSaving: null == isSaving
            ? _value.isSaving
            : isSaving // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$AddExpenseFormStateImpl implements _AddExpenseFormState {
  const _$AddExpenseFormStateImpl({
    this.description = '',
    this.amountText = '',
    this.predictedCategory,
    this.predictedType,
    this.isPredicting = false,
    this.isSaving = false,
    this.errorMessage,
  });

  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final String amountText;
  @override
  final String? predictedCategory;
  @override
  final String? predictedType;
  @override
  @JsonKey()
  final bool isPredicting;
  @override
  @JsonKey()
  final bool isSaving;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'AddExpenseFormState(description: $description, amountText: $amountText, predictedCategory: $predictedCategory, predictedType: $predictedType, isPredicting: $isPredicting, isSaving: $isSaving, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddExpenseFormStateImpl &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.amountText, amountText) ||
                other.amountText == amountText) &&
            (identical(other.predictedCategory, predictedCategory) ||
                other.predictedCategory == predictedCategory) &&
            (identical(other.predictedType, predictedType) ||
                other.predictedType == predictedType) &&
            (identical(other.isPredicting, isPredicting) ||
                other.isPredicting == isPredicting) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    description,
    amountText,
    predictedCategory,
    predictedType,
    isPredicting,
    isSaving,
    errorMessage,
  );

  /// Create a copy of AddExpenseFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddExpenseFormStateImplCopyWith<_$AddExpenseFormStateImpl> get copyWith =>
      __$$AddExpenseFormStateImplCopyWithImpl<_$AddExpenseFormStateImpl>(
        this,
        _$identity,
      );
}

abstract class _AddExpenseFormState implements AddExpenseFormState {
  const factory _AddExpenseFormState({
    final String description,
    final String amountText,
    final String? predictedCategory,
    final String? predictedType,
    final bool isPredicting,
    final bool isSaving,
    final String? errorMessage,
  }) = _$AddExpenseFormStateImpl;

  @override
  String get description;
  @override
  String get amountText;
  @override
  String? get predictedCategory;
  @override
  String? get predictedType;
  @override
  bool get isPredicting;
  @override
  bool get isSaving;
  @override
  String? get errorMessage;

  /// Create a copy of AddExpenseFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddExpenseFormStateImplCopyWith<_$AddExpenseFormStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
