import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class FeedComponent extends StatelessWidget {
  final UiFeedModel feed;
  final PagingController controller;
  final UiMoodModel? mood;
  final ValueNotifier<FeedOpenedState>? feedOpenedState;
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
  final ValueChanged<int?>? onNichePressed;
  final bool hasFavourites;
  final bool canShowVideoReactions;
  final ValueNotifier<double> subscribedUsersFeedIconScaleNotifier;
  final List<UiProfileModel> subscribedProfiles;
  final ValueChanged<int>? onSubscribedUserTapped;
  final ValueChanged<double>? subscribedProfilesHintNotifier;
  final ValueNotifier<double>? tiltNotifier;
  final ScrollController? scrollController;
  final bool showHints;
  final VoidCallback? onMyActionTap;
  final VoidCallback? onCommonActionTap;
  final int? myCount;
  final int? commonCount;

  const FeedComponent({
    super.key,
    required this.feed,
    required this.controller,
    required this.showBusinessContent,
    this.canShowVideoReactions = false,
    this.storiesPagingController,
    this.onReactionTapped,
    this.feedOpenedState,
    this.hasFavourites = false,
    this.mood,
    this.onNichePressed,
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
    required this.subscribedUsersFeedIconScaleNotifier,
    this.subscribedProfiles = const [],
    this.onSubscribedUserTapped,
    this.subscribedProfilesHintNotifier,
    this.tiltNotifier,
    this.scrollController,
    this.showHints = true,
    this.onCommonActionTap,
    this.onMyActionTap,
    this.myCount,
    this.commonCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentFeedModel feedLeisureModel = ComponentFeedModel.fromJson(config['feed']);
    final ComponentFeedModel feedBusinessModel = ComponentFeedModel.fromJson(config['feed_business']);
    MapEntry<String, PropertiesBaseModel>? advertisement;
    if (feedLeisureModel.content.body?[ContentItemType.advertisement]?.properties?.isNotEmpty ?? false) {
      advertisement = feedLeisureModel.content.body?[ContentItemType.advertisement]?.properties?.entries.first;
    }
    final horizontalMargin = (feedBusinessModel.positionModel?.horizontalMargin ?? 0).toDouble();

    final themeTitleStyle = theme?.boldTextTheme.title1;
    final isLightTheme = theme?.themeMode == ThemeMode.light;
    const appeareDuration = Duration(milliseconds: 250);

    final size = MediaQuery.sizeOf(context);

    late final String feelingText;
    final now = DateTime.now();
    if (now.hour >= 12 && now.hour < 18) {
      feelingText = S.of(context).HowAreYouFeelingToday;
    } else if (now.hour >= 4 && now.hour < 12) {
      feelingText = S.of(context).HowAreYouFeelingThisMorning;
    } else {
      feelingText = S.of(context).HowAreYouFeelingTonight;
    }

    return AnimatedBuilder(
        animation: feedOpenedState ?? ValueNotifier(FeedOpenedState.initial),
        builder: (ctx, _) => CustomScrollView(
              physics: const BouncingScrollPhysics(),
              controller: scrollController,
              slivers: [
                if (feedOpenedState!.value == FeedOpenedState.initial && !showHints)
                  MediaQuery.viewPaddingOf(context).top.heightBox.wrapSliverBox
                else if (feedOpenedState!.value == FeedOpenedState.initial)
                  UiKitAnimatedPullToShowHint(
                    scaleNotifier: subscribedUsersFeedIconScaleNotifier,
                    topPadding: MediaQuery.viewPaddingOf(context).top,
                  ).wrapSliverBox,
                // MediaQuery.viewPaddingOf(context).top.heightBox.wrapSliverBox,
                if (feedOpenedState!.value != FeedOpenedState.initial)
                  SliverPersistentHeader(
                    delegate: UiKitAnimatedPullToShowDelegate(
                      lastPhaseScaleNotifier: feedOpenedState!.value == FeedOpenedState.avaliableForOpeningFeed
                          ? subscribedUsersFeedIconScaleNotifier
                          : ValueNotifier(0.0),
                      topPadding: MediaQuery.viewPaddingOf(context).top,
                      children: (subscribedProfiles.isEmpty ? null : subscribedProfiles)
                              ?.map(
                                (profile) => GestureDetector(
                                  onTap: () {
                                    if (profile.id != null) onSubscribedUserTapped?.call(profile.id!);
                                  },
                                  child: context.userAvatar(
                                    size: UserAvatarSize.x40x40,
                                    type: profile.userTileType,
                                    userName: profile.nickname ?? '',
                                    imageUrl: profile.avatarUrl,
                                    badgeValue: profile.updatesCount,
                                  ),
                                ),
                              )
                              .toList() ??
                          [
                            // Opacity(
                            //     opacity: 0.5,
                            //     child: context.userAvatar(
                            //       size: UserAvatarSize.x40x40,
                            //       type: UserTileType.influencer,
                            //       userName: 'F L',
                            //     )),
                            SizedBox(
                                width: 0.9.sw,
                                child: GradientableWidget(
                                    gradient: GradientFoundation.attentionCard,
                                    child: AutoSizeText(
                                      S.current.DontLiveAlone,
                                      maxLines: 2,
                                      style: theme?.boldTextTheme.caption1Medium.copyWith(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    )).paddingOnly(top: 8))
                          ],
                    ),
                  ),
                if (showBusinessContent) ...[
                  if (feed.recommendedBusinessEvents != null && feed.recommendedBusinessEvents!.isNotEmpty) ...[
                    Text(
                      S.current.UpcomingGlobalEvents,
                      style: themeTitleStyle,
                    ).paddingSymmetric(horizontal: horizontalMargin).wrapSliverBox,
                    SpacingFoundation.verticalSpace16.wrapSliverBox,
                    UiKitTiltWrapper(
                      tiltNotifier: tiltNotifier,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: feed.recommendedBusinessEvents
                                  ?.map<Widget>(
                                    (e) => UiKitImageWithDescriptionCard(
                                      onTap: () => onListItemPressed?.call(e.id, 'event'),
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
                      ),
                    ).wrapSliverBox,
                    SpacingFoundation.verticalSpace24.wrapSliverBox
                  ],
                  if ((feedBusinessModel.showFeelings ?? true)) ...[
                    TitleWithHowItWorks(
                      title: S.of(context).YourNiche,
                      textStyle: themeTitleStyle,
                      shouldShow: feed.showHowItWorksTitle,
                      howItWorksWidget: HowItWorksWidget(
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
                      ),
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
                              if (e.title == feed.niches?.first.title) {
                                padding = horizontalMargin;
                              }

                              return UiKitMessageCardWithIcon(
                                message: e.title,
                                iconLink: e.icon is String ? e.icon as String : '',
                                layoutDirection: Axis.vertical,
                                type: MessageCardType.wide,
                                onPressed: () => onNichePressed?.call(e.id),
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
                  if (feedLeisureModel.showDailyRecomendation ?? true) ...[
                    AnimatedSize(
                            alignment: Alignment.topCenter,
                            duration: appeareDuration,
                            child: feed.recommendedEvent != null
                                ? UiKitTiltWrapper(
                                    tiltNotifier: tiltNotifier,
                                    child: UiKitAccentCard(
                                      onPressed: onEventPressed == null
                                          ? null
                                          : () => onEventPressed!(feed.recommendedEvent?.id),
                                      title: feed.recommendedEvent!.title ?? '',
                                      additionalInfo: feed.recommendedEvent!.descriptionItems?.first.description ?? '',
                                      accentMessage: S.of(context).DontMissIt,
                                      image: ImageWidget(
                                        link: feed.recommendedEvent?.media.firstOrNull?.link,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        errorWidget: const UiKitBigPhotoErrorWidget(),
                                      ),
                                    ).paddingSymmetric(horizontal: horizontalMargin),
                                  )
                                : const SizedBox.shrink())
                        .wrapSliverBox,
                    SpacingFoundation.verticalSpace24.wrapSliverBox,
                  ],
                  AnimatedSize(
                      alignment: Alignment.topCenter,
                      duration: const Duration(milliseconds: 300),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (storiesPagingController != null && canShowVideoReactions) ...[
                              Text(S.current.YouMissedALot, style: themeTitleStyle)
                                  .paddingSymmetric(horizontal: horizontalMargin),
                              SpacingFoundation.verticalSpace16,
                              UiKitTiltWrapper(
                                tiltNotifier: feed.recommendedEvent == null ? tiltNotifier : null,
                                child: SizedBox(
                                  height: 0.285.sw * 1.7,
                                  width: 1.sw,
                                  child: PagedListView<int, VideoReactionUiModel>.separated(
                                    scrollDirection: Axis.horizontal,
                                    builderDelegate: PagedChildBuilderDelegate(
                                      firstPageProgressIndicatorBuilder: (c) => Align(
                                        alignment: Alignment.centerLeft,
                                        child: UiKitShimmerProgressIndicator(
                                          gradient: GradientFoundation.greyGradient,
                                          child: UiKitReactionPreview(
                                            customHeight: 0.285.sw * 1.7,
                                            customWidth: 0.285.sw,
                                            imagePath: GraphicsFoundation.instance.png.place.path,
                                          ).paddingOnly(left: horizontalMargin),
                                        ),
                                      ),
                                      newPageProgressIndicatorBuilder: (c) => Align(
                                        alignment: Alignment.centerLeft,
                                        child: UiKitShimmerProgressIndicator(
                                          gradient: GradientFoundation.greyGradient,
                                          child: UiKitReactionPreview(
                                            customHeight: 0.285.sw * 1.7,
                                            customWidth: 0.285.sw,
                                            imagePath: GraphicsFoundation.instance.png.place.path,
                                          ),
                                        ),
                                      ),
                                      itemBuilder: (_, item, index) {
                                        double leftPadding = 0;
                                        if (index == 0) leftPadding = horizontalMargin;

                                        return UiKitReactionPreview(
                                          customHeight: 0.285.sw * 1.7,
                                          customWidth: 0.285.sw,
                                          imagePath: item.previewImageUrl ?? '',
                                          viewed: item.isViewed,
                                          onTap: () => onReactionTapped?.call(item),
                                        ).paddingOnly(left: leftPadding);
                                      },
                                    ),
                                    separatorBuilder: (_, i) => SpacingFoundation.horizontalSpace12,
                                    pagingController: storiesPagingController!,
                                  ),
                                ),
                              ),
                              SpacingFoundation.verticalSpace16,
                            ]
                          ])).wrapSliverBox,
                  if ((feedLeisureModel.showFeelings ?? true)) ...[
                    TitleWithHowItWorks(
                      title: feelingText,
                      textStyle: themeTitleStyle,
                      shouldShow: feed.showHowItWorksTitle,
                      howItWorksWidget: HowItWorksWidget(
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
                      onPressedShouldRecall: feed.shouldRecallOnMoodTap,
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
                if ((commonCount != null && commonCount != 0) || (myCount != null && myCount != 0))
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.current.WheresTheActivity,
                          style: themeTitleStyle,
                        ),
                        SpacingFoundation.verticalSpace16,
                        if (myCount == null || myCount == 0)
                          BigActivityFeedWidget(
                            onTap: onCommonActionTap,
                            commonCount: commonCount,
                          )
                        else
                          SmallActivityFeedWidget(
                            onMyActionTap: onMyActionTap,
                            onCommonActionTap: onCommonActionTap,
                            myCount: myCount,
                            commonCount: commonCount,
                          ),
                      ],
                    ),
                  )
                      .paddingSymmetric(horizontal: horizontalMargin, vertical: SpacingFoundation.verticalSpacing24)
                      .wrapSliverBox,

                if ((feedLeisureModel.showPlaces ?? true)) ...[
                  TitleWithHowItWorks(
                    title: S.of(context).YouBetterCheckThisOut,
                    textStyle: themeTitleStyle,
                    shouldShow: feed.showHowItWorksBody,
                    howItWorksWidget: HowItWorksWidget(
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
                  ).paddingSymmetric(horizontal: horizontalMargin).wrapSliverBox,
                  if (feed.filterChips != null && feed.filterChips!.isNotEmpty) ...[
                    SpacingFoundation.verticalSpace8.wrapSliverBox,
                    NotificationListener(
                        onNotification: (notification) {
                          if (notification is ScrollUpdateNotification) {
                            if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
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
                                cacheExtent: 0.0,
                                scrollDirection: Axis.horizontal,
                                itemCount: feed.filterChips!.length + 1 + (hasFavourites ? 1 : 0),
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
                                    if (hasFavourites) {
                                      return UiKitTitledFilterChip(
                                        //const flag for showing favorites is 'Favorites'
                                        selected:
                                            feed.activeFilterChips?.map((e) => e.title).contains('Favorites') ?? false,
                                        title: S.of(context).Favorites,
                                        onPressed:
                                            onTagSortPressed == null ? null : () => onTagSortPressed!('Favorites'),
                                        icon: ShuffleUiKitIcons.starfill,
                                      ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing8);
                                    } else {
                                      return SpacingFoundation.horizontalSpace8;
                                    }
                                  } else {
                                    return feed.filterChips!
                                        .map((e) => UiKitTitledFilterChip(
                                              selected: feed.activeFilterChips?.map((e) => e.title).contains(e.title) ??
                                                  false,
                                              title: e.title,
                                              onPressed:
                                                  onTagSortPressed == null ? null : () => onTagSortPressed!(e.title),
                                              icon: e.icon,
                                            ).paddingOnly(right: horizontalMargin))
                                        .toList()[index - 2];
                                  }
                                }))).wrapSliverBox,
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
                          if (item.bannerType == AdvertisementBannerType.text) {
                            return item.smallTextBanner.paddingSymmetric(horizontal: horizontalMargin);
                          } else {
                            return context
                                .advertisementImageBanner(
                                  data: BaseUiKitAdvertisementImageBannerData(
                                    availableWidth: 1.sw - (horizontalMargin * 2),
                                    onPressed: onAdvertisementPressed,
                                    imageLink: item.smallBannerImage,
                                    title: advertisement.key,
                                    size: AdvertisementBannerSize.values.byName(
                                      advertisement.value.type ?? S.of(context).Small.toLowerCase(),
                                    ),
                                  ),
                                )
                                .paddingSymmetric(horizontal: horizontalMargin);
                          }
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
                  if (preserveScrollPosition) SizedBox(height: 0.8.sh - kBottomNavigationBarHeight).wrapSliverBox,
                  kBottomNavigationBarHeight.heightBox.wrapSliverBox
                ],
              ],
            ).paddingSymmetric(
              vertical: (feedLeisureModel.positionModel?.verticalMargin ?? 0).toDouble(),
            ));
  }
}

enum FeedModule { subscriptions, global, reactions, feeling, feed }

enum FeedOpenedState { initial, showUsers, avaliableForOpeningFeed }
