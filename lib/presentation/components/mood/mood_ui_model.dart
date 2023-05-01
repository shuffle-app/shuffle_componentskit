import '../../../shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiKitMood {
  final String id;
  final String title;
  final String logo;
  final List<DescriptionItem>? descriptionItems;
  final List<UiKitPlace>? places;

  UiKitMood({required this.id, required this.title, required this.logo, this.descriptionItems, this.places});
}
