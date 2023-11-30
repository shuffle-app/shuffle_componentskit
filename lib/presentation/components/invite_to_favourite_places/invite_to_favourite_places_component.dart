import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class InviteToFavouritePlacesComponent extends StatelessWidget {
  final VoidCallback? onInvite;
  final VoidCallback? onDatePressed;
  final UiInviteToFavouritePlacesModel uiModel;
  final List<UiKitLeadingRadioTile> places;

  const InviteToFavouritePlacesComponent({
    super.key,
    this.onInvite,
    this.onDatePressed,
    required this.uiModel,
    required this.places,
  });

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;
    final regularTextTheme = context.uiKitTheme?.regularTextTheme;
    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentModel model = ComponentModel.fromJson(config['invite_people_places'] ?? {});
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();

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
                S.of(context).InviteToFavouritePlaces,
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
          color: ColorsFoundation.surface1,
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) => places[index],
            separatorBuilder: (context, index) => SpacingFoundation.verticalSpace16,
            itemCount: places.length,
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
                icon: const ImageWidget(
                  iconData: ShuffleUiKitIcons.calendar,
                  color: Colors.white,
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
