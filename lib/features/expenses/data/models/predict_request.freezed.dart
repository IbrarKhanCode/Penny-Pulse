// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'predict_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PredictRequest _$PredictRequestFromJson(Map<String, dynamic> json) {
  return _PredictRequest.fromJson(json);
}

/// @nodoc
mixin _$PredictRequest {
  String get text => throw _privateConstructorUsedError;

  /// Serializes this PredictRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PredictRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PredictRequestCopyWith<PredictRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PredictRequestCopyWith<$Res> {
  factory $PredictRequestCopyWith(
    PredictRequest value,
    $Res Function(PredictRequest) then,
  ) = _$PredictRequestCopyWithImpl<$Res, PredictRequest>;
  @useResult
  $Res call({String text});
}

/// @nodoc
class _$PredictRequestCopyWithImpl<$Res, $Val extends PredictRequest>
    implements $PredictRequestCopyWith<$Res> {
  _$PredictRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PredictRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? text = null}) {
    return _then(
      _value.copyWith(
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PredictRequestImplCopyWith<$Res>
    implements $PredictRequestCopyWith<$Res> {
  factory _$$PredictRequestImplCopyWith(
    _$PredictRequestImpl value,
    $Res Function(_$PredictRequestImpl) then,
  ) = __$$PredictRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String text});
}

/// @nodoc
class __$$PredictRequestImplCopyWithImpl<$Res>
    extends _$PredictRequestCopyWithImpl<$Res, _$PredictRequestImpl>
    implements _$$PredictRequestImplCopyWith<$Res> {
  __$$PredictRequestImplCopyWithImpl(
    _$PredictRequestImpl _value,
    $Res Function(_$PredictRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PredictRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? text = null}) {
    return _then(
      _$PredictRequestImpl(
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PredictRequestImpl implements _PredictRequest {
  const _$PredictRequestImpl({required this.text});

  factory _$PredictRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$PredictRequestImplFromJson(json);

  @override
  final String text;

  @override
  String toString() {
    return 'PredictRequest(text: $text)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PredictRequestImpl &&
            (identical(other.text, text) || other.text == text));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, text);

  /// Create a copy of PredictRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PredictRequestImplCopyWith<_$PredictRequestImpl> get copyWith =>
      __$$PredictRequestImplCopyWithImpl<_$PredictRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PredictRequestImplToJson(this);
  }
}

abstract class _PredictRequest implements PredictRequest {
  const factory _PredictRequest({required final String text}) =
      _$PredictRequestImpl;

  factory _PredictRequest.fromJson(Map<String, dynamic> json) =
      _$PredictRequestImpl.fromJson;

  @override
  String get text;

  /// Create a copy of PredictRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PredictRequestImplCopyWith<_$PredictRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
