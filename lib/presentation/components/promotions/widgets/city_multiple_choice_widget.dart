import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class CityMultipleChoiceWidget extends StatelessWidget {
  final List<String> cities;
  final List<String> selectedCities;
  final ValueChanged<String> onChanged;

  const CityMultipleChoiceWidget(
      {super.key, required this.cities, required this.selectedCities, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.uiKitTheme?.colorScheme;
    return BlurredAppBarPage(
      title: S.current.Geography,
      autoImplyLeading: true,
      centerTitle: true,
      childrenPadding: EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing16),
      children: ListTile.divideTiles(
        color: colorScheme?.surface2,
          context: context,
          tiles: [
        for (var city in cities)
          UiKitCheckboxFilterItem(
            item: TitledFilterItem(
                mask: city, value: city, selected: selectedCities.contains(city)),
            onTap: (selected) {
              onChanged.call(city);
            },
            isSelected: selectedCities.contains(city),
          ).paddingSymmetric(vertical: SpacingFoundation.horizontalSpacing8)
      ]).toList(),
    );
  }
}
