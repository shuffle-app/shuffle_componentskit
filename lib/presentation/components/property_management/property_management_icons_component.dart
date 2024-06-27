import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class PropertyManagementIconsComponent extends StatelessWidget {
  const PropertyManagementIconsComponent(
      {super.key,
      this.iconsPath,
      this.onIconTap,
      required this.relatedPropertyTextController,
      this.relatedProperties,
      this.recentlyAddedIconPaths});

  final List<String>? iconsPath;
  final List<String>? recentlyAddedIconPaths;
  final VoidCallback? onIconTap;
  final TextEditingController relatedPropertyTextController;
  final List<RelatedPropertiesItemUiModel>? relatedProperties;

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
                  children: [
                    Expanded(
                      child: Text(
                        S.current.Icons,
                        style: uiKitTheme?.boldTextTheme.title1,
                      ),
                    ),
                    SpacingFoundation.horizontalSpace8,
                    Icon(
                      ShuffleUiKitIcons.chevrondown,
                      size: kIsWeb ? 24 : 24.sp,
                      color: uiKitTheme?.colorScheme.darkNeutral900,
                    )
                  ],
                ),
                child: UiKitPropertyIcons(
                  onPressed: onIconTap ?? () {},
                  listIconPath: iconsPath ?? [],
                  textFieldHintText: S.current.Search,
                ).paddingSymmetric(vertical: EdgeInsetsFoundation.vertical20),
              ),
            ),
            SpacingFoundation.horizontalSpace32,
            Expanded(
              child: PropertiesBorderedBox(
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        S.current.RelatedProperties,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: uiKitTheme?.boldTextTheme.title1,
                      ),
                    ),
                  ],
                ),
                child: UiKitPropertyRelatedProperties(
                  listRelatedPropertiesItem: relatedProperties ?? [],
                  textEditingController: relatedPropertyTextController,
                ).paddingSymmetric(vertical: EdgeInsetsFoundation.vertical20),
              ),
            ),
            SpacingFoundation.horizontalSpace32,
            Expanded(
              child: PropertiesBorderedBox(
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        S.current.RecentlyAdded,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: uiKitTheme?.boldTextTheme.title1,
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
                child: UiKitPropertyRecentlyAdded(
                  listIconPath: recentlyAddedIconPaths ?? [],
                ).paddingSymmetric(vertical: EdgeInsetsFoundation.vertical20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
