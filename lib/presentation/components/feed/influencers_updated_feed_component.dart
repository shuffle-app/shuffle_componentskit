import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../domain/data_uimodels/influencer_models/influencer_feed_item.dart';

class InfluencersUpdatedFeedComponent extends StatelessWidget {
  final ValueChanged<String>? onTappedTab;
  final PagingController<int, InfluencerFeedItem> latestContentController;
  final PagingController<int, InfluencerFeedItem> topContentController;
  final PagingController<int, InfluencerFeedItem> unreadContentController;
  final TabController tabController;

  InfluencersUpdatedFeedComponent({
    Key? key,
    this.onTappedTab,
    required this.latestContentController,
    required this.topContentController,
    required this.unreadContentController,
    required this.tabController,
  }) : super(key: key);

  final _tabs = [
    UiKitCustomTab(title: S.current.Latest, customValue: 'latest'),
    UiKitCustomTab(title: S.current.Top, customValue: 'top'),
    UiKitCustomTab(title: S.current.Unread, customValue: 'unread'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SpacingFoundation.verticalSpace16,
        UiKitCustomTabBar(
          tabController: tabController,
          tabs: _tabs,
          onTappedTab: (index) => onTappedTab,
        ),
        SizedBox(
          height: 0.8.sh,
          width: 1.sw,
          child: TabBarView(
            controller: tabController,
            children: [
              _PagedInfluencerFeedItemListBody(pagingController: latestContentController),
              _PagedInfluencerFeedItemListBody(pagingController: topContentController),
              _PagedInfluencerFeedItemListBody(pagingController: unreadContentController),
            ],
          ),
        ),
        SpacingFoundation.verticalSpace24,
      ],
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
    return PagedListView.separated(
      pagingController: pagingController,
      separatorBuilder: (context, index) => SpacingFoundation.verticalSpace16,
      builderDelegate: PagedChildBuilderDelegate<InfluencerFeedItem>(
        itemBuilder: (context, item, index) {
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
            );
          }
          return UiKitContentUpdatesCard(
            authorSpeciality: item.speciality,
            authorName: item.name,
            authorUsername: item.username,
            authorAvatarUrl: item.avatarUrl,
            authorUserType: item.userType,
            children: [],
          );
        },
      ),
    );
  }
}
