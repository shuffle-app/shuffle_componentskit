import 'package:json_annotation/json_annotation.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

part 'sms_verification_model.g.dart';

@JsonSerializable()
class SmsVerificationModel extends UiBaseModel {
  @JsonKey(name: 'code_digits_count', defaultValue: 4)
  final int codeDigitsCount;

  SmsVerificationModel({
    required super.version,
    required super.pageBuilderType,
    required this.codeDigitsCount,
  });

  factory SmsVerificationModel.fromJson(Map<String, dynamic> json) => _$SmsVerificationModelFromJson(json);
}
