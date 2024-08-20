import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class PropertyManagementCreatePropertyDialog extends StatelessWidget {
  const PropertyManagementCreatePropertyDialog({
    super.key,
    this.onCloseTap,
    required this.isCategory,
    required this.titleTextController,
    required this.iconTextController,
    this.iconPath,
    required this.onIconTap,
    required this.listIcons,
    this.onCancelTap,
    this.onSaveTap,
    this.onUploadIconTap,
    required this.iconsScrollController,
  });

  final VoidCallback? onCloseTap;
  final VoidCallback? onSaveTap;
  final VoidCallback? onCancelTap;
  final bool isCategory;
  final TextEditingController titleTextController;
  final TextEditingController iconTextController;
  final String? iconPath;
  final ValueChanged<String> onIconTap;
  final List<String> listIcons;
  final VoidCallback? onUploadIconTap;
  final ScrollController iconsScrollController;

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    return UiKitCardWrapper(
      borderRadius: BorderRadiusFoundation.all32,
      padding: EdgeInsets.all(EdgeInsetsFoundation.all20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  isCategory
                      ? S.current.AddPlaceType
                      : S.current.AddProperty,
                  style: theme?.boldTextTheme.title1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              context.iconButtonNoPadding(
                data: BaseUiKitButtonData(
                  onPressed: onCloseTap,
                  iconInfo: BaseUiKitButtonIconData(
                      iconData: ShuffleUiKitIcons.x,
                      size: kIsWeb ? 24 : 24.sp),
                ),
              )
            ],
          ),
          SpacingFoundation.verticalSpace16,
          UiKitCardWrapper(
            child: ValueListenableBuilder(
              builder: (context, value, child) {
                return UiKitIconedTitle(
                  title: titleTextController.text,
                  icon: iconPath ?? '',
                );
              },
              valueListenable: titleTextController,
            ),
          ),
          SpacingFoundation.verticalSpace16,
          UiKitInputFilledWithTitle(
            title: S.current.Title,
            controller: titleTextController,
          ),
          SpacingFoundation.verticalSpace16,
          PlaceIconSelector(
              onPressed: onUploadIconTap,
              onIconTap: onIconTap,
              listIconData: listIcons,
              iconsScrollController: iconsScrollController,
              iconTextController: iconTextController
          ),
          SpacingFoundation.verticalSpace24,
          Row(
            children: [
              Expanded(
                child: context.coloredButtonWithBorderRadius(
                  borderRadius: BorderRadiusFoundation.all12,
                  data: BaseUiKitButtonData(
                    text: S.current.Save,
                    onPressed: onSaveTap,
                    backgroundColor: ColorsFoundation.info,
                  ),
                ),
              ),
              SpacingFoundation.horizontalSpace16,
              Expanded(
                child: context.coloredButtonWithBorderRadius(
                  borderRadius: BorderRadiusFoundation.all12,
                  data: BaseUiKitButtonData(
                    text: S.current.Cancel,
                    onPressed: onCancelTap,
                    backgroundColor: ColorsFoundation.danger,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
