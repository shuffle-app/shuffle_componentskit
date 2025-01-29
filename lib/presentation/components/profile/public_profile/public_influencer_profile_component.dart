import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/profile/public_profile/profile_highlights.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../../../domain/config_models/profile/component_profile_model.dart';

class PublicInfluencerProfileComponent extends StatefulWidget {
  final UiProfileModel uiProfileModel;
  final ProfileStats? profileStats;
  final bool loadingContent;

  const PublicInfluencerProfileComponent(
      {super.key, required this.uiProfileModel, this.profileStats, required this.loadingContent});

  @override
  State<PublicInfluencerProfileComponent> createState() => _PublicInfluencerProfileComponentState();
}

class _PublicInfluencerProfileComponentState extends State<PublicInfluencerProfileComponent>
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
      setSpecialTabsContentHeight(0);
      _setActivityTabsContentHeight(0);
    });
  }

  void _setActivityTabsContentHeight(int index) {
    if (index == 0) {
      _activityTabsContentHeight = 6 *
          (bigScreen
              ? 0.265.sh
              : midScreen
                  ? 0.27.sh
                  : 0.275.sh);
    } else if (index == 1) {
      _activityTabsContentHeight = 4 * (bigScreen || midScreen ? 0.3.sh : 0.3575.sh);
    } else if (index == 2) {
      _activityTabsContentHeight = 2 *
          (bigScreen
              ? 0.43.sh
              : midScreen
                  ? 0.45.sh
                  : 0.5.sh);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentProfileModel model = ComponentProfileModel.fromJson(config['profile']);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();

    final theme = context.uiKitTheme;
    final boldTextTheme = theme?.boldTextTheme;

    TextStyle? textStyle = boldTextTheme?.title1 ?? Theme.of(context).primaryTextTheme.titleMedium;
    textStyle = textStyle?.copyWith(color: theme?.colorScheme.inversePrimary);

    return BlurredAppBarPage(
      centerTitle: true,
      customTitle: Expanded(
          child: AutoSizeText(
        widget.uiProfileModel.name ?? '',
        maxLines: 2,
        style: textStyle,
        textAlign: TextAlign.center,
      )),
      customToolbarBaseHeight: (widget.uiProfileModel.name ?? '').length > 15 ? 100 : null,
      autoImplyLeading: true,
      bodyBottomSpace: verticalMargin,
      childrenPadding: EdgeInsets.zero,
      children: widget.uiProfileModel.userTileType != UserTileType.influencer
          ? [
              0.2.sh.heightBox,
              ImageWidget(
                rasterAsset: GraphicsFoundation.instance.png.noPhoto,
                height: 0.175.sh,
              ),
              Stack(
                children: [
                  GradientableWidget(
                    gradient: GradientFoundation.badgeIcon,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: S.current.UserHasNoPublicProfileStart,
                            style: boldTextTheme?.title2.copyWith(color: Colors.transparent),
                          ),
                          TextSpan(
                            text: ' @${widget.uiProfileModel.nickname ?? ''} ',
                            style: boldTextTheme?.title2.copyWith(color: Colors.white),
                          ),
                          TextSpan(
                            text: S.current.UserHasNoPublicProfileEnd,
                            style: boldTextTheme?.title2.copyWith(color: Colors.transparent),
                          ),
                        ],
                      ),
                    ),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: S.current.UserHasNoPublicProfileStart,
                          style: boldTextTheme?.title2,
                        ),
                        TextSpan(
                          text: ' @${widget.uiProfileModel.nickname ?? ''} ',
                          style: boldTextTheme?.title2.copyWith(color: Colors.transparent),
                        ),
                        TextSpan(
                          text: S.current.UserHasNoPublicProfileEnd,
                          style: boldTextTheme?.title2,
                        ),
                      ],
                    ),
                  ),
                ],
              ).paddingAll(EdgeInsetsFoundation.all16),
            ]
          : [
              verticalMargin.heightBox,
              widget.uiProfileModel.cardWidgetPublic.paddingSymmetric(horizontal: horizontalMargin),
              if (widget.profileStats != null)
                ProfileHighlights(profileStats: widget.profileStats!)
                    .paddingSymmetric(horizontal: horizontalMargin, vertical: SpacingFoundation.verticalSpacing16),
              if (widget.loadingContent)
                UiKitShimmerProgressIndicator(
                  gradient: GradientFoundation.shunyGreyGradient,
                  child: UiKitProUserProfileEventCard(
                    title: '',
                    contentDate: DateTime.now(),
                    videoReactions: [ProfileVideoReaction(image: GraphicsFoundation.instance.png.place.path)],
                    reviews: [
                      UiKitFeedbackCard(),
                    ],
                  ),
                ).paddingSymmetric(vertical: SpacingFoundation.verticalSpacing16, horizontal: horizontalMargin)

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
              // UiKitCustomTabBar(
              //   tabController: activityTabsController,
              //   tabs: [
              //     UiKitCustomTab(title: S.current.Reviews.toUpperCase(), group: activityTabsSizeGroup),
              //     UiKitCustomTab(title: S.current.Top.toUpperCase(), group: activityTabsSizeGroup),
              //     UiKitCustomTab(title: S.current.Respect.toUpperCase(), group: activityTabsSizeGroup),
              //   ],
              //   onTappedTab: (index) {
              //     _setActivityTabsContentHeight(index);
              //   },
              // ),
            ],
    );
  }
}
