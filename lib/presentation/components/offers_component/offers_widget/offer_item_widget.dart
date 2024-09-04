import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';

class OfferItemWidget extends StatelessWidget {
  final OfferUiModel? offerUiModel;
  final VoidCallback? onTap;
  final VoidCallback? onDismissed;

  const OfferItemWidget({
    super.key,
    this.offerUiModel,
    this.onTap,
    this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return UiKitCardWrapper(
      borderRadius: BorderRadiusFoundation.all24r,
      child: Dismissible(
        key: GlobalKey(),
        direction: DismissDirection.endToStart,
        background: SpacingFoundation.none,
        dismissThresholds: const {DismissDirection.endToStart: 0.6},
        secondaryBackground: DecoratedBox(
          decoration: BoxDecoration(
            color: ColorsFoundation.red,
            borderRadius: BorderRadiusFoundation.all24r,
          ),
          child: Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                context.iconButtonNoPadding(
                  data: BaseUiKitButtonData(
                    iconInfo: BaseUiKitButtonIconData(
                      iconData: ShuffleUiKitIcons.trash,
                    ),
                  ),
                ),
                SpacingFoundation.horizontalSpace2,
                Text(
                  S.of(context).Remove,
                  style: theme?.boldTextTheme.caption2Medium,
                ),
                SpacingFoundation.horizontalSpace12,
              ],
            ),
          ),
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            return false;
          } else if (direction == DismissDirection.endToStart) {
            return true;
          }
          return false;
        },
        onDismissed: (DismissDirection direction) {
          if (direction == DismissDirection.endToStart) {
            onDismissed?.call();
          }
        },
        child: Row(
          children: [
            ImageWidget(
              height: 45.h,
              fit: BoxFit.fill,
              link: offerUiModel?.iconPath ?? '',
            ),
            SpacingFoundation.horizontalSpace4,
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offerUiModel?.pointPrice == 0
                        ? S.of(context).Free
                        : '${stringWithSpace(offerUiModel?.pointPrice ?? 0)} ${S.of(context).Points}',
                    style: theme?.boldTextTheme.caption1Bold,
                  ),
                  SpacingFoundation.verticalSpace2,
                  AutoSizeText(
                    offerUiModel?.title ?? S.of(context).NothingFound,
                    style: theme?.boldTextTheme.caption1Bold,
                  ),
                  SpacingFoundation.verticalSpace2,
                  offerUiModel?.selectedDates?.last != null
                      ? AutoSizeText(
                          '${formatDateWithCustomPattern('dd.MM', (offerUiModel!.selectedDates!.first ?? DateTime.now()).toLocal())} - ${formatDateWithCustomPattern('dd.MM.yyyy', offerUiModel!.selectedDates!.last!.toLocal())}',
                          maxLines: 1,
                          minFontSize: 10,
                          style: theme?.boldTextTheme.caption3Medium.copyWith(
                            color: ColorsFoundation.mutedText,
                          ),
                        )
                      : Text(
                          offerUiModel?.selectedDates?.first?.year == DateTime.now().year
                              ? formatDateWithCustomPattern(
                                  'MMMM dd',
                                  (offerUiModel?.selectedDates?.first ?? DateTime.now()).toLocal(),
                                ).capitalize()
                              : formatDateWithCustomPattern(
                                  'dd.MM.yyyy',
                                  (offerUiModel?.selectedDates?.first ?? DateTime.now()).toLocal(),
                                ),
                          style: theme?.boldTextTheme.caption3Medium.copyWith(
                            color: ColorsFoundation.mutedText,
                          ),
                        ),
                  SpacingFoundation.verticalSpace2,
                  Row(
                    children: [
                      ImageWidget(
                        height: 10.h,
                        fit: BoxFit.fill,
                        color: ColorsFoundation.mutedText,
                        link: offerUiModel?.isLaunched ?? true
                            ? GraphicsFoundation.instance.svg.playOutline.path
                            : GraphicsFoundation.instance.svg.stopOutline.path,
                      ),
                      SpacingFoundation.horizontalSpace2,
                      Expanded(
                        child: Text(
                          offerUiModel?.isLaunched ?? true ? S.of(context).Launched : S.of(context).Expired,
                          style: theme?.regularTextTheme.caption4Regular.copyWith(
                            color: ColorsFoundation.mutedText,
                          ),
                        ),
                      ),
                      SpacingFoundation.horizontalSpace2,
                      Text(
                        formatDateWithCustomPattern(
                            'dd.MM.yyyy', (offerUiModel?.isLaunchedDate ?? DateTime.now()).toLocal()),
                        style: theme?.regularTextTheme.caption4Regular.copyWith(
                          color: ColorsFoundation.mutedText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SpacingFoundation.horizontalSpace8,
            Flexible(
              child: context.button(
                data: BaseUiKitButtonData(
                  onPressed: onTap,
                  backgroundColor: theme?.colorScheme.surface3,
                  iconInfo: BaseUiKitButtonIconData(
                    iconPath: GraphicsFoundation.instance.svg.chevronRight.path,
                    color: theme?.colorScheme.headingTypography,
                  ),
                ),
              ),
            ),
          ],
        ).paddingAll(EdgeInsetsFoundation.all12),
      ),
    );
  }
}
