import 'package:json_annotation/json_annotation.dart';

enum PageBuilderType {
  @JsonKey(name: "modal_bottom_sheet")
  modalBottomSheet,
  @JsonKey(name:"page")
  page
}
