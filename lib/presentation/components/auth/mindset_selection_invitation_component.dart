import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MindsetSelectionInvitationComponent extends StatelessWidget {
  final VoidCallback goCallback;

  const MindsetSelectionInvitationComponent({super.key, required this.goCallback});

  AssetGenImage _getIconForTile(int index) {
    switch (index) {
      case 0:
        return GraphicsFoundation.instance.png.starryEyedExcitedEmoji;
      case 1:
        return GraphicsFoundation.instance.png.likeMinded;
      case 2:
        return GraphicsFoundation.instance.png.newPlacesEvents;
      default:
        return GraphicsFoundation.instance.png.findPeople;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final boldTextTheme = theme?.boldTextTheme;
    final AutoSizeGroup group = AutoSizeGroup();

    return SafeArea(
        child: Column(
      children: [
        SpacingFoundation.verticalSpace24,
        Stack(
            alignment: Alignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(text: S.of(context).TellUsAbout, style: boldTextTheme?.title2),
                    TextSpan(
                        text: ' ${S.of(context).Yourself} '.toLowerCase(),
                        style: boldTextTheme?.title2.copyWith(color: Colors.transparent)),
                    TextSpan(text: S.of(context).AndGet.toLowerCase(), style: boldTextTheme?.title2)
                  ])),
              GradientableWidget(
                  gradient: GradientFoundation.attentionCard,
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                            text: S.of(context).TellUsAbout,
                            style: boldTextTheme?.title2.copyWith(color: Colors.transparent)),
                        TextSpan(
                            text: ' ${S.of(context).Yourself} '.toLowerCase(),
                            style: boldTextTheme?.title2.copyWith(color: Colors.white)),
                        TextSpan(
                            text: S.of(context).AndGet.toLowerCase(),
                            style: boldTextTheme?.title2.copyWith(color: Colors.transparent))
                      ])))
            ]),
        SpacingFoundation.verticalSpace16,
        for (int i = 0; i < 4; i++)
          ListTile(
            titleAlignment: ListTileTitleAlignment.center,
            minLeadingWidth: 32.h,
            contentPadding: EdgeInsets.symmetric(vertical: SpacingFoundation.verticalSpacing6),
            leading: ImageWidget(
              // height: 32.h,
              rasterAsset: _getIconForTile(i),
            ),
            title: AutoSizeText(
              S.of(context).SelectMindsetInvitation(i),
              style: boldTextTheme?.caption1Bold,
              maxLines: 3,
              group: group,
            ),
          ),
        SpacingFoundation.verticalSpace16,
        context.gradientButton(
            data: BaseUiKitButtonData(
          fit: ButtonFit.fitWidth,
          text: S.of(context).Go,
          onPressed: goCallback,
        ))
      ],
    ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16));
  }
}
