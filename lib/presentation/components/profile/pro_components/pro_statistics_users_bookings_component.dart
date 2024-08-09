import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class ProStatisticsUsersBookingsComponent extends StatelessWidget {
  final DateRange dateRange;
  final TabController tabController;
  final PagingController<int, BaseUiKitUserTileData> bookingUsersPaginationController;
  final PagingController<int, BaseUiKitUserTileData> favoritesUsersPaginationController;
  final String? reminderStatusString;
  final ValueChanged<String>? onTappedTab;
  final VoidCallback? onCreateReminder;
  final VoidCallback? onShowReminders;

  final _tabs = [
    UiKitCustomTab(title: S.current.BookingsHeading.toUpperCase(), customValue: 'booking'),
    UiKitCustomTab(title: S.current.Favorites.toUpperCase(), customValue: 'favorites'),
  ];

  ProStatisticsUsersBookingsComponent({
    Key? key,
    required this.dateRange,
    required this.tabController,
    required this.bookingUsersPaginationController,
    required this.favoritesUsersPaginationController,
    this.reminderStatusString,
    this.onTappedTab,
    this.onCreateReminder,
    this.onShowReminders,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;
    final colorScheme = context.uiKitTheme?.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${formatDateWithCustomPattern('MMM d', dateRange.start)} - ${formatDateWithCustomPattern('MMM d', dateRange.end)}',
          style: boldTextTheme?.caption2Medium.copyWith(color: ColorsFoundation.mutedText),
          textAlign: TextAlign.end,
        ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
        SpacingFoundation.verticalSpace2,
        UiKitCustomTabBar(
          tabs: _tabs,
          tabController: tabController,
          onTappedTab: (index) {
            final value = _tabs[index].customValue;
            if (value != null) onTappedTab?.call(value);
          },
        ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
        SpacingFoundation.verticalSpace16,
        if (reminderStatusString != null)
          UiKitCardWrapper(
            color: colorScheme?.surface2,
            padding: EdgeInsets.all(EdgeInsetsFoundation.all16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  reminderStatusString!,
                  style: boldTextTheme?.caption1Medium,
                ),
                SpacingFoundation.verticalSpace8,
                context.smallButton(
                  data: BaseUiKitButtonData(
                    text: onCreateReminder != null ? S.current.Reminder : S.current.SeeMore,
                    fit: ButtonFit.fitWidth,
                    onPressed: onCreateReminder ?? onShowReminders,
                  ),
                ),
              ],
            ),
          ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
        SizedBox(
          height: onCreateReminder != null ? 0.55.sh : 0.5.sh,
          child: TabBarView(
            controller: tabController,
            children: [
              PagedListView.separated(
                padding: EdgeInsets.all(EdgeInsetsFoundation.all16),
                pagingController: bookingUsersPaginationController,
                separatorBuilder: (context, index) => SpacingFoundation.verticalSpace16,
                builderDelegate: PagedChildBuilderDelegate<BaseUiKitUserTileData>(
                  itemBuilder: (context, item, index) => UiKitPopUpMenuTile(
                    title: item.name ?? '',
                    titleIcon: item.type == UserTileType.pro
                        ? ProAccountMark()
                        : item.type == UserTileType.influencer
                            ? InfluencerAccountMark()
                            : null,
                    leading: context.userAvatar(
                      size: UserAvatarSize.x40x40,
                      type: item.type ?? UserTileType.ordinary,
                      userName: item.username ?? '',
                      imageUrl: item.avatarUrl,
                    ),
                    subtitle: item.username,
                  ),
                  firstPageProgressIndicatorBuilder: (context) => Column(
                    children: List.generate(
                      10,
                      (index) => UiKitShimmerProgressIndicator(
                        gradient: GradientFoundation.shunyGreyGradient,
                        child: ClipRRect(
                          borderRadius: BorderRadiusFoundation.all24,
                          child: Container(
                            height: 0.1.sh,
                            width: 1.sw,
                            color: colorScheme?.inverseSurface,
                          ),
                        ),
                      ).paddingOnly(bottom: EdgeInsetsFoundation.vertical16),
                    ),
                  ),
                  newPageProgressIndicatorBuilder: (context) => UiKitShimmerProgressIndicator(
                    gradient: GradientFoundation.shunyGreyGradient,
                    child: ClipRRect(
                      borderRadius: BorderRadiusFoundation.all24,
                      child: Container(
                        height: 0.1.sh,
                        width: 1.sw,
                        color: colorScheme?.inverseSurface,
                      ),
                    ),
                  ),
                ),
              ),
              PagedListView.separated(
                padding: EdgeInsets.all(EdgeInsetsFoundation.all16),
                pagingController: favoritesUsersPaginationController,
                builderDelegate: PagedChildBuilderDelegate<BaseUiKitUserTileData>(
                  itemBuilder: (context, item, index) => UiKitPopUpMenuTile(
                    title: item.name ?? '',
                    titleIcon: item.type == UserTileType.pro
                        ? ProAccountMark()
                        : item.type == UserTileType.influencer
                            ? InfluencerAccountMark()
                            : null,
                    leading: context.userAvatar(
                      size: UserAvatarSize.x40x40,
                      type: item.type ?? UserTileType.ordinary,
                      userName: item.username ?? '',
                      imageUrl: item.avatarUrl,
                    ),
                    subtitle: item.username,
                  ),
                  firstPageProgressIndicatorBuilder: (context) => Column(
                    children: List.generate(
                      10,
                      (index) => UiKitShimmerProgressIndicator(
                        gradient: GradientFoundation.shunyGreyGradient,
                        child: ClipRRect(
                          borderRadius: BorderRadiusFoundation.all24,
                          child: Container(
                            height: 0.1.sh,
                            width: 1.sw,
                            color: colorScheme?.inverseSurface,
                          ),
                        ),
                      ).paddingOnly(bottom: EdgeInsetsFoundation.vertical16),
                    ),
                  ),
                  newPageProgressIndicatorBuilder: (context) => UiKitShimmerProgressIndicator(
                    gradient: GradientFoundation.shunyGreyGradient,
                    child: ClipRRect(
                      borderRadius: BorderRadiusFoundation.all24,
                      child: Container(
                        height: 0.1.sh,
                        width: 1.sw,
                        color: colorScheme?.inverseSurface,
                      ),
                    ),
                  ),
                ),
                separatorBuilder: (context, index) => SpacingFoundation.verticalSpace16,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
