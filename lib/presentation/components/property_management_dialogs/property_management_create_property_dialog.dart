import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class PropertyManagementCreatePropertyDialog extends StatelessWidget {
  const PropertyManagementCreatePropertyDialog(
      {super.key,
      this.onCloseTap,
      required this.isPlaceType,
      required this.titleTextController,
      required this.iconTextController,
      this.iconPath,
      required this.onIconTap,
      required this.listIcons});

  final VoidCallback? onCloseTap;
  final bool isPlaceType;
  final TextEditingController titleTextController;
  final TextEditingController iconTextController;
  final String? iconPath;
  final ValueChanged<String> onIconTap;
  final List<IconData> listIcons;

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    return UiKitCardWrapper(
      borderRadius: BorderRadiusFoundation.all32,
      color: theme?.colorScheme.surface,
      padding: EdgeInsets.all(EdgeInsetsFoundation.all32),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    isPlaceType ? 'Add Place Type' : 'Add property',
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
            SpacingFoundation.verticalSpace24,
            UiKitCardWrapper(
              color: ColorsFoundation.lightSurface,
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
            SpacingFoundation.verticalSpace24,
            UiKitInputFilledWithTitle(
              title: S.current.Title,
              controller: titleTextController,
            ),
            SpacingFoundation.verticalSpace24,
            PlaceIconSelector(
              onPressed: () {},
              onIconTap: onIconTap,
              listIconData: listIcons,
            )
          ],
        ),
      ),
    );
  }
}
