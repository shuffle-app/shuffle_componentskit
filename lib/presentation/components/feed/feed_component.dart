import 'dart:math';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class FeedComponent extends StatelessWidget {
  final UiFeedModel feed;
  final Function? onMoodPressed;
  final Function? onEventPressed;
  final Function? onPlacePressed;
  final Function? onTagSortPressed;
  final VoidCallback? onHowItWorksPoped;

  const FeedComponent(
      {Key? key,
      required this.feed,
      this.onMoodPressed,
      this.onEventPressed,
      this.onPlacePressed,
      this.onTagSortPressed,
      this.onHowItWorksPoped})
      : super(key: key);

  Widget _howItWorksDialog(context, textStyle) => UiKitHintDialog(
        title: 'Depending on...',
        subtitle: 'you get exactly what you need',
        textStyle: textStyle,
        dismissText: 'OKAY, COOL!',
        onDismiss: () {
          onHowItWorksPoped?.call();

          return Navigator.pop(context);
        },
        hintTiles: [
          UiKitIconHintCard(
            icon: ImageWidget(
              height: 74.h,
              fit: BoxFit.fitHeight,
              rasterAsset: GraphicsFoundation.instance.png.map,
            ),
            hint: 'your location',
          ),
          UiKitIconHintCard(
            icon: ImageWidget(
              height: 74.h,
              fit: BoxFit.fitHeight,
              rasterAsset: GraphicsFoundation.instance.png.dart,
            ),
            hint: 'your interests',
          ),
          UiKitIconHintCard(
            icon: ImageWidget(
              height: 74.h,
              fit: BoxFit.fitHeight,
              rasterAsset: GraphicsFoundation.instance.png.sunClouds,
            ),
            hint: 'weather around',
          ),
          UiKitIconHintCard(
            icon: ImageWidget(
              height: 74.h,
              fit: BoxFit.fitHeight,
              rasterAsset: GraphicsFoundation.instance.png.smileMood,
            ),
            hint: 'and other 14 scales',
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ??
            GlobalConfiguration().appConfig.content;
    final ComponentFeedModel model =
        ComponentFeedModel.fromJson(config['feed']);

    final themeTitleStyle = context.uiKitTheme?.boldTextTheme.title1;
    final size = MediaQuery.of(context).size;
    final horizontalMargin =
        (model.positionModel?.horizontalMargin ?? 0).toDouble();
    // final horizontalWidthBox =
    //     (horizontalMargin - SpacingFoundation.horizontalSpacing4).widthBox;
    final bodyAlignment = model.positionModel?.bodyAlignment;


    return CustomScrollView(
        controller: ScrollController(),
        slivers:
            // Column(
            //   mainAxisAlignment: bodyAlignment.mainAxisAlignment,
            //   crossAxisAlignment: bodyAlignment.crossAxisAlignment,
            //   children:
            [
          SpacingFoundation.verticalSpace16.wrapSliverBox,
          if (feed.recommendedEvent != null &&
              (model.showDailyRecomendation ?? true)) ...[
            SafeArea(
                bottom: false,
                child: UiKitAccentCard(
                  onPressed: onEventPressed == null
                      ? null
                      : () => onEventPressed!(feed.recommendedEvent?.id),
                  title: feed.recommendedEvent!.title ?? '',
                  additionalInfo: feed.recommendedEvent!.descriptionItems?.first
                          .description ??
                      '',
                  accentMessage: 'Don\'t miss it',
                  image: ImageWidget(
                    link: feed.recommendedEvent?.media?.first.link,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorWidget: const UiKitBigPhotoErrorWidget(),
                  ),
                )).paddingSymmetric(horizontal: horizontalMargin).wrapSliverBox,
            SpacingFoundation.verticalSpace24.wrapSliverBox,
          ],
          if (feed.moods != null && (model.showFeelings ?? true)) ...[
            Stack(
              children: [
                Text('How’re you feeling tonight?', style: themeTitleStyle),
                if (feed.showHowItWorks)
                  Transform.translate(
                    offset: Offset(size.width / 1.7, 35),
                    child: Transform.rotate(
                      angle: pi * -20 / 180,
                      child: RotatableWidget(
                        animDuration: const Duration(milliseconds: 150),
                        endAngle: pi * 20 / 180,
                        alignment: Alignment.center,
                        applyReverseOnEnd: true,
                        startDelay: const Duration(seconds: 10),
                        child: UiKitBlurredQuestionChip(
                          label: 'How it\nworks',
                          onTap: () => showUiKitFullScreenAlertDialog(context,
                              child: _howItWorksDialog,
                              paddingAll: EdgeInsetsFoundation.all12),
                        ),
                      ),
                    ),
                  ),
              ],
            ).paddingSymmetric(horizontal: horizontalMargin).wrapSliverBox,
            SpacingFoundation.verticalSpace16.wrapSliverBox,
            SingleChildScrollView(
              primary: false,
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: horizontalMargin,
                children: [
                  const SizedBox.shrink(),
                  ...feed.moods!
                      .map((e) => UiKitMessageCardWithIcon(
                            message: e.title,
                            icon: ImageWidget(
                              link: e.logo,
                              fit: BoxFit.fitWidth,
                            ),
                            layoutDirection: Axis.vertical,
                            onPressed: onMoodPressed == null
                                ? null
                                : () => onMoodPressed!(e.id),
                          ))
                      .toList(),
                  const SizedBox.shrink(),
                ],
              ),
            ).wrapSliverBox,
            SpacingFoundation.verticalSpace24.wrapSliverBox,
          ],
          if (feed.places != null && (model.showPlaces ?? true)) ...[
            Text(
              'You better check this out',
              style: themeTitleStyle,
              textAlign: TextAlign.left,
            ).paddingSymmetric(horizontal: horizontalMargin).wrapSliverBox,
            if (feed.filterChips != null && feed.filterChips!.isNotEmpty) ...[
              SpacingFoundation.verticalSpace8.wrapSliverBox,
              SingleChildScrollView(
                primary: false,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    horizontalMargin.widthBox,
                    // horizontalWidthBox,
                    context.gradientButton(
                      data: BaseUiKitButtonData(
                          icon: ImageWidget(
                            svgAsset: GraphicsFoundation.instance.svg.dice,
                            height: 17,
                            fit: BoxFit.fitHeight,
                          ),
                          onPressed: onTagSortPressed == null
                              ? null
                              : () => onTagSortPressed!('Random')),
                    ),
                    UiKitTitledFilterChip(
                      selected: feed.activeFilterChips
                              ?.map((e) => e.title)
                              .contains('Favorites') ??
                          false,
                      title: 'Favorites',
                      onPressed: onTagSortPressed == null
                          ? null
                          : () => onTagSortPressed!('Favorites'),
                      icon: GraphicsFoundation.instance.svg.star.path,
                    ).paddingSymmetric(
                        horizontal: SpacingFoundation.horizontalSpacing8),
                    Wrap(
                        spacing: SpacingFoundation.verticalSpacing8,
                        children: feed.filterChips!
                            .map((e) => UiKitTitledFilterChip(
                                  selected: feed.activeFilterChips
                                          ?.map((e) => e.title)
                                          .contains(e.title) ??
                                      false,
                                  title: e.title,
                                  onPressed: onTagSortPressed == null
                                      ? null
                                      : () => onTagSortPressed!(e.title),
                                  icon: e.iconPath,
                                ))
                            .toList()),
                  ],
                ),
              ).wrapSliverBox,
            ],
            SpacingFoundation.verticalSpace24.wrapSliverBox,
          ],
          SliverList.separated(
              //     ],
              // body:
              // ListView.separated(
              //     shrinkWrap: true,
              //     primary: false,
              itemBuilder: (_, index) => index == feed.places!.length
                  ? kBottomNavigationBarHeight.heightBox
                  : PlacePreview(
                      onTap: onPlacePressed,
                      place: feed.places![index],
                      model: model,
                    ),
              separatorBuilder: (_, i) => SpacingFoundation.verticalSpace24,
              itemCount: feed.places!.length + 1)
          // ...
          // feed.places!.map((e) => PlacePreview(
          //       onTap: onPlacePressed,
          //       place: e,
          //       model: model,
          //     )
          // feed.mixedItems
          //     ?.map((e) => e.
          //     .paddingSymmetric(
          //         vertical: SpacingFoundation.verticalSpacing12)),
          //     .toList(),
          // ,
          // ],
        ]).paddingSymmetric(
      vertical: (model.positionModel?.verticalMargin ?? 0).toDouble(),
    );
  }
}
