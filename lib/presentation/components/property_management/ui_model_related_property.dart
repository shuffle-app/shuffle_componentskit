import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiModelRelatedProperty extends UiKitTag {
  final String description;

  UiModelRelatedProperty({
    super.id,
    super.icon,
    required super.title,
    this.description = '',
    super.unique,
  }) : super();
}
