import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class SelectOneTypeWithBottom extends StatelessWidget {
  final List<String> items;
  final String? selectedItem;
  final ValueChanged<String?>? onSelect;
  final bool Function()? showWarningDialog;
  final String? warningDialogTitle;
  final String? placeholderType;

  const SelectOneTypeWithBottom({
    super.key,
    required this.items,
    this.selectedItem,
    this.onSelect,
     this.showWarningDialog,
    this.warningDialogTitle,
    this.placeholderType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return GestureDetector(
      onTap: () async {
        if (showWarningDialog?.call() ?? false) {
          await showUiKitAlertDialog(
              context,
              AlertDialogData(
                  defaultButtonText: S.of(context).Ok,
                  insetPadding: EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing16),
                  title: Text(
                    warningDialogTitle ?? S.of(context).ChangingScheduleTypeAlert,
                    textAlign: TextAlign.center,
                    style: theme?.boldTextTheme.title2.copyWith(color: UiKitColors.surface1),
                  )));
        }
        showUiKitGeneralFullScreenDialog(
          context,
          GeneralDialogData(
            topPadding: 1.sw <= 380 ? 0.5.sh : 0.6.sh,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SpacingFoundation.verticalSpace16,
                Text(
                  S.of(context).SelectOptionSchedule,
                  style: theme?.boldTextTheme.subHeadline,
                ),
                SpacingFoundation.verticalSpace16,
                Divider(
                  height: 2.h,
                  color: theme?.colorScheme.darkNeutral100.withValues(alpha: 0.24),
                ),
                ...items.map(
                  (e) {
                    return InkWell(
                      onTap: () {
                        onSelect?.call(e);
                      },
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                e,
                                style: theme?.boldTextTheme.caption1Medium,
                              ),
                            ],
                          ).paddingSymmetric(vertical: SpacingFoundation.verticalSpacing16),
                          if (e != items.last)
                            Divider(
                              height: 2.h,
                              color: theme?.colorScheme.darkNeutral100.withOpacity(0.24),
                            ),
                        ],
                      ),
                    );
                  },
                )
              ],
            ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16),
          ),
        );
      },
      child: UiKitCardWrapper(
        width: double.infinity,
        color: theme?.colorScheme.surface3,
        borderRadius: BorderRadiusFoundation.all24r,
        child: Row(
          children: [
            Text(
              selectedItem ?? placeholderType ?? S.of(context).SelectOptionSchedule,
              style: theme?.boldTextTheme.caption1Medium,
            ),
            const Spacer(),
            ImageWidget(
              iconData: ShuffleUiKitIcons.chevronright,
              color: theme?.colorScheme.inversePrimary,
            ),
          ],
        ).paddingSymmetric(
          vertical: SpacingFoundation.verticalSpacing14,
          horizontal: SpacingFoundation.horizontalSpacing20,
        ),
      ).paddingOnly(top: SpacingFoundation.verticalSpacing16),
    );
  }
}
