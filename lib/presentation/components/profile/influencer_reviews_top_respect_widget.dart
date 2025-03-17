import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shuffle_components_kit/domain/config_models/profile/component_profile_model.dart';
import 'package:shuffle_components_kit/domain/data_uimodels/influencer_models/influencer_feed_item.dart';
import 'package:shuffle_components_kit/domain/data_uimodels/video_reaction_ui_model.dart';
import 'package:shuffle_components_kit/presentation/components/profile/public_profile/widget/influencer_reviews_tab.dart';
import 'package:shuffle_components_kit/presentation/components/voice_component/audio_player.dart';
import 'package:shuffle_components_kit/presentation/widgets/global_component.dart';
import 'package:shuffle_components_kit/services/configuration/global_configuration.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:collection/src/iterable_extensions.dart';

import '../voice_component/voice_ui_model.dart';

class InfluencerReviewsTopRespectWidget extends StatefulWidget {
  final List<InfluencerPhotoUiModel>? influencerPhotos;
  final List<VoiceUiModel>? voices;
  final List<PostFeedItem>? influencerTweets;
  final ValueNotifier<double>? tiltNotifier;
  final PagingController<int, VideoReactionUiModel>? storiesPagingController;
  final List<ProfilePlace>? profilePlaces;
  final ValueChanged<VideoReactionUiModel>? onReactionTapped;
  final List<InfluencerTopCategory>? influencerTopCategories;
  final List<ContentPreviewWithRespect>? contentPreviewWithRespects;
  final Function(int? placeId, int? eventId)? onItemTap;
  final Future<void> Function(int)? onShowMoreTap;
  final bool isLoading;
  final bool isPublic;

  const InfluencerReviewsTopRespectWidget({
    super.key,
    this.influencerTweets,
    this.influencerPhotos,
    this.voices,
    this.tiltNotifier,
    this.storiesPagingController,
    this.profilePlaces,
    this.onReactionTapped,
    this.influencerTopCategories,
    this.contentPreviewWithRespects,
    this.onItemTap,
    this.isLoading = false,
    this.onShowMoreTap,
    this.isPublic = false,
  });

  bool get hasVoices => voices?.any((e) => e.source != null) ?? false;

  @override
  State<InfluencerReviewsTopRespectWidget> createState() => _InfluencerReviewsTopRespectWidgetState();
}

class _InfluencerReviewsTopRespectWidgetState extends State<InfluencerReviewsTopRespectWidget>
    with TickerProviderStateMixin {
  //TODO length
  late TabController specialTabsController = TabController(length: widget.isPublic ? 2 : 3, vsync: this);
  late TabController activityTabsController = TabController(length: 3, vsync: this);
  late double specialTabsHeight = 2 * (bigScreen ? 0.265.sh : 0.325.sh);
  double _activityTabsContentHeight = 6 * 0.26.sh;
  int voiceBadgeCount = 0;
  int photoBadgeCount = 0;
  int idealRouteBadgeCount = 1;
  int interviewBadgeCount = 4;
  int chatBadgeCount = 90;
  int nftBadgeCount = 2;
  int contestBadgeCount = 999;
  int videoBadgeCount = 0;
  final activityTabsSizeGroup = AutoSizeGroup();
  final statsSizeGroup = AutoSizeGroup();
  final tabsKey = GlobalKey();
  final specialTabsKey = GlobalKey();
  final ScrollController scrollController = ScrollController();
  final ScrollController specialScrollController = ScrollController();

  AudioPlayerState? _currentPlayer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      specialTabsController.addListener(_specialTabsListener);
      activityTabsController.addListener(_activityTabsListener);
      setSpecialTabsContentHeight(0);
      _setActivityTabsContentHeight(0);
    });
  }

  void _handlePlayback(AudioPlayerState newPlayer) {
    _currentPlayer?.pause();
    _currentPlayer = newPlayer;
  }

  void _setActivityTabsContentHeight(int index) {
    if (index == 0) {
      _activityTabsContentHeight = ((widget.profilePlaces != null && widget.profilePlaces!.isNotEmpty) ? 6 : 2) *
          (bigScreen
              ? 0.2.sh
              : midScreen
                  ? 0.21.sh
                  : 0.24.sh);
    } else if (index == 1) {
      _activityTabsContentHeight =
          (widget.influencerTopCategories?.length ?? 1) * (bigScreen || midScreen ? 0.3.sh : 0.3575.sh);
    } else if (index == 2) {
      _activityTabsContentHeight = (widget.contentPreviewWithRespects?.length ?? 2) *
          (bigScreen
              ? 0.43.sh
              : midScreen
                  ? 0.45.sh
                  : 0.55.sh);
    }
    setState(() {});
  }

  Future<void> _animateToSpecialTabPosition(int index) async {
    final double offset = index * (widget.isPublic ? 50.0 : 100.0);
    unawaited(specialScrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _animateToTabPosition() async {
    if (mounted && tabsKey.currentContext != null) {
      await Scrollable.ensureVisible(
        tabsKey.currentContext!,
        duration: const Duration(milliseconds: 250),
        curve: Curves.decelerate,
      );
    }
  }

  void _activityTabsListener() {
    final tabIndex = activityTabsController.index;
    _setActivityTabsContentHeight(tabIndex);
    _animateToTabPosition();
  }

  void _specialTabsListener() {
    final tabIndex = specialTabsController.index;
    setSpecialTabsContentHeight(tabIndex);
    _animateToSpecialTabPosition(tabIndex);
  }

  bool get bigScreen => 1.sw > 415;

  bool get midScreen => 1.sw > 380;

  void setSpecialTabsContentHeight(int index) {
    if (index == 0) {
      specialTabsHeight = widget.voices != null && widget.voices!.isNotEmpty
          ? bigScreen
              ? 0.53.sh
              : midScreen
                  ? 0.56.sh
                  : 0.59.sh
          : widget.voices != null && widget.voices!.length == 1
              ? bigScreen
                  ? 0.27.sh
                  : midScreen
                      ? 0.28.sh
                      : 0.30.sh
              : bigScreen
                  ? 0.105.sh
                  : midScreen
                      ? 0.13.sh
                      : 0.19.sh;
      voiceBadgeCount = 0;
    } else if (index == 1) {
      specialTabsHeight = widget.influencerPhotos != null && widget.influencerPhotos!.isNotEmpty
          ? bigScreen
              ? 0.4.sh
              : midScreen
                  ? 0.425.sh
                  : 0.485.sh
          : bigScreen
              ? 0.15.sh
              : midScreen
                  ? 0.17.sh
                  : 0.19.sh;
      photoBadgeCount = 0;
    } else if (index == 2 && !widget.isPublic) {
      specialTabsHeight = widget.influencerTweets != null && widget.influencerTweets!.isNotEmpty
          ? bigScreen
              ? 0.4.sh
              : midScreen
                  ? 0.425.sh
                  : 0.485.sh
          : bigScreen
              ? 0.101.sh
              : midScreen
                  ? 0.101.sh
                  : 0.101.sh;
    } else if (index == (widget.isPublic ? 2 : 3)) {
      specialTabsHeight = bigScreen
          ? 0.385.sh
          : midScreen
              ? 0.36.sh
              : 0.4.sh;
      idealRouteBadgeCount = 0;
    } else if (index == (widget.isPublic ? 3 : 4)) {
      specialTabsHeight = bigScreen
          ? 0.5.sh
          : midScreen
              ? 0.515.sh
              : 0.6.sh;
      interviewBadgeCount = 0;
    } else if (index == (widget.isPublic ? 4 : 5)) {
      specialTabsHeight = bigScreen || midScreen ? 0.575.sh : 0.625.sh;
      chatBadgeCount = 0;
    } else if (index == (widget.isPublic ? 5 : 6)) {
      specialTabsHeight = bigScreen || midScreen ? 0.4.sh : 0.425.sh;
      nftBadgeCount = 0;
    } else if (index == (widget.isPublic ? 6 : 7)) {
      specialTabsHeight = bigScreen
          ? 0.5.sh
          : midScreen
              ? 0.55.sh
              : 0.65.sh;
      contestBadgeCount = 0;
    } else if (index == (widget.isPublic ? 7 : 8)) {
      specialTabsHeight = bigScreen
          ? 0.4025.sh
          : midScreen
              ? 0.425.sh
              : 0.45.sh;
      videoBadgeCount = 0;
    }
    setState(() {});
  }

  @override
  void dispose() {
    specialTabsController.dispose();
    activityTabsController.dispose();
    _currentPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentProfileModel model = ComponentProfileModel.fromJson(config['profile']);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();

    final theme = context.uiKitTheme;
    final boldTextTheme = theme?.boldTextTheme;

    TextStyle? textStyle = boldTextTheme?.title1 ?? Theme.of(context).primaryTextTheme.titleMedium;
    textStyle = textStyle?.copyWith(color: theme?.colorScheme.inversePrimary);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 62.w,
          child: ListView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            controller: specialScrollController,
            scrollDirection: Axis.horizontal,
            children: [
              UiKitCustomTabBar.badged(
                key: specialTabsKey,
                tabController: specialTabsController,
                scrollable: true,
                tabs: [
                  UiKitBadgedCustomTab(title: S.current.Voice, badgeValue: voiceBadgeCount, height: 20.h),
                  UiKitBadgedCustomTab(title: S.current.Photo, badgeValue: photoBadgeCount, height: 20.h),
                  if (!widget.isPublic)
                    UiKitBadgedCustomTab(title: S.current.News, badgeValue: photoBadgeCount, height: 20.h),
                  // UiKitBadgedCustomTab(title: S.current.IdealRoute, badgeValue: idealRouteBadgeCount),
                  // UiKitBadgedCustomTab(title: S.current.Interview, badgeValue: interviewBadgeCount),
                  // UiKitBadgedCustomTab(title: S.current.Chat, badgeValue: chatBadgeCount),
                  // UiKitBadgedCustomTab(title: S.current.NFT, badgeValue: nftBadgeCount),
                  // UiKitBadgedCustomTab(title: S.current.Contest, badgeValue: contestBadgeCount),
                  // UiKitBadgedCustomTab(title: S.current.Video, badgeValue: videoBadgeCount),
                ],
                onTappedTab: (index) {
                  setSpecialTabsContentHeight(index);
                  _animateToSpecialTabPosition(index);
                },
              ).paddingOnly(
                bottom: SpacingFoundation.verticalSpacing16,
                left: horizontalMargin,
                right: horizontalMargin,
              ),
            ],
          ),
        ),
        SpacingFoundation.verticalSpace16,
        SizedBox(
          height: specialTabsHeight,
          child: TabBarView(
            controller: specialTabsController,
            children: [
              if (widget.hasVoices && widget.voices != null && widget.voices!.isNotEmpty)
                UiKitShowMoreTitledSection(
                  onShowMore: () async {
                    await widget.onShowMoreTap?.call(0);
                    setSpecialTabsContentHeight(0);
                  },
                  title: S.current.Voice,
                  content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: widget.voices!
                          .map((e) {
                            final contentTitle = e.eventUiModel?.title ?? e.placeUiModel?.title;
                            final image = (e.placeUiModel?.media != null && e.placeUiModel!.media.isNotEmpty
                                    ? e.placeUiModel!.media.first.link
                                    : null) ??
                                (e.eventUiModel?.media != null && e.eventUiModel!.media.isNotEmpty
                                    ? e.eventUiModel!.media.first.link
                                    : null);

                            final imageLink = e.placeUiModel?.media.firstWhereOrNull(
                                  (e) => e.previewType == UiKitPreviewType.horizontal,
                                ) ??
                                e.eventUiModel?.media.firstWhereOrNull(
                                  (e) => e.previewType == UiKitPreviewType.horizontal,
                                );
                            final properties = [
                              ...?e.eventUiModel?.tags,
                              ...?e.eventUiModel?.baseTags,
                              ...?e.placeUiModel?.tags,
                              ...?e.placeUiModel?.baseTags,
                            ];

                            if (e.source != null) {
                              return UiKitContentVoiceReactionCard(
                                contentTitle: contentTitle ?? S.current.NothingFound,
                                datePosted: e.createAt,
                                imageLink: imageLink?.link ?? image,
                                customVoiceWidget: AudioPlayer(
                                  key: ValueKey(e.source),
                                  source: e.source!,
                                  aptitudeList: e.amplitudes,
                                  isPreview: true,
                                  onPlay: _handlePlayback,
                                ),
                                properties: properties,
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          })
                          .take(2)
                          .toList()),
                ).paddingOnly(
                  bottom: SpacingFoundation.verticalSpacing16,
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text(S.current.NothingFound, style: boldTextTheme?.body)],
                ),
              UiKitShowMoreTitledSection(
                title: S.current.Photo,
                onShowMore: () async {
                  await widget.onShowMoreTap?.call(1);
                  setSpecialTabsContentHeight(1);
                },
                content: (widget.influencerPhotos != null && widget.influencerPhotos!.isNotEmpty)
                    ? UiKitPhotoSliderWithReactions(
                        photos: widget.influencerPhotos!.take(5).toList(),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text(S.current.NothingFound, style: boldTextTheme?.body)],
                      ),
              ).paddingOnly(bottom: SpacingFoundation.verticalSpacing16),
              if (!widget.isPublic)
                UiKitShowMoreTitledSection(
                  contentHeight: specialTabsHeight - 0.11.sh,
                  title: S.current.News,
                  needOverflowContent: true,
                  onShowMore: () async {
                    await widget.onShowMoreTap?.call(2);
                    setSpecialTabsContentHeight(2);
                  },
                  content: widget.influencerTweets != null && widget.influencerTweets!.isNotEmpty
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: widget.influencerTweets!
                              .map(
                                (e) => UiKitPostCard(
                                  isFeed: false,
                                  authorName: e.name,
                                  authorUsername: e.username,
                                  authorAvatarUrl: e.avatarUrl,
                                  authorSpeciality: e.speciality,
                                  authorUserType: e.userType,
                                  heartEyesCount: e.heartEyesReactionsCount,
                                  likesCount: e.likeReactionsCount,
                                  sunglassesCount: e.sunglassesReactionsCount,
                                  firesCount: e.fireReactionsCount,
                                  smileyCount: e.smileyReactionsCount,
                                  text: e.text,
                                  createAt: e.createAt,
                                ).paddingOnly(bottom: SpacingFoundation.verticalSpacing16),
                              )
                              .take(2)
                              .toList(),
                        )
                      : null,
                ).paddingOnly(bottom: SpacingFoundation.verticalSpacing16)
            ],
          ),
        ),
        SpacingFoundation.verticalSpace16,
        SizedBox(
          height: 62.w,
          child: ListView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            children: [
              UiKitCustomTabBar.badged(
                key: tabsKey,
                tabController: activityTabsController,
                scrollable: true,
                tabs: [
                  UiKitCustomTab(title: S.current.Reviews.toUpperCase(), group: activityTabsSizeGroup, height: 20.h),
                  UiKitCustomTab(title: S.current.Top.toUpperCase(), group: activityTabsSizeGroup, height: 20.h),
                  UiKitCustomTab(title: S.current.Respect.toUpperCase(), group: activityTabsSizeGroup, height: 20.h),
                ],
                onTappedTab: (index) {
                  _setActivityTabsContentHeight(index);
                  _animateToTabPosition();
                },
              ).paddingOnly(
                bottom: SpacingFoundation.verticalSpacing16,
                left: horizontalMargin,
                right: horizontalMargin,
              ),
            ],
          ),
        ),
        widget.isLoading
            ? Center(child: CircularProgressIndicator()).paddingSymmetric(vertical: SpacingFoundation.verticalSpacing32)
            : SizedBox(
                height: _activityTabsContentHeight,
                child: TabBarView(
                  controller: activityTabsController,
                  children: [
                    InfluencerReviewsTab(
                      horizontalMargin: horizontalMargin,
                      onItemTap: widget.onItemTap,
                      onReactionTapped: widget.onReactionTapped,
                      profilePlaces: widget.profilePlaces,
                      storiesPagingController: widget.storiesPagingController,
                      tiltNotifier: widget.tiltNotifier,
                      onExpand: () {
                        setState(() {
                          _activityTabsContentHeight += (widget.profilePlaces!.length - 3) *
                              (bigScreen
                                  ? 0.2.sh
                                  : midScreen
                                      ? 0.21.sh
                                      : 0.24.sh);
                        });
                      },
                    ),
                    if (widget.influencerTopCategories != null && widget.influencerTopCategories!.isNotEmpty)
                      InfluencerPersonalTop(
                        categories: widget.influencerTopCategories!,
                        onItemTap: widget.onItemTap,
                      ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16)
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text(S.current.NothingFound, style: boldTextTheme?.body)],
                      ),
                    if (widget.contentPreviewWithRespects != null && widget.contentPreviewWithRespects!.isNotEmpty)
                      InfluencerRespectTab(
                        items: widget.contentPreviewWithRespects!,
                        onItemTap: widget.onItemTap,
                      ).paddingSymmetric(horizontal: horizontalMargin)
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text(S.current.NothingFound, style: boldTextTheme?.body)],
                      ),
                  ],
                ),
              ),
      ],
    );
  }
}
