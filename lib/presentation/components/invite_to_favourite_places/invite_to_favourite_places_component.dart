import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class InviteToFavouritePlacesComponent extends StatelessWidget {
  final VoidCallback? onInvite;
  final VoidCallback? onDatePressed;
  final UiInviteToFavouritePlacesModel uiModel;

  const InviteToFavouritePlacesComponent({
    super.key,
    this.onInvite,
    this.onDatePressed,
    required this.uiModel,
  });

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;
    final regularTextTheme = context.uiKitTheme?.regularTextTheme;
    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentModel model = ComponentModel.fromJson(config['invite_people_places'] ?? {});
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 16).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 8).toDouble();
    final bodyAlignment = model.positionModel?.bodyAlignment;

    return Theme(
      data: UiKitThemeFoundation.defaultTheme,
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            SpacingFoundation.verticalSpace16,
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Text(
                    'Invite to favourite places',
                    style: boldTextTheme?.subHeadline,
                  ),
                ),
                SpacingFoundation.horizontalSpace16,
                context.smallButton(
                  data: BaseUiKitButtonData(
                    text: 'Invite',
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
                itemBuilder: (context, index) => UiKitLeadingRadioTile(
                  title: 'title',
                  avatarLink: GraphicsFoundation.instance.png.inviteMock1.path,
                  tags: [
                    UiKitTag(title: 'title', iconPath: GraphicsFoundation.instance.svg.cocktail.path),
                    UiKitTag(title: 'title', iconPath: GraphicsFoundation.instance.svg.cocktail.path),
                    UiKitTag(title: 'title', iconPath: GraphicsFoundation.instance.svg.cocktail.path),
                    UiKitTag(title: 'title', iconPath: GraphicsFoundation.instance.svg.cocktail.path),
                  ],
                ),
                separatorBuilder: (context, index) => SpacingFoundation.verticalSpace16,
                itemCount: 10,
              ).paddingSymmetric(
                horizontal: horizontalMargin,
                vertical: verticalMargin,
              ),
            ),
            SpacingFoundation.verticalSpace16,
            Text(
              'Select date',
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
                    icon: ImageWidget(
                      link: GraphicsFoundation.instance.svg.calendar.path,
                      color: Colors.white,
                    ).paddingAll(EdgeInsetsFoundation.all6),
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
        ),
      ),
    );
  }
}
