import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'activity_item_widget.dart';
import 'activity_ui_model.dart';

class ActivityComponent extends StatefulWidget {
  final PagingController<int, ActivityUiModel> myActivityPaginationController;
  final PagingController<int, ActivityUiModel> commonActivityPaginationController;
  final Function(int?, bool)? onItemTap;
  final bool isMyActivity;

  const ActivityComponent({
    super.key,
    required this.myActivityPaginationController,
    required this.commonActivityPaginationController,
    this.onItemTap,
    this.isMyActivity = true,
  });

  @override
  State<ActivityComponent> createState() => _ActivityComponentState();
}

class _ActivityComponentState extends State<ActivityComponent> with TickerProviderStateMixin {
  final autoSizeGroup = AutoSizeGroup();
  late final TabController tabController;

  late final myActivityKey = PageStorageKey('my');
  late final commonActivityKey = PageStorageKey('common');

  late final List<UiKitCustomTab> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      UiKitCustomTab.small(title: S.current.My.toUpperCase(), customValue: 'my', group: autoSizeGroup),
      UiKitCustomTab.small(title: S.current.Common.toUpperCase(), customValue: 'common', group: autoSizeGroup),
    ];
    int selectedTabIndex = _tabs.indexWhere((tab) => tab.customValue == (widget.isMyActivity ? 'my' : 'common'));
    tabController = TabController(length: 2, vsync: this, initialIndex: selectedTabIndex);
  }

  @override
  Widget build(BuildContext context) {
    return BlurredAppBarPage(
      title: S.current.WheresTheActivity,
      autoImplyLeading: true,
      physics: NeverScrollableScrollPhysics(),
      centerTitle: true,
      expandTitle: false,
      children: [
        UiKitCustomTabBar(
          tabController: tabController,
          tabs: _tabs,
          clipBorderRadius: BorderRadiusFoundation.all24r,
          onTappedTab: (index) {},
        ).paddingSymmetric(
          horizontal: SpacingFoundation.horizontalSpacing16,
          vertical: SpacingFoundation.verticalSpacing16,
        ),
        SizedBox(
          height: 0.75.sh,
          child: TabBarView(
            controller: tabController,
            children: [
              PagedListView.separated(
                key: myActivityKey,
                padding: EdgeInsets.only(
                    bottom: SpacingFoundation.verticalSpacing24 + MediaQuery.viewInsetsOf(context).bottom),
                pagingController: widget.myActivityPaginationController,
                separatorBuilder: (context, index) => SpacingFoundation.verticalSpace16,
                builderDelegate: PagedChildBuilderDelegate<ActivityUiModel>(
                  itemBuilder: (context, item, index) {
                    return GestureDetector(
                      onTap: () => widget.onItemTap?.call(item.eventId ?? item.placeId ?? -1, item.eventId != null),
                      child: ActivityItemWidget(
                        activityUiModel: item,
                      ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16),
                    );
                  },
                ),
              ),
              PagedListView.separated(
                key: commonActivityKey,
                padding: EdgeInsets.only(
                    bottom: SpacingFoundation.verticalSpacing24 + MediaQuery.viewInsetsOf(context).bottom),
                pagingController: widget.commonActivityPaginationController,
                separatorBuilder: (context, index) => SpacingFoundation.verticalSpace16,
                builderDelegate: PagedChildBuilderDelegate<ActivityUiModel>(
                  itemBuilder: (context, item, index) {
                    return GestureDetector(
                      onTap: () => widget.onItemTap?.call(item.eventId ?? item.placeId ?? -1, item.eventId != null),
                      child: ActivityItemWidget(
                        activityUiModel: item,
                      ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16),
                    );
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
