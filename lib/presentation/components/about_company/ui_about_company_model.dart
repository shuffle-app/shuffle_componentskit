import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiAboutCompanyModel {
  final UiKitMenuItem? selectedMenuItem;
  final List<String>? selectedAudiences;
  final List<IntegerRange>? selectedAgeRanges;

  UiAboutCompanyModel({
    this.selectedMenuItem,
    this.selectedAudiences,
    this.selectedAgeRanges,
  });
}
