import 'package:json_annotation/json_annotation.dart';

enum PageBuilderType {
  @JsonValue('modal_bottom_sheet')
  modalBottomSheet,
  @JsonValue('page')
  page,
  @JsonValue('dialog')
  dialog,
  @JsonValue('general_dialog')
  generalDialog,
}
