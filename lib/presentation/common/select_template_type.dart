import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import 'create_schedule_widget.dart';

class SelectTemplateType extends StatelessWidget {
  final List<UiScheduleModel> scheduleTypes;
  final String? selectedScheduleName;
  final ValueChanged<UiScheduleModel?>? onChanged;

  const SelectTemplateType({
    super.key,
    required this.scheduleTypes,
    this.selectedScheduleName,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return InkWell(
      onTap: () {
        showUiKitGeneralFullScreenDialog(
          context,
          GeneralDialogData(
            isWidgetScrollable: true,
            topPadding: 0.5.sh,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SpacingFoundation.verticalSpace16,
                Text(
                  S.of(context).SelectTemplate,
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
                        onChanged?.call(e);
                      },
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                e.templateName ?? S.of(context).NothingFound,
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
        color: theme?.colorScheme.surface3,
        borderRadius: BorderRadiusFoundation.all24r,
        child: Row(
          children: [
            Text(
              selectedScheduleName ?? S.of(context).SelectTemplate,
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
