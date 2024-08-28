import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../domain/data_uimodels/influencer_models/influencer_feed_item.dart';

class InfluencersUpdatedFeedComponent extends StatefulWidget {
  final ValueChanged<String>? onTappedTab;
  final PagingController<int, InfluencerFeedItem> latestContentController;
  final PagingController<int, InfluencerFeedItem> topContentController;
  final PagingController<int, InfluencerFeedItem> unreadContentController;

  InfluencersUpdatedFeedComponent({
    Key? key,
    this.onTappedTab,
    required this.latestContentController,
    required this.topContentController,
    required this.unreadContentController,
  }) : super(key: key);

  @override
  State<InfluencersUpdatedFeedComponent> createState() => _InfluencersUpdatedFeedComponentState();
}

class _InfluencersUpdatedFeedComponentState extends State<InfluencersUpdatedFeedComponent>
    with SingleTickerProviderStateMixin {
  late final tabController = TabController(length: 3, vsync: this);

  final _tabs = [
    UiKitCustomTab(title: S.current.Latest, customValue: 'latest'),
    UiKitCustomTab(title: S.current.Top, customValue: 'top'),
    UiKitCustomTab(title: S.current.Unread, customValue: 'unread'),
  ];

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
          ),
          SpacingFoundation.verticalSpace16,
          Expanded(
            // height: 0.85.sh,
            // width: 1.sw,
            child: TabBarView(
              controller: tabController,
              children: [
                _PagedInfluencerFeedItemListBody(pagingController: widget.latestContentController),
                _PagedInfluencerFeedItemListBody(pagingController: widget.topContentController),
                _PagedInfluencerFeedItemListBody(pagingController: widget.unreadContentController),
              ],
            ),
          ),
        ],
      ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
    );
  }
}

class _PagedInfluencerFeedItemListBody extends StatelessWidget {
  final PagingController<int, InfluencerFeedItem> pagingController;
  const _PagedInfluencerFeedItemListBody({
    Key? key,
    required this.pagingController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final regularTextTheme = context.uiKitTheme?.regularTextTheme;

    return PagedListView.separated(
      padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight + EdgeInsetsFoundation.vertical32),
      pagingController: pagingController,
      separatorBuilder: (context, index) => SpacingFoundation.verticalSpace16,
      builderDelegate: PagedChildBuilderDelegate<InfluencerFeedItem>(
        itemBuilder: (context, item, index) {
          final isLast = index == pagingController.itemList!.length - 1;
          double bottomPadding = isLast ? 0 : 16.0;

          if (item is PostFeedItem) {
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
              hasNewMark: item.newMark,
            ).paddingOnly(bottom: bottomPadding);
          } else if (item is UpdatesFeedItem) {
            return UiKitContentUpdatesCard(
              authorSpeciality: item.speciality,
              authorName: item.name,
              authorUsername: item.username,
              authorAvatarUrl: item.avatarUrl,
              authorUserType: item.userType,
              children: [
                if (item.newPhotos != null)
                  UiKitStaggeredMediaRow(
                    mediaList: item.newPhotos!,
                    visibleMediaCount: 4,
                  ),
                if (item.newVideos != null)
                  ...item.newVideos!.map((video) {
                    return UiKitContentUpdateWithLeadingImage(
                      title: S.current.PlusXNewVideos,
                      updateIconUrl: GraphicsFoundation.instance.svg.playOutline.path,
                      imageUrl: video.previewImage,
                      subtitle: video.subtitle,
                    );
                  }),
                if (item.newFeedbacks != null)
                  ...item.newFeedbacks!.map((feedback) {
                    return UiKitContentUpdateWithLeadingImage(
                      imageUrl: feedback.previewImage,
                      title: S.current.PlusXNewReviews(item.newFeedbacks!.length),
                      updateIconUrl: GraphicsFoundation.instance.svg.starFill.path,
                      subtitle: feedback.subtitle,
                    );
                  }),
                if (item.newVideoReactions != null)
                  UiKitCustomChildContentUpdateWidget(
                    height: 0.125.sw * 1.7,
                    child: UiKitContentRowWithHiddenItems(
                      placeholderSize: Size(0.125.sw, 0.125.sw * 1.7),
                      visibleItemsCount: 2,
                      placeholderImagePath: item.newVideoReactions!.first.previewImageUrl ?? '',
                      placeHolderTitle: S.current.PlusXNewVideoReactions(item.newVideoReactions!.length > 2
                          ? item.newVideoReactions!.length - 2
                          : item.newVideoReactions!.length),
                      children: item.newVideoReactions!.map((reaction) {
                        return UiKitReactionPreview(
                          viewed: reaction.isViewed,
                          isEmpty: false,
                          imagePath: reaction.previewImageUrl,
                          customHeight: 0.125.sw * 1.7,
                          customWidth: 0.125.sw,
                        );
                      }).toList(),
                    ),
                  ),
                if (item.newVoices != null && item.newVoices!.isNotEmpty)
                  UiKitContentUpdateWithLeadingImage(
                    title: S.current.PlusXNewVoices(item.newVoices!.length),
                    updateIconUrl: GraphicsFoundation.instance.svg.voice.path,
                    imageUrl: (item.newVoices!.first.content?.media.isNotEmpty ?? false)
                        ? item.newVoices!.first.content?.media.first.link ?? ''
                        : '',
                    subtitle: item.newVoices!.first.content?.title ?? '',
                  ),
                if (item.newRoutes != null)
                  ...item.newRoutes!.map((route) {
                    return UiKitContentUpdateWithLeadingImage(
                      title: S.current.PlusXNewRoutes,
                      updateIconUrl: route.icon,
                      imageUrl: route.thumbnailUrl ?? '',
                      subtitle: '${route.routeAPointName} - ${route.routeBPointName}',
                    );
                  }),
                if (item.newVideoInterviews != null)
                  ...item.newVideoInterviews!.map((interview) {
                    return UiKitContentUpdateWithLeadingImage(
                      title: S.current.PlusXNewInterviews,
                      updateIconUrl: interview.icon,
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
                        customHeight: 0.125.sw * 1.7,
                        customWidth: 0.125.sw,
                      ),
                      height: 0.125.sw * 1.7,
                    );
                  }),
                if (item.newPersonalTops != null)
                  ...item.newPersonalTops!.map((top) {
                    return UiKitContentUpdateWithLeadingImage(
                      title: '${S.current.Top} ${top.title}',
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
                    updateIcon: GraphicsFoundation.instance.svg.message.path,
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
              ],
            ).paddingOnly(bottom: bottomPadding);
          } else {
            throw UnimplementedError('Unknown item type: ${item.runtimeType}');
          }
        },
      ),
    );
  }
}