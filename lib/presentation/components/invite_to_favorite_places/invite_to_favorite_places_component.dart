import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class InviteToFavoritePlacesComponent extends StatelessWidget {
  final VoidCallback? onInvite;
  final VoidCallback? onDatePressed;
  final UiInviteToFavoritePlacesModel uiModel;
  final List<UiKitLeadingRadioTile> places;
  final List<UiKitLeadingRadioTile> events;

  const InviteToFavoritePlacesComponent({
    super.key,
    this.onInvite,
    this.onDatePressed,
    required this.uiModel,
    required this.places,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;
    final regularTextTheme = context.uiKitTheme?.regularTextTheme;
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentModel model = ComponentModel.fromJson(config['invite_people_places'] ?? {});
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();

    final itemCount = (places.isNotEmpty ? places.length + 1 : 0) + (events.isNotEmpty ? events.length + 1 : 0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SpacingFoundation.verticalSpace16,
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Text(
                S.of(context).InviteToFavoritePlaces,
                style: boldTextTheme?.subHeadline,
              ),
            ),
            SpacingFoundation.horizontalSpace16,
            context.smallGradientButton(
              data: BaseUiKitButtonData(
                text: S.of(context).Invite,
                onPressed: onInvite,
              ),
            ),
          ],
        ).paddingSymmetric(
          horizontal: horizontalMargin,
          vertical: verticalMargin,
        ),
        SpacingFoundation.verticalSpace16,
        UiKitCardWrapper(
          height: 0.55.sh,
          borderRadius: BorderRadius.zero,
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              if (places.isEmpty && events.isEmpty) {
                return Text(
                  S.of(context).NoFavoritesFound,
                  style: regularTextTheme?.title2,
                );
              }
              if (index == 0 && places.isNotEmpty) {
                return Text(
                  S.of(context).Places,
                  style: regularTextTheme?.title2,
                );
              } else if (index == (places.isNotEmpty ? places.length + 1 : 0) && events.isNotEmpty) {
                return Text(
                  S.of(context).Events,
                  style: regularTextTheme?.title2,
                );
              } else if (index <= places.length) {
                return places[index - 1];
              } else {
                return events[index - (places.isNotEmpty ? places.length - 1 : 0) - 1];
              }
            },
            separatorBuilder: (context, index) => SpacingFoundation.verticalSpace16,
            itemCount: itemCount == 0 ? 1 : itemCount,
          ).paddingSymmetric(
            horizontal: horizontalMargin,
            vertical: verticalMargin,
          ),
        ),
        SpacingFoundation.verticalSpace16,
        Text(
          S.of(context).SelectDate,
          style: boldTextTheme?.subHeadline,
          textAlign: TextAlign.start,
        ).paddingSymmetric(
          horizontal: horizontalMargin,
        ),
        SpacingFoundation.verticalSpace12,
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            context.smallOutlinedButton(
              blurred: false,
              data: BaseUiKitButtonData(
                onPressed: onDatePressed,
                iconInfo: BaseUiKitButtonIconData(
                  iconData: ShuffleUiKitIcons.calendar,
                ),
              ),
            ),
            SpacingFoundation.horizontalSpace12,
            Text(
              uiModel.date == null
                  ? ''
                  : DateFormat('MMMM dd').format(
                      uiModel.date!,
                    ),
              style: regularTextTheme?.body,
            ),
          ],
        ).paddingSymmetric(
          horizontal: horizontalMargin,
        ),
        SpacingFoundation.verticalSpace24,
        SpacingFoundation.verticalSpace16,
      ],
    );
  }
}
