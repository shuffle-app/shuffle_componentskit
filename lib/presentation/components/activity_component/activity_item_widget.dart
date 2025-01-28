import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/activity_component/activity_ui_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class ActivityItemWidget extends StatelessWidget {
  final ActivityUiModel? activityUiModel;
  const ActivityItemWidget({
    super.key,
    this.activityUiModel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final colorScheme = theme?.colorScheme;
    final boldTextTheme = theme?.boldTextTheme;

    return UiKitCardWrapper(
      borderRadius: BorderRadiusFoundation.all24r,
      color: theme?.colorScheme.surface1,
      child: Row(
        children: [
          UiKitCardWrapper(
            borderRadius: BorderRadiusFoundation.all12,
            width: 61.w,
            height: 40.h,
            child: ImageWidget(
              link: activityUiModel?.imageUrl,
              fit: BoxFit.fill,
            ),
          ).paddingOnly(
            top: SpacingFoundation.verticalSpacing12,
            bottom: SpacingFoundation.verticalSpacing12,
            left: SpacingFoundation.horizontalSpacing12,
          ),
          SpacingFoundation.horizontalSpace8,
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (activityUiModel?.title != null && activityUiModel!.title!.isNotEmpty)
                SizedBox(
                  width: 150.w,
                  child: Text(
                    activityUiModel!.title!,
                    style: theme?.boldTextTheme.caption3Medium,
                  ),
                ),
              SpacingFoundation.verticalSpace2,
              SizedBox(
                height: 15.w,
                width: 150.w,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    if (activityUiModel?.rating != null && activityUiModel?.rating != 0.0)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ImageWidget(
                            iconData: ShuffleUiKitIcons.starfill,
                            color: colorScheme?.inverseSurface,
                            height: 0.040625.sw,
                            width: 0.040625.sw,
                            fit: BoxFit.cover,
                          ),
                          SpacingFoundation.horizontalSpace2,
                          Text(
                            doubleFormat(activityUiModel!.rating!),
                            style: boldTextTheme?.caption3Medium,
                          ).paddingOnly(top: 2.w),
                          SpacingFoundation.horizontalSpace12,
                        ],
                      ),
                    if (activityUiModel?.tags != null && activityUiModel!.tags!.isNotEmpty)
                      ...activityUiModel!.tags!.map(
                        (e) => UiKitTagWidget(
                          title: e.title,
                          icon: e.icon,
                        ).paddingOnly(right: SpacingFoundation.horizontalSpacing12),
                      ),
                  ],
                ),
              )
            ],
          ).paddingSymmetric(vertical: SpacingFoundation.verticalSpacing12),
          if (activityUiModel?.activity != null && activityUiModel?.activity != 0)
            UiKitCardWrapper(
              color: colorScheme?.surface3,
              borderRadius: BorderRadiusFoundation.zero,
              width: 50.w,
              height: 65.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageWidget(
                    color: colorScheme?.inversePrimary,
                    svgAsset: GraphicsFoundation.instance.svg.twoPeople,
                  ),
                  SpacingFoundation.verticalSpace4,
                  Text(
                    '${activityUiModel!.activity!}',
                    style: boldTextTheme?.body,
                  ),
                ],
              ),
            ).paddingOnly(left: SpacingFoundation.horizontalSpacing12)
        ],
      ),
    );
  }
}
