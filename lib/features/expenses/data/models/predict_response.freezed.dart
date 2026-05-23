// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'predict_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PredictResponse _$PredictResponseFromJson(Map<String, dynamic> json) {
  return _PredictResponse.fromJson(json);
}

/// @nodoc
mixin _$PredictResponse {
  String get category => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;

  /// Serializes this PredictResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PredictResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PredictResponseCopyWith<PredictResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PredictResponseCopyWith<$Res> {
  factory $PredictResponseCopyWith(
    PredictResponse value,
    $Res Function(PredictResponse) then,
  ) = _$PredictResponseCopyWithImpl<$Res, PredictResponse>;
  @useResult
  $Res call({String category, String type});
}

/// @nodoc
class _$PredictResponseCopyWithImpl<$Res, $Val extends PredictResponse>
    implements $PredictResponseCopyWith<$Res> {
  _$PredictResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PredictResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? category = null, Object? type = null}) {
    return _then(
      _value.copyWith(
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PredictResponseImplCopyWith<$Res>
    implements $PredictResponseCopyWith<$Res> {
  factory _$$PredictResponseImplCopyWith(
    _$PredictResponseImpl value,
    $Res Function(_$PredictResponseImpl) then,
  ) = __$$PredictResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String category, String type});
}

/// @nodoc
class __$$PredictResponseImplCopyWithImpl<$Res>
    extends _$PredictResponseCopyWithImpl<$Res, _$PredictResponseImpl>
    implements _$$PredictResponseImplCopyWith<$Res> {
  __$$PredictResponseImplCopyWithImpl(
    _$PredictResponseImpl _value,
    $Res Function(_$PredictResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PredictResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? category = null, Object? type = null}) {
    return _then(
      _$PredictResponseImpl(
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PredictResponseImpl implements _PredictResponse {
  const _$PredictResponseImpl({required this.category, required this.type});

  factory _$PredictResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PredictResponseImplFromJson(json);

  @override
  final String category;
  @override
  final String type;

  @override
  String toString() {
    return 'PredictResponse(category: $category, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PredictResponseImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, category, type);

  /// Create a copy of PredictResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PredictResponseImplCopyWith<_$PredictResponseImpl> get copyWith =>
      __$$PredictResponseImplCopyWithImpl<_$PredictResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PredictResponseImplToJson(this);
  }
}

abstract class _PredictResponse implements PredictResponse {
  const factory _PredictResponse({
    required final String category,
    required final String type,
  }) = _$PredictResponseImpl;

  factory _PredictResponse.fromJson(Map<String, dynamic> json) =
      _$PredictResponseImpl.fromJson;

  @override
  String get category;
  @override
  String get type;

  /// Create a copy of PredictResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PredictResponseImplCopyWith<_$PredictResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
