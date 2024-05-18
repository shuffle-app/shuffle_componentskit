import 'package:json_annotation/json_annotation.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

part 'component_model.g.dart';

@JsonSerializable()
class ComponentModel extends UiBaseModel {

  @JsonKey(name: 'content')
  final ContentBaseModel content;

  const ComponentModel({
    required super.version,
    this.content = const ContentBaseModel(),
    required super.pageBuilderType,
    super.positionModel,
  });

  factory ComponentModel.empty() => const ComponentModel(
    version: '1',
    pageBuilderType: PageBuilderType.page,
  );

  factory ComponentModel.fromJson(Map<String, dynamic> json) => _$ComponentModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComponentModelToJson(this);
}
