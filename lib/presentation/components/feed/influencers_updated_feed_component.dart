// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../domain/data_uimodels/influencer_models/influencer_feed_item.dart';

class InfluencersUpdatedFeedComponent extends StatefulWidget {
  final ValueChanged<String>? onTappedTab;
  final VoidCallback? onDispose;
  final Function(int, String)? onReactionsTapped;
  final ValueChanged<int>? onLongPress;

  final PagingController<int, InfluencerFeedItem> latestContentController;
  final PagingController<int, InfluencerFeedItem> topContentController;
  final PagingController<int, InfluencerFeedItem> unreadContentController;

  const InfluencersUpdatedFeedComponent({
    super.key,
    this.onTappedTab,
    this.onDispose,
    required this.latestContentController,
    required this.topContentController,
    required this.unreadContentController,
    this.onReactionsTapped,
    this.onLongPress,
  });

  @override
  State<InfluencersUpdatedFeedComponent> createState() => _InfluencersUpdatedFeedComponentState();
}

class _InfluencersUpdatedFeedComponentState extends State<InfluencersUpdatedFeedComponent>
    with SingleTickerProviderStateMixin {
  late final tabController = TabController(length: 3, vsync: this);
  final autoSizeGroup = AutoSizeGroup();

  late final _tabs = [
    UiKitCustomTab(title: S.current.Latest, customValue: 'latest', group: autoSizeGroup),
    UiKitCustomTab(title: S.current.Top, customValue: 'top', group: autoSizeGroup),
    UiKitCustomTab(title: S.current.Unread, customValue: 'unread', group: autoSizeGroup),
  ];

  onReactionsTapped(int index, String reaction) async {
    // Handle reaction tapped
    await widget.onReactionsTapped?.call(index, reaction);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    Future.delayed(Duration.zero, () => widget.onDispose?.call());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1.sh,
      width: 1.sw,
      child: Column(
        children: [
          MediaQuery.viewPaddingOf(context).top.heightBox,
          SpacingFoundation.verticalSpace16,
          UiKitCustomTabBar(
            tabController: tabController,
            tabs: _tabs,
            onTappedTab: (index) => widget.onTappedTab,
          ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                _PagedInfluencerFeedItemListBody(
                  onReactionsTapped: onReactionsTapped,
                  pagingController: widget.latestContentController,
                  onLongPress: widget.onLongPress,
                ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
                _PagedInfluencerFeedItemListBody(
                  onReactionsTapped: onReactionsTapped,
                  pagingController: widget.topContentController,
                  onLongPress: widget.onLongPress,
                ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
                _PagedInfluencerFeedItemListBody(
                  onReactionsTapped: onReactionsTapped,
                  pagingController: widget.unreadContentController,
                  onLongPress: widget.onLongPress,
                ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PagedInfluencerFeedItemListBody extends StatelessWidget {
  final PagingController<int, InfluencerFeedItem> pagingController;
  final Function(int, String)? onReactionsTapped;
  final ValueChanged<int>? onLongPress;

  const _PagedInfluencerFeedItemListBody({
    required this.pagingController,
    this.onReactionsTapped,
    this.onLongPress,
  });

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

    return PagedListView.separated(
      padding: EdgeInsets.only(
        bottom: kBottomNavigationBarHeight + EdgeInsetsFoundation.vertical32,
        top: EdgeInsetsFoundation.vertical16,
      ),
      pagingController: pagingController,
      separatorBuilder: (context, index) => SpacingFoundation.verticalSpace16,
      builderDelegate: PagedChildBuilderDelegate<InfluencerFeedItem>(
        itemBuilder: (context, item, index) {
          final isLast = index == pagingController.itemList!.length - 1;
          double bottomPadding = isLast ? 0 : 16.0;

          if (item is ShufflePostFeedItem) {
            return UiKitContentUpdatesCard.fromShuffle(
              text: item.text,
              heartEyesReactionsCount: item.heartEyesReactionsCount,
              likeReactionsCount: item.likeReactionsCount,
              fireReactionsCount: item.fireReactionsCount,
              sunglassesReactionsCount: item.sunglassesReactionsCount,
              smileyReactionsCount: item.smileyReactionsCount,
              onReactionsTapped: (str) => onReactionsTapped?.call(item.id, str),
              onLongPress: () => onLongPress?.call(item.id),
              children: _children(item, regularTextTheme),
            ).paddingOnly(bottom: EdgeInsetsFoundation.vertical16);
          } else if (item is PostFeedItem) {
            return UiKitPostCard(
              authorName: item.name,
              authorUsername: item.username,
              authorAvatarUrl: item.avatarUrl,
              authorSpeciality: item.speciality,
              authorUserType: item.userType,
              heartEyesCount: item.heartEyesReactionsCount,
              likesCount: item.likeReactionsCount,
              sunglassesCount: item.sunglassesReactionsCount,
              firesCount: item.fireReactionsCount,
              smileyCount: item.smileyReactionsCount,
              text: item.text,
              onReactionsTapped: (str) => onReactionsTapped?.call(item.id, str),
              hasNewMark: item.newMark,
              onLongPress: () => onLongPress?.call(item.id),
            ).paddingOnly(bottom: bottomPadding);
          } else if (item is UpdatesFeedItem) {
            return UiKitContentUpdatesCard(
              authorSpeciality: item.speciality,
              authorName: item.name,
              authorUsername: item.username,
              authorAvatarUrl: item.avatarUrl,
              authorUserType: item.userType,
              onReactionsTapped: (str) => onReactionsTapped?.call(item.id, str),
              onLongPress: () => onLongPress?.call(item.id),
              children: _children(item, regularTextTheme),
            ).paddingOnly(bottom: bottomPadding);
          } else {
            throw UnimplementedError('Unknown item type: ${item.runtimeType}');
          }
        },
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
      if (item is ShufflePostFeedItem && item.videos != null)
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
      if (item.newPhotos != null)
        UiKitStaggeredMediaRow(
          mediaList: item.newPhotos!,
          visibleMediaCount: 4,
        ),
      if (item.newVideos != null)
        ...item.newVideos!.map((video) {
          return UiKitContentUpdateWithLeadingImage(
            title: S.current.PlusXNewVideos,
            iconData: ShuffleUiKitIcons.playoutline,
            imageUrl: video.previewImage,
            subtitle: video.subtitle,
          );
        }),
      if (item.newFeedbacks != null)
        ...item.newFeedbacks!.map((feedback) {
          return UiKitContentUpdateWithLeadingImage(
            imageUrl: feedback.previewImage,
            title: S.current.PlusXNewReviews(item.newFeedbacks!.length),
            iconData: ShuffleUiKitIcons.starfill,
            subtitle: feedback.subtitle,
          );
        }),
      if (item.newVideoReactions != null)
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
      if (item.newRoutes != null)
        ...item.newRoutes!.map((route) {
          return UiKitContentUpdateWithLeadingImage(
            title: S.current.PlusXNewRoutes,
            iconData: route.icon,
            imageUrl: route.thumbnailUrl ?? '',
            subtitle: '${route.routeAPointName} - ${route.routeBPointName}',
          );
        }),
      if (item.newVideoInterviews != null)
        ...item.newVideoInterviews!.map((interview) {
          return UiKitContentUpdateWithLeadingImage(
            title: S.current.PlusXNewInterviews,
            iconData: interview.icon,
            imageUrl: interview.thumbnailUrl ?? '',
            subtitle: interview.title,
          );
        }),
      if (item.newContests != null)
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
      if (item.newPersonalTops != null)
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
      if (item.newPersonalRespects != null)
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
      if (item.newContent != null)
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
