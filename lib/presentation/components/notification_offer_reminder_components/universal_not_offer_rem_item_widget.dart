import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UniversalNotOfferRemItemWidget extends StatelessWidget {
  final UniversalNotOfferRemUiModel model;
  final VoidCallback? onEdit;
  final VoidCallback? onActivateTap;
  final VoidCallback? onDismissed;
  final VoidCallback? onLongPress;
  final VoidCallback? onPayTap;
  final bool isEditingMode;

  const UniversalNotOfferRemItemWidget({
    super.key,
    required this.model,
    this.onEdit,
    this.onActivateTap,
    this.onDismissed,
    this.isEditingMode = false,
    this.onLongPress,
    this.onPayTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final caption4Muted = theme?.regularTextTheme.caption4Regular.copyWith(color: ColorsFoundation.mutedText);

    return Dismissible(
      key: ValueKey(model.id),
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
        onLongPress: model.status == TicketIssueStatus.paid ? onLongPress : null,
        child: UiKitCardWrapper(
          color: theme?.colorScheme.surface1,
          borderRadius: BorderRadiusFoundation.all24r,
          child: Stack(
            children: [
              Row(
                children: [
                  if (model.imagePath != null && model.imagePath!.isNotEmpty)
                    context.userAvatar(
                      size: UserAvatarSize.x40x40,
                      type: UserTileType.ordinary,
                      userName: '',
                      imageUrl: model.imagePath,
                    )
                  else
                    ImageWidget(
                      height: 45.h,
                      fit: BoxFit.fill,
                      link: model.iconPath ?? '',
                    ),
                  SpacingFoundation.horizontalSpace4,
                  Flexible(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (model.isOffer)
                          Text(
                            model.pointPrice == 0
                                ? S.of(context).Free
                                : '${stringWithSpace(model.pointPrice ?? 0)} ${S.of(context).PointsInOffer(model.pointPrice ?? 0)}',
                            style: theme?.boldTextTheme.caption1Bold,
                          ).paddingOnly(bottom: SpacingFoundation.verticalSpacing2),
                        AutoSizeText(
                          model.title ?? S.of(context).NothingFound,
                          style: theme?.boldTextTheme.caption1Bold,
                        ),
                        SpacingFoundation.verticalSpace2,
                        model.selectedDates?.last != null
                            ? AutoSizeText(
                                '${formatDateWithCustomPattern('dd.MM', (model.selectedDates!.first ?? DateTime.now()).toLocal())} - ${formatDateWithCustomPattern('dd.MM.yyyy', model.selectedDates!.last!.toLocal())}',
                                maxLines: 1,
                                minFontSize: 10,
                                style: theme?.boldTextTheme.caption3Medium.copyWith(color: ColorsFoundation.mutedText),
                              )
                            : Text(
                                model.selectedDates?.first?.year == DateTime.now().year
                                    ? formatDateWithCustomPattern(
                                        'MMMM d',
                                        (model.selectedDates?.first ?? DateTime.now()).toLocal(),
                                      ).capitalize()
                                    : formatDateWithCustomPattern(
                                        'dd.MM.yyyy',
                                        (model.selectedDates?.first ?? DateTime.now()).toLocal(),
                                      ),
                                style: theme?.boldTextTheme.caption3Medium.copyWith(color: ColorsFoundation.mutedText),
                              ),
                        SpacingFoundation.verticalSpace2,
                        if (model.status == TicketIssueStatus.unpaid)
                          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            ImageWidget(
                              height: 10.h,
                              fit: BoxFit.fill,
                              color: ColorsFoundation.mutedText,
                              iconData: ShuffleUiKitIcons.stopfill,
                            ),
                            SpacingFoundation.horizontalSpace2,
                            Flexible(
                                child: Text(
                              S.of(context).AwaitingPayment,
                              style: caption4Muted,
                            )),
                            SpacingFoundation.horizontalSpace2,
                            Flexible(
                              child: context.smallGradientButton(
                                data: BaseUiKitButtonData(
                                  text: S.of(context).Pay,
                                  onPressed: onPayTap,
                                  fit: ButtonFit.fitWidth,
                                ),
                              ),
                            )
                          ])
                        else
                          Row(
                            children: [
                              ImageWidget(
                                height: 10.h,
                                fit: BoxFit.fill,
                                color: ColorsFoundation.mutedText,
                                iconData: model.isLaunched ? ShuffleUiKitIcons.playfill : ShuffleUiKitIcons.stopfill,
                              ),
                              SpacingFoundation.horizontalSpace2,
                              Expanded(
                                child: Text(
                                  model.isLaunched
                                      ? S.of(context).Launched
                                      : DateTime.now().isBefore(model.isLaunchedDate!)
                                          ? S.of(context).Pending
                                          : S.of(context).Expired,
                                  style: caption4Muted,
                                ),
                              ),
                              SpacingFoundation.horizontalSpace2,
                              Text(
                                formatDateWithCustomPattern(
                                    'dd.MM.yyyy', (model.isLaunchedDate ?? DateTime.now()).toLocal()),
                                style: caption4Muted,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  if ((model.isOffer && model.status == TicketIssueStatus.paid) || model.isPromo) ...[
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
