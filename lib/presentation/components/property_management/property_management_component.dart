import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../shuffle_components_kit.dart';

class PropertyManagementComponent extends StatelessWidget {
  const PropertyManagementComponent({
    super.key,
    this.onPropertyTypeTapped,
    this.propertyTypes,
    this.selectedPropertyTypeTitle,
    this.onAddPropertyTypeTap,
    this.onEditPropertyTypeTap,
    this.onDeletePropertyTypeTap,
    required this.propertySearchOptions,
    this.onPropertyFieldSubmitted,
    this.selectedProperties,
    this.onSelectedPropertyTapped,
    this.recentlyAddedProperties,
    this.onRecentlyAddedPropertyTapped,
  });

  final ValueChanged<int>? onPropertyTypeTapped;
  final List<UiModelPropertyType>? propertyTypes;
  final VoidCallback? onAddPropertyTypeTap;
  final VoidCallback? onEditPropertyTypeTap;
  final VoidCallback? onDeletePropertyTypeTap;
  final String? selectedPropertyTypeTitle;
  final Future<List<String>> Function(String) propertySearchOptions;
  final ValueChanged<String>? onPropertyFieldSubmitted;
  final List<UiModelPropertyType>? selectedProperties;
  final ValueChanged<UiModelPropertyType>? onSelectedPropertyTapped;
  final List<UiModelPropertyType>? recentlyAddedProperties;
  final ValueChanged<UiModelPropertyType>? onRecentlyAddedPropertyTapped;

  @override
  Widget build(BuildContext context) {
    final uiKitTheme = context.uiKitTheme;
    return Scaffold(
      body: UiKitCardWrapper(
        borderRadius: BorderRadiusFoundation.all16,
        padding: EdgeInsets.symmetric(
            horizontal: EdgeInsetsFoundation.horizontal32,
            vertical: EdgeInsetsFoundation.vertical20),
        color: uiKitTheme?.colorScheme.surface,
        child: Row(
          children: [
            Expanded(
              child: PropertiesBorderedBox(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        S.current.ActivityTypes,
                        overflow: TextOverflow.ellipsis,
                        style: uiKitTheme?.boldTextTheme.title1,
                      ),
                    ),
                    SpacingFoundation.horizontalSpace16,
                    context.boxIconButton(
                      data: BaseUiKitButtonData(
                        onPressed: onAddPropertyTypeTap,
                        backgroundColor:
                            ColorsFoundation.primary200.withOpacity(0.3),
                        iconInfo: BaseUiKitButtonIconData(
                            iconData: ShuffleUiKitIcons.plus,
                            size: kIsWeb ? 24 : 24.sp,
                            color: ColorsFoundation.primary200),
                      ),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    SpacingFoundation.verticalSpace24,
                    ...(propertyTypes ?? []).map((element) {
                      return PropertiesTypeAnimatedButton(
                        title: element.title ?? '',
                        onTap: () {
                          onPropertyTypeTapped
                              ?.call(propertyTypes?.indexOf(element) ?? 0);
                        },
                      );
                    })
                  ],
                ),
              ),
            ),
            SpacingFoundation.horizontalSpace32,
            Expanded(
              child: PropertiesBorderedBox(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        selectedPropertyTypeTitle ?? 'Empty',
                        overflow: TextOverflow.ellipsis,
                        style: uiKitTheme?.boldTextTheme.title2,
                      ),
                    ),
                    SpacingFoundation.horizontalSpace16,
                    context.boxIconButton(
                      data: BaseUiKitButtonData(
                        onPressed: onEditPropertyTypeTap,
                        backgroundColor:
                            ColorsFoundation.primary200.withOpacity(0.3),
                        iconInfo: BaseUiKitButtonIconData(
                            iconData: ShuffleUiKitIcons.pencil,
                            size: kIsWeb ? 16 : 16.sp,
                            color: ColorsFoundation.primary200),
                      ),
                    ),
                    SpacingFoundation.horizontalSpace4,
                    context.boxIconButton(
                      data: BaseUiKitButtonData(
                        onPressed: onDeletePropertyTypeTap,
                        backgroundColor:
                            ColorsFoundation.danger.withOpacity(0.3),
                        iconInfo: BaseUiKitButtonIconData(
                            iconData: ShuffleUiKitIcons.trash,
                            size: kIsWeb ? 16 : 16.sp,
                            color: ColorsFoundation.danger),
                      ),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SpacingFoundation.verticalSpace24,
                    Text(
                      S.current.Properties,
                      style: uiKitTheme?.boldTextTheme.subHeadline,
                    ),
                    SpacingFoundation.verticalSpace12,
                    PropertiesSearchInput(
                      options: propertySearchOptions,
                      showAllOptions: true,
                      onFieldSubmitted: onPropertyFieldSubmitted,
                    ),
                    SpacingFoundation.verticalSpace12,
                    UiKitPropertiesCloud(
                      child: Wrap(
                              spacing: SpacingFoundation.horizontalSpacing12,
                              runSpacing: SpacingFoundation.verticalSpacing12,
                              children:
                                  (selectedProperties ?? []).map((element) {
                                return UiKitCloudChip(
                                  title: element.title,
                                  onTap: () {
                                    onSelectedPropertyTapped?.call(element);
                                  },
                                );
                              }).toList())
                          .paddingAll(EdgeInsetsFoundation.all24),
                    ),
                  ],
                ),
              ),
            ),
            SpacingFoundation.horizontalSpace32,
            Expanded(
              child: PropertiesBorderedBox(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        S.current.RecentlyAdded,
                        overflow: TextOverflow.ellipsis,
                        style: uiKitTheme?.boldTextTheme.title2,
                      ),
                    ),
                    SpacingFoundation.horizontalSpace16,
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          S.current.Date,
                          style: uiKitTheme?.regularTextTheme.labelLarge
                              .copyWith(color: ColorsFoundation.mutedText),
                        ),
                        SpacingFoundation.horizontalSpace8,
                        Icon(
                          ShuffleUiKitIcons.arrowdown,
                          size: kIsWeb ? 24 : 24.sp,
                          color: ColorsFoundation.mutedText,
                        ),
                      ],
                    )
                  ],
                ),
                child: Column(
                  children: [
                    SpacingFoundation.verticalSpace16,
                    UiKitPropertiesCloud(
                      child: Wrap(
                              spacing: SpacingFoundation.horizontalSpacing12,
                              runSpacing: SpacingFoundation.verticalSpacing12,
                              children: (recentlyAddedProperties ?? [])
                                  .map((element) {
                                return UiKitCloudChip(
                                  title: element.title,
                                  onTap: () {
                                    onRecentlyAddedPropertyTapped?.call(
                                      element,
                                    );
                                  },
                                );
                              }).toList())
                          .paddingAll(EdgeInsetsFoundation.all24),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
