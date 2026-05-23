import 'package:freezed_annotation/freezed_annotation.dart';

part 'predict_response.freezed.dart';
part 'predict_response.g.dart';

@freezed
class PredictResponse with _$PredictResponse {
  const factory PredictResponse({
    required String category,
    required String type,
  }) = _PredictResponse;

  factory PredictResponse.fromJson(Map<String, dynamic> json) =>
      _$PredictResponseFromJson(json);
}
