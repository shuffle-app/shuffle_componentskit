import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class SelectScheduleType extends StatelessWidget {
  final List<String> scheduleTypes;
  final String? selectedScheduleName;
  final ValueChanged<String?>? onSelectType;

  const SelectScheduleType({
    super.key,
    required this.scheduleTypes,
    this.selectedScheduleName,
    this.onSelectType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    //TODO region
    return InkWell(
      onTap: () {
        showUiKitGeneralFullScreenDialog(
          context,
          GeneralDialogData(
            topPadding: 0.5.sh,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SpacingFoundation.verticalSpace16,
                Text(
                  S.of(context).SelectOption,
                  style: theme?.boldTextTheme.subHeadline,
                ),
                SpacingFoundation.verticalSpace16,
                Divider(
                  height: 2.h,
                  color: theme?.colorScheme.darkNeutral100.withOpacity(0.24),
                ),
                ...scheduleTypes.map(
                  (e) {
                    return InkWell(
                      onTap: () {
                        onSelectType?.call(e);
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
                          if (e != scheduleTypes.last)
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
              selectedScheduleName ?? S.of(context).SelectOption,
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