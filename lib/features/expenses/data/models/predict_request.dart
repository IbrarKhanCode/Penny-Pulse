import 'package:freezed_annotation/freezed_annotation.dart';

part 'predict_request.freezed.dart';
part 'predict_request.g.dart';

@freezed
class PredictRequest with _$PredictRequest {
  const factory PredictRequest({required String text}) = _PredictRequest;

  factory PredictRequest.fromJson(Map<String, dynamic> json) =>
      _$PredictRequestFromJson(json);
}
