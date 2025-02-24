import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UniversalNotOfferRemItemWidget extends StatelessWidget {
  final UniversalNotOfferRemUiModel? universalNotOfferRemUiModel;
  final VoidCallback? onEdit;
  final VoidCallback? onActivateTap;
  final VoidCallback? onDismissed;
  final VoidCallback? onLongPress;
  final bool isEditingMode;

  const UniversalNotOfferRemItemWidget({
    super.key,
    this.universalNotOfferRemUiModel,
    this.onEdit,
    this.onActivateTap,
    this.onDismissed,
    this.isEditingMode = false,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return Dismissible(
      key: GlobalKey(),
      direction: DismissDirection.endToStart,
      dismissThresholds: const {DismissDirection.endToStart: 0.6},
      background: UiKitBackgroundDismissible(),
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
      child: GestureDetector(
        onLongPress: onLongPress,
        child: UiKitCardWrapper(
          color: theme?.colorScheme.surface1,
          borderRadius: BorderRadiusFoundation.all24r,
          child: Stack(
            children: [
              Row(
                children: [
                  ImageWidget(
                    height: 45.h,
                    fit: BoxFit.fill,
                    link: universalNotOfferRemUiModel?.iconPath ?? '',
                  ),
                  SpacingFoundation.horizontalSpace4,
                  Flexible(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (universalNotOfferRemUiModel != null && (universalNotOfferRemUiModel?.isOffer ?? false))
                          Text(
                            universalNotOfferRemUiModel?.pointPrice == 0
                                ? S.of(context).Free
                                : '${stringWithSpace(universalNotOfferRemUiModel?.pointPrice ?? 0)} ${S.of(context).PointsInOffer(universalNotOfferRemUiModel?.pointPrice ?? 0)}',
                            style: theme?.boldTextTheme.caption1Bold,
                          ).paddingOnly(bottom: SpacingFoundation.verticalSpacing2),
                        AutoSizeText(
                          universalNotOfferRemUiModel?.title ?? S.of(context).NothingFound,
                          style: theme?.boldTextTheme.caption1Bold,
                        ),
                        SpacingFoundation.verticalSpace2,
                        universalNotOfferRemUiModel?.selectedDates?.last != null
                            ? AutoSizeText(
                                '${formatDateWithCustomPattern('dd.MM', (universalNotOfferRemUiModel!.selectedDates!.first ?? DateTime.now()).toLocal())} - ${formatDateWithCustomPattern('dd.MM.yyyy', universalNotOfferRemUiModel!.selectedDates!.last!.toLocal())}',
                                maxLines: 1,
                                minFontSize: 10,
                                style: theme?.boldTextTheme.caption3Medium.copyWith(color: ColorsFoundation.mutedText),
                              )
                            : Text(
                                universalNotOfferRemUiModel?.selectedDates?.first?.year == DateTime.now().year
                                    ? formatDateWithCustomPattern(
                                        'MMMM d',
                                        (universalNotOfferRemUiModel?.selectedDates?.first ?? DateTime.now()).toLocal(),
                                      ).capitalize()
                                    : formatDateWithCustomPattern(
                                        'dd.MM.yyyy',
                                        (universalNotOfferRemUiModel?.selectedDates?.first ?? DateTime.now()).toLocal(),
                                      ),
                                style: theme?.boldTextTheme.caption3Medium.copyWith(color: ColorsFoundation.mutedText),
                              ),
                        SpacingFoundation.verticalSpace2,
                        Row(
                          children: [
                            ImageWidget(
                              height: 10.h,
                              fit: BoxFit.fill,
                              color: ColorsFoundation.mutedText,
                              iconData: universalNotOfferRemUiModel?.isLaunched ?? true
                                  ? ShuffleUiKitIcons.playoutline
                                  : ShuffleUiKitIcons.stopoutline,
                            ),
                            SpacingFoundation.horizontalSpace2,
                            Expanded(
                              child: Text(
                                universalNotOfferRemUiModel?.isLaunched ?? true
                                    ? S.of(context).Launched
                                    : S.of(context).Expired,
                                style:
                                    theme?.regularTextTheme.caption4Regular.copyWith(color: ColorsFoundation.mutedText),
                              ),
                            ),
                            SpacingFoundation.horizontalSpace2,
                            Text(
                              formatDateWithCustomPattern('dd.MM.yyyy',
                                  (universalNotOfferRemUiModel?.isLaunchedDate ?? DateTime.now()).toLocal()),
                              style:
                                  theme?.regularTextTheme.caption4Regular.copyWith(color: ColorsFoundation.mutedText),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if ((universalNotOfferRemUiModel?.isOffer ?? false)) ...[
                    SpacingFoundation.horizontalSpace8,
                    Flexible(
                      child: context.button(
                        data: BaseUiKitButtonData(
                          onPressed: onActivateTap,
                          backgroundColor: theme?.colorScheme.surface3,
                          iconInfo: BaseUiKitButtonIconData(
                            iconData: ShuffleUiKitIcons.chevronright,
                            color: theme?.colorScheme.headingTypography,
                          ),
                        ),
                      ),
                    ),
                  ]
                ],
              ).paddingAll(EdgeInsetsFoundation.all12),
              if (isEditingMode)
                Positioned.fill(
                  child: ColoredBox(
                    color: ColorsFoundation.neutral48,
                    child: Center(
                      child: context.button(
                        data: BaseUiKitButtonData(
                          borderColor: theme?.colorScheme.headingTypography,
                          onPressed: onEdit,
                          backgroundColor: theme?.colorScheme.surface3,
                          iconInfo: BaseUiKitButtonIconData(
                            iconPath: GraphicsFoundation.instance.svg.pencil.path,
                            color: theme?.colorScheme.headingTypography,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
