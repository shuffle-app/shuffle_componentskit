import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class PropertyManagementAddCategoryDialog extends StatelessWidget {
  const PropertyManagementAddCategoryDialog(
      {super.key,
      this.onCloseTap,
      required this.onPlaceCreate,
      required this.onEventCreate});

  final VoidCallback? onCloseTap;
  final VoidCallback onPlaceCreate;
  final VoidCallback onEventCreate;

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    return UiKitCardWrapper(
      borderRadius: BorderRadiusFoundation.all32,
      color: theme?.colorScheme.surface,
      padding: EdgeInsets.all(EdgeInsetsFoundation.all32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  S.current.AddCategory,
                  style: theme?.boldTextTheme.title1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              context.iconButtonNoPadding(
                data: BaseUiKitButtonData(
                  onPressed: onCloseTap,
                  iconInfo: BaseUiKitButtonIconData(
                      iconData: ShuffleUiKitIcons.x, size: kIsWeb ? 24 : 24.sp),
                ),
              )
            ],
          ),
          SpacingFoundation.verticalSpace24,
          Row(
            children: [
              Expanded(
                child: context.coloredButtonWithBorderRadius(
                  borderRadius: BorderRadiusFoundation.all12,
                  data: BaseUiKitButtonData(
                      text: S.current.Place,
                      onPressed: onPlaceCreate,
                      backgroundColor: theme?.colorScheme.darkNeutral200),
                ),
              ),
              SpacingFoundation.horizontalSpace16,
              Expanded(
                child: context.coloredButtonWithBorderRadius(
                  borderRadius: BorderRadiusFoundation.all12,
                  data: BaseUiKitButtonData(
                      text: S.current.Event,
                      onPressed: onEventCreate,
                      backgroundColor: theme?.colorScheme.darkNeutral200),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
