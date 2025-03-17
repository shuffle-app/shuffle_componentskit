import 'package:flutter/widgets.dart';
import 'package:shuffle_components_kit/presentation/components/notification_offer_reminder_components/universal_not_offer_rem_ui_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CustomTitleWidgetPromo extends StatelessWidget {
  final UniversalNotOfferRemUiModel model;
  const CustomTitleWidgetPromo({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final caption4Muted = theme?.regularTextTheme.caption4Regular.copyWith(color: ColorsFoundation.mutedText);

    return Row(
      children: [
        context.userAvatar(
          size: UserAvatarSize.x40x40,
          type: UserTileType.ordinary,
          userName: '',
          imageUrl: model.imagePath,
        ),
        SpacingFoundation.horizontalSpace12,
        Flexible(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                    formatDateWithCustomPattern('dd.MM.yyyy', (model.isLaunchedDate ?? DateTime.now()).toLocal()),
                    style: caption4Muted,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
