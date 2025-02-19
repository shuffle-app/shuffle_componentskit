import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/domain/config_models/profile/component_profile_model.dart';
import 'package:shuffle_components_kit/domain/data_uimodels/video_reaction_ui_model.dart';
import 'package:shuffle_components_kit/presentation/components/profile/public_profile/widget/influencer_reviews_tab.dart';
import 'package:shuffle_components_kit/presentation/widgets/global_component.dart';
import 'package:shuffle_components_kit/services/configuration/global_configuration.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class InfluencerReviewsTopRespectWidget extends StatefulWidget {
  final ValueNotifier<double>? tiltNotifier;
  final PagingController<int, VideoReactionUiModel>? storiesPagingController;
  final List<ProfilePlace>? profilePlaces;
  final ValueChanged<VideoReactionUiModel>? onReactionTapped;
  final List<InfluencerTopCategory>? influencerTopCategories;
  final List<ContentPreviewWithRespect>? contentPreviewWithRespects;
  final Function(int? placeId, int? eventId)? onItemTap;
  final bool isLoading;

  const InfluencerReviewsTopRespectWidget({
    super.key,
    this.tiltNotifier,
    this.storiesPagingController,
    this.profilePlaces,
    this.onReactionTapped,
    this.influencerTopCategories,
    this.contentPreviewWithRespects,
    this.onItemTap,
    this.isLoading = false,
  });

  @override
  State<InfluencerReviewsTopRespectWidget> createState() => _InfluencerReviewsTopRespectWidgetState();
}

class _InfluencerReviewsTopRespectWidgetState extends State<InfluencerReviewsTopRespectWidget>
    with TickerProviderStateMixin {
  late TabController specialTabsController = TabController(length: 8, vsync: this);
  late TabController activityTabsController = TabController(length: 3, vsync: this);
  late double specialTabsHeight = 2 * (bigScreen ? 0.265.sh : 0.325.sh);
  double _activityTabsContentHeight = 6 * 0.26.sh;
  int voiceBadgeCount = 0;
  int photoBadgeCount = 123;
  int idealRouteBadgeCount = 1;
  int interviewBadgeCount = 4;
  int chatBadgeCount = 90;
  int nftBadgeCount = 2;
  int contestBadgeCount = 999;
  int videoBadgeCount = 0;
  final activityTabsSizeGroup = AutoSizeGroup();
  final statsSizeGroup = AutoSizeGroup();
  final specialTabsKey = GlobalKey();
  final ScrollController scrollController = ScrollController();

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

  Future<void> _animateToSpecialTabPosition() async {
    if (mounted) {
      await Scrollable.ensureVisible(
        specialTabsKey.currentContext!,
        duration: const Duration(milliseconds: 250),
        curve: Curves.decelerate,
      );
    }
  }

  void _activityTabsListener() {
    final tabIndex = activityTabsController.index;
    _setActivityTabsContentHeight(tabIndex);
    _animateToSpecialTabPosition();
  }

  void _specialTabsListener() {
    final tabIndex = specialTabsController.index;
    setSpecialTabsContentHeight(tabIndex);
  }

  bool get bigScreen => 1.sw > 415;

  bool get midScreen => 1.sw > 380;

  void setSpecialTabsContentHeight(int index) {
    if (index == 0) {
      specialTabsHeight = bigScreen
          ? 0.53.sh
          : midScreen
              ? 0.56.sh
              : 0.65.sh;
      voiceBadgeCount = 0;
    } else if (index == 1) {
      specialTabsHeight = bigScreen
          ? 0.4.sh
          : midScreen
              ? 0.425.sh
              : 0.5.sh;
      photoBadgeCount = 0;
    } else if (index == 2) {
      specialTabsHeight = bigScreen
          ? 0.385.sh
          : midScreen
              ? 0.36.sh
              : 0.4.sh;
      idealRouteBadgeCount = 0;
    } else if (index == 3) {
      specialTabsHeight = bigScreen
          ? 0.5.sh
          : midScreen
              ? 0.515.sh
              : 0.6.sh;
      interviewBadgeCount = 0;
    } else if (index == 4) {
      specialTabsHeight = bigScreen || midScreen ? 0.575.sh : 0.625.sh;
      chatBadgeCount = 0;
    } else if (index == 5) {
      specialTabsHeight = bigScreen || midScreen ? 0.4.sh : 0.425.sh;
      nftBadgeCount = 0;
    } else if (index == 6) {
      specialTabsHeight = bigScreen
          ? 0.5.sh
          : midScreen
              ? 0.55.sh
              : 0.65.sh;
      contestBadgeCount = 0;
    } else if (index == 7) {
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
        // UiKitCustomTabBar.badged(
        //   key: specialTabsKey,
        //   tabController: specialTabsController,
        //   scrollable: true,
        //   tabs: [
        //     UiKitBadgedCustomTab(title: S.current.Voice, badgeValue: voiceBadgeCount),
        //     UiKitBadgedCustomTab(title: S.current.Photo, badgeValue: photoBadgeCount),
        //     UiKitBadgedCustomTab(title: S.current.IdealRoute, badgeValue: idealRouteBadgeCount),
        //     UiKitBadgedCustomTab(title: S.current.Interview, badgeValue: interviewBadgeCount),
        //     UiKitBadgedCustomTab(title: S.current.Chat, badgeValue: chatBadgeCount),
        //     UiKitBadgedCustomTab(title: S.current.NFT, badgeValue: nftBadgeCount),
        //     UiKitBadgedCustomTab(title: S.current.Contest, badgeValue: contestBadgeCount),
        //     UiKitBadgedCustomTab(title: S.current.Video, badgeValue: videoBadgeCount),
        //   ],
        //   onTappedTab: (index) {
        //     // setSpecialTabsContentHeight(index);
        //   },
        // ),
        SizedBox(
          height: 62.w,
          child: ListView(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            children: [
              UiKitCustomTabBar.badged(
                key: specialTabsKey,
                tabController: activityTabsController,
                scrollable: true,
                tabs: [
                  UiKitCustomTab(title: S.current.Reviews.toUpperCase(), group: activityTabsSizeGroup, height: 20.h),
                  UiKitCustomTab(title: S.current.Top.toUpperCase(), group: activityTabsSizeGroup, height: 20.h),
                  UiKitCustomTab(title: S.current.Respect.toUpperCase(), group: activityTabsSizeGroup, height: 20.h),
                ],
                onTappedTab: (index) {
                  _setActivityTabsContentHeight(index);
                  _animateToSpecialTabPosition();
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
                        children: [Text(S.current.NothingFound)],
                      ),
                    if (widget.contentPreviewWithRespects != null && widget.contentPreviewWithRespects!.isNotEmpty)
                      InfluencerRespectTab(
                        items: widget.contentPreviewWithRespects!,
                        onItemTap: widget.onItemTap,
                      ).paddingSymmetric(horizontal: horizontalMargin)
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text(S.current.NothingFound)],
                      ),
                  ],
                ),
              ),
      ],
    );
  }
}
