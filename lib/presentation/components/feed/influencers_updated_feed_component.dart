// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:anchor_scroll_controller/anchor_scroll_controller.dart';

import '../../../domain/data_uimodels/influencer_models/influencer_feed_item.dart';

class InfluencersUpdatedFeedComponent extends StatefulWidget {
  final ValueChanged<String>? onTappedTab;
  final VoidCallback? onDispose;
  final Function(int, String)? onReactionsTapped;
  final ValueChanged<int>? onLongPress;
  final ValueChanged<int>? onSharePress;
  final ValueChanged<int?>? onProfilePress;
  final ValueChanged<int>? onReadTap;
  final ValueChanged<int>? onCheckVisibleItems;
  final AnchorScrollController? latestScrollController;
  final AnchorScrollController? topScrollController;
  final AnchorScrollController? unreadScrollController;
  final TextEditingController? searchController;

  final PagingController<int, InfluencerFeedItem> latestContentController;
  final PagingController<int, InfluencerFeedItem> topContentController;
  final PagingController<int, InfluencerFeedItem> unreadContentController;

  final ValueNotifier<InfluencerFeedItem?>? pinnedPublication;
  final bool showPinnedPublication;
  final VoidCallback? onPinnedPublicationTap;
  final RichText? weather;
  final bool pinnedIsLoading;

  const InfluencersUpdatedFeedComponent({
    super.key,
    this.onTappedTab,
    this.onDispose,
    this.onCheckVisibleItems,
    required this.latestContentController,
    required this.topContentController,
    required this.unreadContentController,
    this.onReactionsTapped,
    this.onLongPress,
    this.onSharePress,
    this.onProfilePress,
    this.onReadTap,
    this.latestScrollController,
    this.topScrollController,
    this.unreadScrollController,
    this.pinnedPublication,
    this.showPinnedPublication = false,
    this.onPinnedPublicationTap,
    this.searchController,
    this.weather,
    this.pinnedIsLoading = false,
  });

  @override
  State<InfluencersUpdatedFeedComponent> createState() => _InfluencersUpdatedFeedComponentState();
}

class _InfluencersUpdatedFeedComponentState extends State<InfluencersUpdatedFeedComponent>
    with SingleTickerProviderStateMixin {
  late final tabController = TabController(length: 3, vsync: this);
  final autoSizeGroup = AutoSizeGroup();

  late final latestPublicationsKey = UniqueKey();
  late final topPublicationsKey = UniqueKey();
  late final unreadPublicationsKey = UniqueKey();

  final Duration sizingDuration = Duration(milliseconds: 100);

  double? disappearingHeight;

  late final _tabs = [
    UiKitCustomTab(title: S.current.Latest.toUpperCase(), customValue: 'latest', group: autoSizeGroup,height: 20.h,),
    UiKitCustomTab(title: S.current.Top.toUpperCase(), customValue: 'top', group: autoSizeGroup,height: 20.h),
    UiKitCustomTab(title: S.current.Unread.toUpperCase(), customValue: 'unread', group: autoSizeGroup,height: 20.h),
  ];

  double latestScrollOffset = 0.0;
  double topScrollOffset = 0.0;
  double unreadScrollOffset = 0.0;

  onReactionsTapped(int index, String reaction) async {
    // Handle reaction tapped
    await widget.onReactionsTapped?.call(index, reaction);
    if (mounted) {
      setState(() {});
    }
  }

  late bool _isCardVisible;
  bool _hasImageInPinned = false;

  double get topPaddingForPinned {
    if (showSearchBar && !isSearchBarActivated) {
      return 0.235.sw;
    } else if (isSearchBarActivated) {
      return 0.30.sw;
    } else {
      return _isCardVisible ? (_hasImageInPinned ? 0.32.sw : 0.25.sw) : 50.h;
    }
  }

  BorderRadius get clipBorderRadius =>
      _isCardVisible ? BorderRadiusFoundation.onlyTop24 : BorderRadiusFoundation.all24r;

  bool showSearchBar = false;
  bool isSearchBarActivated = false;
  final FocusNode _searchFocusNode = FocusNode();

  final Duration scrollToDuration = const Duration(milliseconds: 150);
  final Curve scrollToCurve = Curves.easeOut;

  _toggleCardVisibility() {
    final index = tabController.index;
    setState(() {
      _isCardVisible =
          index == 0 && (widget.showPinnedPublication && widget.pinnedPublication?.value != null && !showSearchBar);
    });

    widget.onTappedTab?.call(_tabs[index].customValue!);

    switch (_tabs[index].customValue) {
      case 'latest':
        widget.latestScrollController?.jumpTo(latestScrollOffset);
        // widget.latestScrollController?.animateTo(latestScrollOffset, duration: scrollToDuration, curve: scrollToCurve);
        break;
      case 'top':
        widget.topScrollController?.jumpTo(topScrollOffset);
        // widget.topScrollController?.animateTo(topScrollOffset, duration: scrollToDuration, curve: scrollToCurve);
        break;
      case 'unread':
        widget.unreadScrollController?.jumpTo(unreadScrollOffset);
        // widget.unreadScrollController?.animateTo(unreadScrollOffset, duration: scrollToDuration, curve: scrollToCurve);
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _isCardVisible = widget.showPinnedPublication && widget.pinnedPublication?.value != null;
    widget.pinnedPublication?.addListener(_toggleCardVisibility);
    Future.delayed(Duration.zero, () => _toggleCardVisibility());

    tabController.addListener(_toggleCardVisibility);
    widget.latestScrollController?.addListener(_scrollListener);
    widget.topScrollController?.addListener(_scrollTopListener);
    widget.unreadScrollController?.addListener(_unreadScrollListener);
  }

  _scrollTopListener() {
    topScrollOffset = widget.topScrollController!.offset;
  }

  _unreadScrollListener() {
    unreadScrollOffset = widget.unreadScrollController!.offset;
  }

  _scrollListener() {
    if (!mounted) return;
    latestScrollOffset = widget.latestScrollController!.offset;
    if (widget.latestScrollController!.offset < -50.h && !showSearchBar) {
      setState(() {
        showSearchBar = true;
        _isCardVisible = false;
      });
    } else if (widget.latestScrollController!.offset > 44.h && showSearchBar && !isSearchBarActivated) {
      setState(() {
        disappearingHeight = 0;
      });
      Future.delayed(
          sizingDuration,
          () => setState(() {
                showSearchBar = false;
                _isCardVisible = tabController.index == 0 &&
                    (widget.showPinnedPublication && widget.pinnedPublication?.value != null);
                disappearingHeight = null;
              }));
    }
  }

  _onSearchPressed() {
    setState(() {
      isSearchBarActivated = true;
    });
    Future.delayed(const Duration(seconds: 1), () => _searchFocusNode.requestFocus());
  }

  @override
  void dispose() {
    widget.latestScrollController?.removeListener(_scrollTopListener);
    widget.unreadScrollController?.removeListener(_unreadScrollListener);
    widget.topScrollController?.removeListener(_scrollTopListener);
    tabController.removeListener(_toggleCardVisibility);
    widget.pinnedPublication?.removeListener(_toggleCardVisibility);
    widget.searchController?.clear();

    Future.delayed(Duration.zero, () => widget.onDispose?.call());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.uiKitTheme?.colorScheme;
    final currentTabIndex = tabController.index;
    return Stack(
      fit: StackFit.expand,
      children: [
        Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadiusFoundation.onlyBottom24,
              clipper: _CustomBlurClipper(topPadding: MediaQuery.viewPaddingOf(context).top),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: SafeArea(
                    bottom: false,
                    child: UiKitCustomTabBar(
                      tabController: tabController,
                      tabs: _tabs,
                      clipBorderRadius: clipBorderRadius,
                      onTappedTab: (index) {
                        //checking double tap on
                        if (currentTabIndex == index) {
                          switch (_tabs[index].customValue) {
                            case 'latest':
                              widget.latestScrollController
                                  ?.animateTo(0.0, duration: scrollToDuration, curve: scrollToCurve);
                              break;
                            case 'top':
                              widget.topScrollController
                                  ?.animateTo(0.0, duration: scrollToDuration, curve: scrollToCurve);
                              break;
                            case 'unread':
                              widget.unreadScrollController
                                  ?.animateTo(0.0, duration: scrollToDuration, curve: scrollToCurve);
                              break;
                          }
                        }
                      },
                    ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal12)),
              ),
            ),
            if (widget.pinnedPublication?.value != null)
              Builder(
                builder: (context) {
                  final pinnedPublication = widget.pinnedPublication!.value;
                  List<String>? images;

                  if (pinnedPublication is DigestFeedItem) {
                    images = (pinnedPublication.digestUiModels != null && pinnedPublication.digestUiModels!.isNotEmpty
                        ? pinnedPublication.digestUiModels![0].imageUrl != null &&
                                pinnedPublication.digestUiModels![0].imageUrl!.isNotEmpty
                            ? [pinnedPublication.digestUiModels![0].imageUrl!]
                            : null
                        : null);
                    _hasImageInPinned = images != null && images.isNotEmpty;

                    return PinnedPublication(
                      text: pinnedPublication.title ?? '',
                      images: images,
                      onPinnedPublicationTap: widget.onPinnedPublicationTap,
                      isCardVisible: _isCardVisible,
                      pinnedIsLoading: widget.pinnedIsLoading,
                    );
                  } else if (pinnedPublication is ShufflePostFeedItem) {
                    images = pinnedPublication.newPhotos?.map((e) => e.link).toList();
                    _hasImageInPinned = images != null && images.isNotEmpty;

                    return PinnedPublication(
                      text: pinnedPublication.text,
                      images: images,
                      onPinnedPublicationTap: widget.onPinnedPublicationTap,
                      isCardVisible: _isCardVisible,
                      pinnedIsLoading: widget.pinnedIsLoading,
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: showSearchBar
                  ? !isSearchBarActivated
                      ? AnimatedSize(
                          duration: sizingDuration,
                          child: SizedBox(
                              height: disappearingHeight,
                              child: StatusWeatherSearchBar(
                                onSearchPressed: _onSearchPressed,
                                weather: widget.weather,
                              ).paddingSymmetric(
                                horizontal: EdgeInsetsFoundation.horizontal16,
                                vertical: EdgeInsetsFoundation.vertical12,
                              )))
                      : UiKitInputFieldRightIcon(
                          controller: widget.searchController ?? TextEditingController(),
                          autofocus: true,
                          hintText: S.current.Search,
                          focusNode: _searchFocusNode,
                          icon: context.iconButtonNoPadding(
                            data: BaseUiKitButtonData(
                              onPressed: () {
                                setState(() {
                                  isSearchBarActivated = false;
                                });
                                _searchFocusNode.unfocus();
                                widget.searchController?.text = '';
                              },
                              iconInfo: BaseUiKitButtonIconData(
                                  iconData: ShuffleUiKitIcons.x, color: colorScheme?.inversePrimary),
                            ),
                          ),
                        ).paddingSymmetric(
                          horizontal: EdgeInsetsFoundation.horizontal16,
                          vertical: SpacingFoundation.verticalSpacing4,
                        )
                  : SizedBox.shrink(),
            ),
          ],
        ),
        TabBarView(
          controller: tabController,
          children: [
            _PagedInfluencerFeedItemListBody(
              key: latestPublicationsKey,
              onReactionsTapped: onReactionsTapped,
              pagingController: widget.latestContentController,
              onCheckVisibleItems: widget.onCheckVisibleItems,
              onLongPress: widget.onLongPress,
              onSharePress: widget.onSharePress,
              onProfilePress: widget.onProfilePress,
              scrollController: widget.latestScrollController,
              onReadTap: widget.onReadTap,
              topPadding: topPaddingForPinned,
              onSearchPressed: _onSearchPressed,
              isSearchActivated: showSearchBar,
              weather: widget.weather,
            ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
            _PagedInfluencerFeedItemListBody(
              key: topPublicationsKey,
              onReactionsTapped: onReactionsTapped,
              pagingController: widget.topContentController,
              onCheckVisibleItems: widget.onCheckVisibleItems,
              onLongPress: widget.onLongPress,
              onSharePress: widget.onSharePress,
              onProfilePress: widget.onProfilePress,
              scrollController: widget.topScrollController,
              onReadTap: widget.onReadTap,
              topPadding: topPaddingForPinned,
              onSearchPressed: _onSearchPressed,
              isSearchActivated: showSearchBar,
              weather: widget.weather,
            ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
            _PagedInfluencerFeedItemListBody(
              key: unreadPublicationsKey,
              onReactionsTapped: onReactionsTapped,
              pagingController: widget.unreadContentController,
              onCheckVisibleItems: widget.onCheckVisibleItems,
              onLongPress: widget.onLongPress,
              onSharePress: widget.onSharePress,
              onProfilePress: widget.onProfilePress,
              scrollController: widget.unreadScrollController,
              onReadTap: widget.onReadTap,
              topPadding: topPaddingForPinned,
              onSearchPressed: _onSearchPressed,
              isSearchActivated: showSearchBar,
              weather: widget.weather,
            ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
          ],
        ),
      ].reversed.toList(),
    );
  }
}

class _CustomBlurClipper extends CustomClipper<RRect> {
  final double topPadding;

  const _CustomBlurClipper({this.topPadding = 60});

  @override
  RRect getClip(Size size) {
    return RRect.fromRectAndCorners(Rect.fromLTWH(0, 0, 1.sw, topPadding + 33.h),
        bottomLeft: const Radius.circular(24), bottomRight: const Radius.circular(24));
  }

  @override
  bool shouldReclip(covariant CustomClipper<RRect> oldClipper) {
    return true;
  }
}

class _PagedInfluencerFeedItemListBody extends StatelessWidget {
  final PagingController<int, InfluencerFeedItem> pagingController;
  final Function(int, String)? onReactionsTapped;
  final ValueChanged<int>? onLongPress;
  final ValueChanged<int>? onSharePress;
  final ValueChanged<int?>? onProfilePress;
  final ValueChanged<int>? onReadTap;
  final ValueChanged<int>? onCheckVisibleItems;
  final AnchorScrollController? scrollController;
  final VoidCallback? onSearchPressed;
  final bool isSearchActivated;
  final RichText? weather;
  final double? topPadding;

  const _PagedInfluencerFeedItemListBody(
      {required this.pagingController,
      this.onCheckVisibleItems,
      this.onReactionsTapped,
      this.onLongPress,
      this.onSharePress,
      this.onProfilePress,
      this.onReadTap,
      this.scrollController,
      this.topPadding,
      this.onSearchPressed,
      this.isSearchActivated = false,
      this.weather,
      super.key});

  double get _videoReactionPreviewWidth => 0.125.sw;

  int get _fittingVideoReactionsPreviewCount {
    final screenHorizontalSpacing = SpacingFoundation.horizontalSpacing32 + SpacingFoundation.horizontalSpacing32;
    final availableScreenWidth = 1.sw - screenHorizontalSpacing;

    /// subtracting 1 to make space for placeholder
    /// and another 1 to make sure all reactions fit
    return (availableScreenWidth ~/ _videoReactionPreviewWidth) - 2;
  }

  @override
  Widget build(BuildContext context) {
    final regularTextTheme = context.uiKitTheme?.regularTextTheme;
    final ValueNotifier<int> indexOfItem = ValueNotifier<int>(0);

    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (t) {
        onCheckVisibleItems?.call(indexOfItem.value);
        return true;
      },
      child: PagedListView.separated(
        scrollController: scrollController,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          bottom: kBottomNavigationBarHeight + EdgeInsetsFoundation.vertical32,
          top: MediaQuery.viewPaddingOf(context).top,
        ),
        pagingController: pagingController,
        separatorBuilder: (context, index) => SpacingFoundation.verticalSpace2,
        builderDelegate: PagedChildBuilderDelegate<InfluencerFeedItem>(
          itemBuilder: (context, item, index) {
            final isLast = index == pagingController.itemList!.length;
            double bottomPadding = isLast ? 0 : SpacingFoundation.verticalSpacing8;
            indexOfItem.value = index;
            log(' item id ${item.id} ');

            late final Widget child;
            if (item is ShufflePostFeedItem) {
              child = UiKitContentUpdatesCard.fromShuffle(
                key: item.key,
                text: item.text,
                onSharePress: () => onSharePress?.call(item.id),
                heartEyesReactionsCount: item.heartEyesReactionsCount,
                likeReactionsCount: item.likeReactionsCount,
                fireReactionsCount: item.fireReactionsCount,
                sunglassesReactionsCount: item.sunglassesReactionsCount,
                smileyReactionsCount: item.smileyReactionsCount,
                onReactionsTapped: (str) => onReactionsTapped?.call(item.id, str),
                createdAt: item.createdAt,
                onLongPress: () => onLongPress?.call(item.id),
                showTranslateButton: item.showTranslateButton,
                translateText: item.translateText,
                children: _children(item, regularTextTheme),
              ).paddingOnly(bottom: EdgeInsetsFoundation.vertical16);
            } else if (item is PostFeedItem) {
              child = UiKitPostCard(
                key: item.key,
                authorName: item.name,
                authorUsername: item.username,
                authorAvatarUrl: item.avatarUrl,
                authorSpeciality: item.speciality,
                authorUserType: item.userType,
                onSharePress: () => onSharePress?.call(item.id),
                heartEyesCount: item.heartEyesReactionsCount,
                likesCount: item.likeReactionsCount,
                sunglassesCount: item.sunglassesReactionsCount,
                firesCount: item.fireReactionsCount,
                smileyCount: item.smileyReactionsCount,
                text: item.text,
                createdAt: item.createdAt ?? '',
                onReactionsTapped: (str) => onReactionsTapped?.call(item.id, str),
                hasNewMark: item.newMark,
                onLongPress: () => onLongPress?.call(item.id),
                onProfilePress: item.userType == UserTileType.pro ? () => onProfilePress?.call(item.userId) : null,
                showTranslateButton: item.showTranslateButton,
                translateText: item.translateText,
              ).paddingOnly(bottom: bottomPadding);
            } else if (item is UpdatesFeedItem) {
              child = UiKitContentUpdatesCard(
                key: item.key,
                createdAt: item.createdAt ?? '',
                authorSpeciality: item.speciality,
                authorName: item.name,
                authorUsername: item.username,
                onSharePress: () => onSharePress?.call(item.id),
                authorAvatarUrl: item.avatarUrl,
                authorUserType: item.userType,
                onReactionsTapped: (str) => onReactionsTapped?.call(item.id, str),
                onLongPress: () => onLongPress?.call(item.id),
                children: _children(item, regularTextTheme),
              ).paddingOnly(bottom: bottomPadding);
            } else if (item is DigestFeedItem) {
              child = UiKitDigestCard(
                onSharePress: () => onSharePress?.call(item.id),
                key: item.key,
                title: item.title,
                digestUiModels: item.digestUiModels,
                underTitleText: item.underTitleText,
                onReactionsTapped: (str) => onReactionsTapped?.call(item.id, str),
                heartEyesReactionsCount: item.heartEyesReactionsCount,
                likeReactionsCount: item.likeReactionsCount,
                fireReactionsCount: item.fireReactionsCount,
                sunglassesReactionsCount: item.sunglassesReactionsCount,
                smileyReactionsCount: item.smileyReactionsCount,
                createdAt: item.createdAt ?? '',
                onReadTap: () => onReadTap?.call(item.id),
                showTranslateButton: item.showTranslateButton,
                titleTranslateText: item.translateTitle,
                underTitleTranslateText: item.translateUnderTitle,
              ).paddingOnly(bottom: bottomPadding);
            } else {
              child = throw UnimplementedError('Unknown item type: ${item.runtimeType}');
            }

            return AnchorItemWrapper(
              index: index,
              controller: scrollController,
              child: index == 0
                  ? AnimatedSize(
                      duration: const Duration(milliseconds: 350), child: child.paddingOnly(top: topPadding ?? 0))
                  : child,
            );
          },
        ),
      ),
    );
  }

  List<UiKitContentUpdateWidget> _children(UpdatesFeedItem item, UiKitRegularTextTheme? regularTextTheme) {
    final shufflePostVideoWidgetWidth = 0.16845.sw;
    final shufflePostVideoWidgetHeight = 0.16845.sw * 0.75;
    final playButtonSize = Size(32.w, 24.h);
    final xOffset = shufflePostVideoWidgetWidth / 2 - playButtonSize.width / 2;
    final yOffset = shufflePostVideoWidgetHeight / 2 - playButtonSize.height / 2;

    return [
      if (item is ShufflePostFeedItem && item.videos != null && item.videos!.isNotEmpty)
        UiKitCustomChildContentUpdateWidget(
          height: shufflePostVideoWidgetHeight,
          child: Row(
            children: item.videos!.map(
              (video) {
                final isLast = item.videos!.last == video;

                return SizedBox(
                  height: shufflePostVideoWidgetHeight,
                  child: UiKitMediaVideoWidget(
                    width: shufflePostVideoWidgetWidth,
                    playButtonCustomOffset: Offset(xOffset, yOffset),
                    media: video,
                    borderRadius: BorderRadiusFoundation.all8,
                  ).paddingOnly(right: isLast ? 0 : EdgeInsetsFoundation.horizontal16),
                );
              },
            ).toList(),
          ),
        ),
      if (item.newPhotos != null && item.newPhotos!.isNotEmpty)
        UiKitStaggeredMediaRow(
          mediaList: item.newPhotos!,
          visibleMediaCount: 4,
        ),
      if (item.newVideos != null && item.newVideos!.isNotEmpty)
        ...item.newVideos!.map((video) {
          return UiKitContentUpdateWithLeadingImage(
            title: S.current.PlusXNewVideos,
            iconData: ShuffleUiKitIcons.playoutline,
            imageUrl: video.previewImage,
            subtitle: video.subtitle,
          );
        }),
      if (item.newFeedbacks != null && item.newFeedbacks!.isNotEmpty)
        ...item.newFeedbacks!.map((feedback) {
          return UiKitContentUpdateWithLeadingImage(
            imageUrl: feedback.previewImage,
            title: S.current.PlusXNewReviews(item.newFeedbacks!.length),
            iconData: ShuffleUiKitIcons.starfill,
            subtitle: feedback.subtitle,
          );
        }),
      if (item.newVideoReactions != null && item.newVideoReactions!.isNotEmpty)
        UiKitCustomChildContentUpdateWidget(
          height: _videoReactionPreviewWidth * 1.7,
          child: UiKitContentRowWithHiddenItems(
            placeholderSize: Size(_videoReactionPreviewWidth, _videoReactionPreviewWidth * 1.7),
            visibleItemsCount: _fittingVideoReactionsPreviewCount,
            placeholderImagePath: item.newVideoReactions!.first.previewImageUrl ?? '',
            placeHolderTitle: S.current.PlusXNewVideoReactions(
                item.newVideoReactions!.length > _fittingVideoReactionsPreviewCount
                    ? item.newVideoReactions!.length - _fittingVideoReactionsPreviewCount
                    : item.newVideoReactions!.length),
            children: item.newVideoReactions!.map((reaction) {
              return UiKitReactionPreview(
                viewed: reaction.isViewed,
                isEmpty: false,
                imagePath: reaction.previewImageUrl,
                customHeight: _videoReactionPreviewWidth * 1.7,
                customWidth: _videoReactionPreviewWidth,
                borderRadius: BorderRadiusFoundation.all8,
              );
            }).toList(),
          ),
        ),
      if (item.newVoices != null && item.newVoices!.isNotEmpty)
        UiKitContentUpdateWithLeadingImage(
          title: S.current.PlusXNewVoices(item.newVoices!.length),
          iconData: ShuffleUiKitIcons.voice,
          imageUrl: (item.newVoices!.first.content?.media.isNotEmpty ?? false)
              ? item.newVoices!.first.content?.media.first.link ?? ''
              : '',
          subtitle: item.newVoices!.first.content?.title ?? '',
        ),
      if (item.newRoutes != null && item.newRoutes!.isNotEmpty)
        ...item.newRoutes!.map((route) {
          return UiKitContentUpdateWithLeadingImage(
            title: S.current.PlusXNewRoutes,
            iconData: route.icon,
            imageUrl: route.thumbnailUrl ?? '',
            subtitle: '${route.routeAPointName} - ${route.routeBPointName}',
          );
        }),
      if (item.newVideoInterviews != null && item.newVideoInterviews!.isNotEmpty)
        ...item.newVideoInterviews!.map((interview) {
          return UiKitContentUpdateWithLeadingImage(
            title: S.current.PlusXNewInterviews,
            iconData: interview.icon,
            imageUrl: interview.thumbnailUrl ?? '',
            subtitle: interview.title,
          );
        }),
      if (item.newContests != null && item.newContests!.isNotEmpty)
        ...item.newContests!.map((contest) {
          return UiKitContestUpdateWidget(
            title: S.current.PlusXNewContests,
            text: contest.description,
            contestVideo: UiKitReactionPreview(
              viewed: contest.video?.isViewed ?? false,
              isEmpty: false,
              imagePath: contest.video?.previewImageUrl ?? '',
              customHeight: _videoReactionPreviewWidth * 1.7,
              customWidth: _videoReactionPreviewWidth,
              borderRadius: BorderRadiusFoundation.all8,
            ),
            height: _videoReactionPreviewWidth * 1.7,
          );
        }),
      if (item.newPersonalTops != null && item.newPersonalTops!.isNotEmpty)
        ...item.newPersonalTops!.map((top) {
          return UiKitContentUpdateWithLeadingImage(
            title: '${(S.current.Top).toUpperCase()} ${top.title}',
            subtitle: top.subtitle,
            imageUrl: top.topContent?.isNotEmpty ?? false
                ? (top.topContent?.first.media.isNotEmpty ?? false)
                    ? top.topContent?.first.media.first.link ?? ''
                    : ''
                : '',
          );
        }),
      if (item.newPersonalRespects != null && item.newPersonalRespects!.isNotEmpty)
        UiKitCustomChildContentUpdateWidget(
          height: 0.16875.sw,
          child: UiKitContentRowWithHiddenItems(
            placeholderSize: Size(1.35 * 0.16875.sw, 0.16875.sw),
            visibleItemsCount: 2,
            placeholderImagePath: item.newPersonalRespects!.first.thumbnail,
            placeHolderTitle: S.current.PlusXNewRespects(item.newPersonalRespects!.length > 2
                ? item.newPersonalRespects!.length - 2
                : item.newPersonalRespects!.length),
            children: item.newPersonalRespects!.map((respect) {
              return ClipRRect(
                borderRadius: BorderRadiusFoundation.all8,
                child: ImageWidget(
                  height: 0.16875.sw,
                  width: 1.35 * 0.16875.sw,
                  link: respect.thumbnail,
                  fit: BoxFit.cover,
                ),
              );
            }).toList(),
          ),
        ),
      if (item.commentsUpdate != null)
        UiKitOnlyTextContentUpdateWidget(
          updateIcon: ShuffleUiKitIcons.message,
          titleTrailing: Text(
            formatDifference(item.commentsUpdate!.lastCommentDate),
            style: regularTextTheme?.caption3.copyWith(color: ColorsFoundation.mutedText),
            textAlign: TextAlign.end,
          ),
          text: item.commentsUpdate!.lastComment,
          title:
              '${S.current.Chat.toUpperCase()} ${S.current.PlusXNewChatComments(item.commentsUpdate!.commentsCount)}',
        ),
      if (item.newContent != null && item.newContent!.isNotEmpty)
        ...item.newContent!.map((content) {
          return UiKitContentUpdateWithLeadingImage(
            imageUrl: content.media.isNotEmpty ? content.media.first.link : '',
            title: content.title,
            subtitle: content.placeName,
          );
        }),
    ];
  }
}
