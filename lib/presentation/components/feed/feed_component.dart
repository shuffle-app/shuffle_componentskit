import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:collection/collection.dart';

class FeedComponent extends StatelessWidget {
  final UiFeedModel feed;
  final PagingController controller;
  final UiMoodModel? mood;
  final Function? onEventPressed;
  final Function(int id, String type)? onListItemPressed;
  final Function? onTagSortPressed;
  final VoidCallback? onHowItWorksPoped;
  final VoidCallback? onMoodPressed;
  final VoidCallback? onMoodCheck;
  final AsyncCallback? onMoodCompleted;
  final VoidCallback? onHowItWorksPopedBody;
  final VoidCallback? onAdvertisementPressed;
  final VoidCallback? onLoadMoreChips;
  final bool showBusinessContent;
  final bool preserveScrollPosition;
  final Widget? progressIndicator;
  final ValueChanged<VideoReactionUiModel>? onReactionTapped;
  final PagingController<int, VideoReactionUiModel>? storiesPagingController;

  const FeedComponent({
    Key? key,
    required this.feed,
    required this.controller,
    required this.showBusinessContent,
    this.storiesPagingController,
    this.onReactionTapped,
    this.mood,
    this.progressIndicator,
    this.preserveScrollPosition = false,
    this.onEventPressed,
    this.onMoodPressed,
    this.onMoodCheck,
    this.onMoodCompleted,
    this.onTagSortPressed,
    this.onHowItWorksPoped,
    this.onHowItWorksPopedBody,
    this.onListItemPressed,
    this.onAdvertisementPressed,
    this.onLoadMoreChips,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentFeedModel feedLeisureModel = ComponentFeedModel.fromJson(config['feed']);
    final ComponentFeedModel feedBusinessModel = ComponentFeedModel.fromJson(config['feed_business']);
    MapEntry<String, PropertiesBaseModel>? advertisement;
    if (feedLeisureModel.content.body?[ContentItemType.advertisement]?.properties?.isNotEmpty ?? false) {
      advertisement = feedLeisureModel.content.body?[ContentItemType.advertisement]?.properties?.entries.first;
    }

    // final nicheTitles = feedBusinessModel.content.body?[ContentItemType.horizontalList]?.properties?.keys.toList();
    // final nicheData = feedBusinessModel.content.body?[ContentItemType.horizontalList]?.properties;
    // final upcomingGlobals = feedBusinessModel
    //     .content.body?[ContentItemType.horizontalList]?.title?[ContentItemType.horizontalList]?.properties;
    // nicheTitles?.sort((a, b) {
    //   final aSortNumber = nicheData?[a]?.sortNumber ?? 0;
    //   final bSortNumber = nicheData?[b]?.sortNumber ?? 0;
    //
    //   return aSortNumber.compareTo(bSortNumber);
    // });
    final horizontalMargin = (feedBusinessModel.positionModel?.horizontalMargin ?? 0).toDouble();

    final themeTitleStyle = context.uiKitTheme?.boldTextTheme.title1;
    final isLightTheme = context.uiKitTheme?.themeMode == ThemeMode.light;

    final size = MediaQuery.sizeOf(context);

    late final String feelingText;
    final now = DateTime.now();
    if (now.hour >= 12 && now.hour < 18) {
      feelingText = S.of(context).HowAreYouFeelingToday;
    } else if (now.hour >= 6 && now.hour < 12) {
      feelingText = S.of(context).HowAreYouFeelingThisMorning;
    } else {
      feelingText = S.of(context).HowAreYouFeelingTonight;
    }

    return CustomScrollView(
      slivers: [
        SizedBox(
          height: MediaQuery.viewPaddingOf(context).top,
        ).wrapSliverBox,
        if (showBusinessContent) ...[
          if (feed.recommendedBusinessEvents != null && feed.recommendedBusinessEvents!.isNotEmpty) ...[
            Text(
              S.current.UpcomingGlobalEvents,
              style: themeTitleStyle,
            ).paddingSymmetric(horizontal: horizontalMargin).wrapSliverBox,
            SpacingFoundation.verticalSpace16.wrapSliverBox,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: feed.recommendedBusinessEvents
                        ?.map<Widget>(
                          (e) => UiKitImageWithDescriptionCard(
                            title: e.title ?? '',
                            imageUrl: e.verticalPreview?.link ??
                                e.media.firstWhereOrNull((e) => e.type == UiKitMediaType.image)?.link ??
                                '',
                            subtitleIcon: ShuffleUiKitIcons.clock,
                            subtitle: e.scheduleString,
                            tags: e.tags,
                          ).paddingOnly(
                              right: e.id == feed.recommendedBusinessEvents?.last.id
                                  ? 0
                                  : SpacingFoundation.horizontalSpacing12),
                        )
                        .toList() ??
                    [],
              ).paddingSymmetric(horizontal: horizontalMargin),
            ).wrapSliverBox,
            SpacingFoundation.verticalSpace24.wrapSliverBox
          ],
          if ((feedBusinessModel.showFeelings ?? true)) ...[
            Stack(
              children: [
                Text(S.of(context).YourNiche, style: themeTitleStyle),
                if (feed.showHowItWorksTitle)
                  HowItWorksWidget(
                    title: S.current.FeedNichesHiwTitle,
                    subtitle: S.current.FeedNichesHiwSubtitle,
                    hintTiles: [
                      HintCardUiModel(
                        imageUrl: GraphicsFoundation.instance.png.selectNiche.path,
                        title: S.current.FeedNichesHiwItems(0),
                      ),
                      HintCardUiModel(
                        imageUrl: GraphicsFoundation.instance.png.pressNiche.path,
                        title: S.current.FeedNichesHiwItems(1),
                      ),
                      HintCardUiModel(
                        imageUrl: GraphicsFoundation.instance.png.getSelection.path,
                        title: S.current.FeedNichesHiwItems(2),
                      ),
                      HintCardUiModel(
                        imageUrl: GraphicsFoundation.instance.png.choosePlan.path,
                        title: S.current.FeedNichesHiwItems(3),
                      ),
                    ],
                    onPop: onHowItWorksPoped,
                    customOffset: Offset(1.sw / 1.7, 0),
                  ),
              ],
            ).paddingSymmetric(horizontal: horizontalMargin).wrapSliverBox,
          ],
          SpacingFoundation.verticalSpace16.wrapSliverBox,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              spacing: SpacingFoundation.horizontalSpacing12,
              children: feed.niches?.map<Widget>(
                    (e) {
                      double padding = 0.0;
                      if (e.title == feed.niches?.first.title) padding = horizontalMargin;

                      return UiKitMessageCardWithIcon(
                        message: e.title,
                        iconLink: e.icon is String ? e.icon as String : '',
                        layoutDirection: Axis.vertical,
                        type: MessageCardType.wide,
                      ).paddingOnly(left: padding);
                    },
                  ).toList() ??
                  [],
            ),
          ).wrapSliverBox,
          SpacingFoundation.verticalSpace24.wrapSliverBox,
        ],
        if (!showBusinessContent) ...[
          SpacingFoundation.verticalSpace16.wrapSliverBox,
          if (feed.recommendedEvent != null && (feedLeisureModel.showDailyRecomendation ?? true)) ...[
            UiKitAccentCard(
              onPressed: onEventPressed == null ? null : () => onEventPressed!(feed.recommendedEvent?.id),
              title: feed.recommendedEvent!.title ?? '',
              additionalInfo: feed.recommendedEvent!.descriptionItems?.first.description ?? '',
              accentMessage: S.of(context).DontMissIt,
              image: ImageWidget(
                link: feed.recommendedEvent?.media.firstOrNull?.link,
                fit: BoxFit.cover,
                width: double.infinity,
                errorWidget: const UiKitBigPhotoErrorWidget(),
              ),
            ).paddingSymmetric(horizontal: horizontalMargin).wrapSliverBox,
            SpacingFoundation.verticalSpace24.wrapSliverBox,
          ],
          if (storiesPagingController != null) ...[
            Text(S.current.YouMissedALot, style: themeTitleStyle).paddingSymmetric(horizontal: horizontalMargin).wrapSliverBox,
            SpacingFoundation.verticalSpace16.wrapSliverBox,
            SizedBox(
              height: 0.26.sh,
              child: PagedListView<int, VideoReactionUiModel>.separated(
                scrollDirection: Axis.horizontal,
                builderDelegate: PagedChildBuilderDelegate(
                  firstPageProgressIndicatorBuilder: (c) => progressIndicator ?? const SizedBox.shrink(),
                  newPageProgressIndicatorBuilder: (c) => progressIndicator ?? const SizedBox.shrink(),
                  itemBuilder: (_, item, index) {
                    double leftPadding = 0;
                    if (index == 0) leftPadding = horizontalMargin;

                    return UiKitReactionPreview(
                      imagePath: item.previewImageUrl ?? '',
                      viewed: false,
                      onTap: () => onReactionTapped?.call(item),
                    ).paddingOnly(left: leftPadding);
                  },
                ),
                itemExtent: 147.h,
                separatorBuilder: (_, i) => SpacingFoundation.horizontalSpace12,
                pagingController: storiesPagingController!,
              ),
            ).wrapSliverBox,
            SpacingFoundation.verticalSpace16.wrapSliverBox,
          ],
          if ((feedLeisureModel.showFeelings ?? true)) ...[
            Stack(
              children: [
                Text(feelingText, style: themeTitleStyle),
                if (feed.showHowItWorksTitle)
                  HowItWorksWidget(
                    title: S.current.FeedFeelingsHiwTitle,
                    subtitle: S.current.FeedFeelingsHiwSubtitle,
                    hintTiles: [
                      HintCardUiModel(
                        imageUrl: GraphicsFoundation.instance.png.map.path,
                        title: S.current.FeedFeelingsHiwItems(0),
                      ),
                      HintCardUiModel(
                        imageUrl: GraphicsFoundation.instance.png.dart.path,
                        title: S.current.FeedFeelingsHiwItems(1),
                      ),
                      HintCardUiModel(
                        imageUrl: GraphicsFoundation.instance.png.sunClouds.path,
                        title: S.current.FeedFeelingsHiwItems(2),
                      ),
                      HintCardUiModel(
                        imageUrl: GraphicsFoundation.instance.png.smileMood.path,
                        title: S.current.FeedFeelingsHiwItems(3),
                      ),
                    ],
                    onPop: onHowItWorksPoped,
                  ),
              ],
            ).paddingSymmetric(horizontal: horizontalMargin).wrapSliverBox,
            SpacingFoundation.verticalSpace16.wrapSliverBox,
            FingerprintSwitch(
              height: (size.width - horizontalMargin * 2) * 0.54,
              isHealthKitEnabled: feed.isHealthKitEnabled,
              title: Text(
                S.of(context).Guess,
                style: context.uiKitTheme?.boldTextTheme.subHeadline.copyWith(color: Colors.white),
              ),
              backgroundImage: ImageWidget(
                width: double.infinity,
                svgAsset: GraphicsFoundation.instance.svg.dubaiSilhouette,
                fit: BoxFit.fitWidth,
                color: context.uiKitTheme?.colorScheme.surface1,
              ),
              animationPath: isLightTheme
                  ? GraphicsFoundation.instance.animations.lottie.fingerprintWhite.path
                  : GraphicsFoundation.instance.animations.lottie.fingerprintBlack.path,
              isCompleted: mood != null,
              onCompleted: onMoodCompleted,
              onPressed: onMoodCheck,
              onCompletedWidget: mood != null
                  ? UiKitMessageCardWithIcon(
                      message: mood!.title,
                      iconLink: mood!.logo,
                      layoutDirection: Axis.vertical,
                      onPressed: onMoodPressed == null ? null : () => onMoodPressed!(),
                    )
                  : const SizedBox.shrink(),
            ).paddingSymmetric(horizontal: horizontalMargin).wrapSliverBox,
            SpacingFoundation.verticalSpace24.wrapSliverBox,
          ],
        ],
        if ((feedLeisureModel.showPlaces ?? true)) ...[
          Stack(
            children: [
              Text(
                S.of(context).YouBetterCheckThisOut,
                style: themeTitleStyle,
                textAlign: TextAlign.left,
              ),
              if (feed.showHowItWorksBody)
                HowItWorksWidget(
                  title: S.current.FeedRandomizerHiwTitle,
                  subtitle: S.current.FeedRandomizerHiwSubtitle,
                  hintTiles: [
                    HintCardUiModel(
                      imageUrl: GraphicsFoundation.instance.png.events.path,
                      title: S.current.FeedRandomizerHiwItems(0),
                    ),
                    HintCardUiModel(
                      imageUrl: GraphicsFoundation.instance.png.filtering.path,
                      title: S.current.FeedRandomizerHiwItems(1),
                    ),
                    HintCardUiModel(
                      imageUrl: GraphicsFoundation.instance.png.chipsSelect.path,
                      title: S.current.FeedRandomizerHiwItems(2),
                    ),
                    HintCardUiModel(
                      imageUrl: GraphicsFoundation.instance.png.pressScroll.path,
                      title: S.current.FeedRandomizerHiwItems(3),
                    ),
                  ],
                  onPop: onHowItWorksPopedBody,
                ),
            ],
          ).paddingSymmetric(horizontal: horizontalMargin).wrapSliverBox,
          if (feed.filterChips != null && feed.filterChips!.isNotEmpty) ...[
            SpacingFoundation.verticalSpace8.wrapSliverBox,
            NotificationListener(
                onNotification: (notification) {
                  if (notification is ScrollUpdateNotification) {
                    if (notification.metrics.pixels >= notification.metrics.maxScrollExtent * 0.8) {
                      onLoadMoreChips?.call();
                    }
                  }
                  return false;
                },
                child: ConstrainedBox(
                    constraints: BoxConstraints.loose(Size(double.infinity, 40.h)),
                    child: ListView.builder(
                        padding: EdgeInsets.only(left: horizontalMargin),
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: feed.filterChips!.length + 2,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return RollingDiceButton(
                                onPressed: (value) {
                                  final Set<String> list = {};
                                  for (int i in value) {
                                    list.add(feed.filterChips![i].title);
                                  }

                                  onTagSortPressed?.call('Random', list);
                                },
                                length: feed.filterChips?.length ?? 0);
                          } else if (index == 1) {
                            return UiKitTitledFilterChip(
                              //const flag for showing favorites is 'Favorites'
                              selected: feed.activeFilterChips?.map((e) => e.title).contains('Favorites') ?? false,
                              title: S.of(context).Favorites,
                              onPressed: onTagSortPressed == null ? null : () => onTagSortPressed!('Favorites'),
                              icon: ShuffleUiKitIcons.starfill,
                            ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing8);
                          } else {
                            return feed.filterChips!
                                .map((e) => UiKitTitledFilterChip(
                                      selected: feed.activeFilterChips?.map((e) => e.title).contains(e.title) ?? false,
                                      title: e.title,
                                      onPressed: onTagSortPressed == null ? null : () => onTagSortPressed!(e.title),
                                      icon: e.icon,
                                    ).paddingOnly(right: horizontalMargin))
                                .toList()[index - 2];
                          }
                        }
                        // child: Row(
                        //   children: [
                        //     RollingDiceButton(
                        //         onPressed: (value) {
                        //           final Set<String> list = {};
                        //           for (int i in value) {
                        //             list.add(feed.filterChips![i].title);
                        //           }
                        //
                        //           onTagSortPressed?.call('Random', list);
                        //         },
                        //         length: feed.filterChips?.length ?? 0),
                        //     UiKitTitledFilterChip(
                        //       //const flag for showing favorites is 'Favorites'
                        //       selected: feed.activeFilterChips?.map((e) => e.title).contains('Favorites') ?? false,
                        //       title: S.of(context).Favorites,
                        //       onPressed: onTagSortPressed == null ? null : () => onTagSortPressed!('Favorites'),
                        //       icon: ShuffleUiKitIcons.starfill,
                        //     ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing8),
                        //     Wrap(
                        //       spacing: SpacingFoundation.verticalSpacing8,
                        //       children: feed.filterChips!.map(
                        //         (e) {
                        //           double padding = 0;
                        //           if (e == feed.filterChips?.last) padding = horizontalMargin;
                        //
                        //           return UiKitTitledFilterChip(
                        //             selected: feed.activeFilterChips?.map((e) => e.title).contains(e.title) ?? false,
                        //             title: e.title,
                        //             onPressed: onTagSortPressed == null ? null : () => onTagSortPressed!(e.title),
                        //             icon: e.icon,
                        //           ).paddingOnly(right: padding);
                        //         },
                        //       ).toList(),
                        //     ),
                        //   ],
                        // ).paddingOnly(left: horizontalMargin),
                        ))).wrapSliverBox,
          ],
          SpacingFoundation.verticalSpace24.wrapSliverBox,
          PagedSliverList.separated(
            shrinkWrapFirstPageIndicators: true,
            builderDelegate: PagedChildBuilderDelegate(
              animateTransitions: true,
              firstPageProgressIndicatorBuilder: (c) => progressIndicator ?? const SizedBox.shrink(),
              newPageProgressIndicatorBuilder: (c) => progressIndicator ?? const SizedBox.shrink(),
              itemBuilder: (_, item, index) {
                item as UiUniversalModel;
                if (item.isAdvertisement && advertisement != null) {
                  return context
                      .advertisementBanner(
                        data: BaseUiKitAdvertisementBannerData(
                          availableWidth: 1.sw - (horizontalMargin * 2),
                          onPressed: onAdvertisementPressed,
                          imageLink: item.bannerPicture,
                          title: advertisement.key,
                          size: AdvertisementBannerSize.values.byName(
                            advertisement.value.type ?? S.of(context).Small.toLowerCase(),
                          ),
                        ),
                      )
                      .paddingSymmetric(horizontal: horizontalMargin);
                }

                return PlacePreview(
                  // showFavoriteHint: index==0,
                  isFavorite: item.isFavorite,
                  onFavoriteChanged: item.onFavoriteChanged,
                  onTap: (id) => onListItemPressed?.call(id, item.type),
                  place: UiPlaceModel(
                    id: item.id,
                    title: item.title,
                    description: item.description,
                    media: item.media,
                    tags: item.tags,
                    baseTags: item.baseTags ?? [],
                  ),
                  model: feedLeisureModel,
                );
              },
            ),
            itemExtent: 200.h,
            separatorBuilder: (_, i) => SpacingFoundation.verticalSpace24,
            pagingController: controller,
          ),
          if (preserveScrollPosition) SizedBox(height: 0.8.sh).wrapSliverBox,
        ],
      ],
    ).paddingSymmetric(
      vertical: (feedLeisureModel.positionModel?.verticalMargin ?? 0).toDouble(),
    );
  }
}
