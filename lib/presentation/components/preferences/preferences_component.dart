import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class PreferencesComponent extends StatelessWidget {
  final VoidCallback? onSubmit;
  final UiPreferencesModel preferences;
  final Function onSelect;
  final bool isLoading;

  const PreferencesComponent({
    Key? key,
    this.onSubmit,
    required this.preferences,
    this.isLoading = false,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subHeadline = context.uiKitTheme?.boldTextTheme.subHeadline;

    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentPreferencesModel model = ComponentPreferencesModel.fromJson(config['about_user']);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context).TellUsMoreAboutYourself('\n'),
              style: context.uiKitTheme?.boldTextTheme.title1,
            ).paddingSymmetric(horizontal: horizontalMargin),
            SpacingFoundation.verticalSpace16,
            Stack(children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${S.of(context).TapOnceToChoose} ',
                      style: subHeadline,
                    ),
                    TextSpan(
                        text: S.of(context).WhatYouLike.toLowerCase(), style: subHeadline?.copyWith(color: Colors.transparent)),
                    TextSpan(
                      text: S.of(context).TapTwiceToMarkYourFavorites,
                      style: subHeadline,
                    )
                  ],
                ),
              ),
              GradientableWidget(
                gradient: GradientFoundation.attentionCard,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${S.of(context).TapOnceToChoose} ',
                        style: subHeadline?.copyWith(color: Colors.transparent),
                      ),
                      TextSpan(
                        text: S.of(context).WhatYouLike.toLowerCase(),
                        style: subHeadline?.copyWith(color: Colors.white),
                      ),
                      TextSpan(
                        text: S.of(context).TapTwiceToMarkYourFavorites,
                        style: subHeadline?.copyWith(color: Colors.transparent),
                      )
                    ],
                  ),
                ),
              )
            ]).paddingSymmetric(horizontal: horizontalMargin),
            if (model.showBubbleSearch ?? true) ...[
              SpacingFoundation.verticalSpace16,
              SizedBox(
                  width: double.infinity,
                  child: UiKitInputFieldRightIcon(
                    hintText: S.of(context).Search.toUpperCase(),
                    controller: preferences.searchController,
                    icon: preferences.searchController.text.isEmpty
                        ? ImageWidget(
                            iconData: ShuffleUiKitIcons.search,
                            color: Colors.white.withOpacity(0.5),
                          )
                        : null,
                    onIconPressed: () {
                      if (preferences.searchController.text.isNotEmpty) preferences.searchController.clear();
                    },
                  )).paddingSymmetric(horizontal: horizontalMargin),
            ],
            Expanded(
              child: LayoutBuilder(
                builder: (context, size) {
                  return ClipRect(
                      clipBehavior: Clip.hardEdge,
                      child: Bubbles(
                        width: 1.sw,
                        height: size.maxHeight,
                        widgets: preferences.chips,
                      ));
                },
              ).paddingOnly(bottom: 40.h),
            ),
          ],
        ).paddingSymmetric(vertical: verticalMargin),
      ),
      bottomSheet: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: context.button(
            data: BaseUiKitButtonData(
              text: S.of(context).StartToExplore.toUpperCase(),
              loading: isLoading,
              onPressed: onSubmit,
            ),
          ),
        ).paddingSymmetric(horizontal: horizontalMargin, vertical: 20),
      ),
    );
  }
}
