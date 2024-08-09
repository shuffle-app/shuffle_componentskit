import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/utils/typedefs.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class ProStatisticsSettingsComponent extends StatelessWidget {
  final List<TitledFilterModel<String>> filters;
  final FilterValueChanged<TitledFilterItem<String>?>? onFilterValueChanged;

  const ProStatisticsSettingsComponent({
    Key? key,
    required this.filters,
    required this.onFilterValueChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          S.current.Settings,
          style: boldTextTheme?.subHeadline,
        ),
        SpacingFoundation.verticalSpace24,
        ...filters.map(
          (filter) {
            final parentIndex = filters.indexOf(filter);

            return UiKitTitledFilter<String>(
              model: filter,
              onItemSelected: (item) => onFilterValueChanged?.call(parentIndex, item),
              onItemDeselected: (item) => onFilterValueChanged?.call(parentIndex, item),
            );
          },
        ),
        SpacingFoundation.verticalSpace24,
      ],
    ).paddingAll(EdgeInsetsFoundation.all16);
  }
}
