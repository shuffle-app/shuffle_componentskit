import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class PropertyManagementEditOnlyTitleDialog extends StatelessWidget {
  const PropertyManagementEditOnlyTitleDialog(
      {super.key,
      this.onCloseTap,
      required this.onEditTap,
      required this.onCancelTap,
      required this.titleController});

  final VoidCallback? onCloseTap;
  final ValueChanged<String> onEditTap;
  final VoidCallback onCancelTap;
  final TextEditingController titleController;

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    return UiKitCardWrapper(
      color: theme?.colorScheme.surface,
      borderRadius: BorderRadiusFoundation.all32,
      padding: EdgeInsets.all(EdgeInsetsFoundation.all32),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                   S.current.Tags,
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
          UiKitInputFilledWithTitle(
            title: S.current.Title,
            controller: titleController,
          ),
          SpacingFoundation.verticalSpace24,
          Row(
            children: [
              Expanded(
                child: context.coloredButtonWithBorderRadius(
                  borderRadius: BorderRadiusFoundation.all12,
                  data: BaseUiKitButtonData(
                    backgroundColor: ColorsFoundation.info,
                    text: S.current.Edit,
                    onPressed: () {
                      onEditTap.call(titleController.text);
                    },
                  ),
                ),
              ),
              SpacingFoundation.horizontalSpace16,
              Expanded(
                child: context.coloredButtonWithBorderRadius(
                  borderRadius: BorderRadiusFoundation.all12,
                  data: BaseUiKitButtonData(
                    backgroundColor: ColorsFoundation.danger,
                    text: S.current.Cancel,
                    onPressed: onCancelTap,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
