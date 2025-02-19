import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/domain/data_uimodels/unique_statistics_model.dart';
import 'package:shuffle_components_kit/presentation/components/event/uievent_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';

final AutoSizeGroup _group = AutoSizeGroup();

class ProStatisticsComponent extends StatelessWidget {
  final UniqueStatisticsModel? uniqueStatisticsModel;
  final UiKitLineChartData<num>? viewsAndVisitorsStat;
  final UiKitLineChartAdditionalData? viewsAndVisitorsAdditionalData;
  final UiKitLineChartData<num>? feedbackStats;
  final UiKitLineChartData<num>? bookingAndFavorites;
  final UiKitLineChartData<num>? invites;
  final List<UiKitMiniChartData>? miniChartData;
  final TabController tabController;
  final ValueChanged<String?>? onTabTapped;
  final ValueChanged<UiEventModel>? onEventTapped;
  final VoidCallback? onFeedbackStatActionTapped;
  final bool loadingVisitorsStatistics;
  final ValueChanged<String>? onStatisticsPopupMenuItemTapped;
  final List<UiEventModel>? events;
  final VoidCallback? onAdvertisingShowTap;
  final int? noShows;
  final int? showUp;

  /// bring back tabs when needed
  // final _tabs = [
  //   CustomTabData(title: S.current.GeneraFem, customValue: 'general'),
  //   CustomTabData(title: S.current.OrganicStatistics, customValue: 'organic'),
  //   CustomTabData(title: S.current.Promotion, customValue: 'promotion'),
  // ];

  const ProStatisticsComponent({
    super.key,
    this.uniqueStatisticsModel,
    this.viewsAndVisitorsStat,
    this.feedbackStats,
    this.bookingAndFavorites,
    this.invites,
    this.miniChartData,
    required this.tabController,
    this.viewsAndVisitorsAdditionalData,
    this.onTabTapped,
    this.onFeedbackStatActionTapped,
    this.loadingVisitorsStatistics = false,
    this.onStatisticsPopupMenuItemTapped,
    this.events,
    this.onEventTapped,
    this.onAdvertisingShowTap,
    this.noShows,
    this.showUp,
  });

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;
    final colorScheme = context.uiKitTheme?.colorScheme;

    return BlurredAppBarPage(
      centerTitle: true,
      title: S.current.Statistics,
      autoImplyLeading: true,
      childrenPadding: EdgeInsets.symmetric(horizontal: EdgeInsetsFoundation.horizontal16),
      children: [
        SpacingFoundation.verticalSpace16,
        // UiKitTabBarWithUnderlineIndicator(
        //   tabController: tabController,
        //   onTappedTab: (index) => onTabTapped?.call(_tabs.elementAtOrNull(index)?.customValue),
        //   tabs: _tabs,
        // ),
        // SpacingFoundation.verticalSpace16,
        if (viewsAndVisitorsStat != null)
          UiKitLineChart(
            key: ValueKey(viewsAndVisitorsStat),
            loading: loadingVisitorsStatistics,
            chartData: viewsAndVisitorsStat!.copyWith(
              popUpMenuOptions: [
                S.current.Settings,
                S.current.DownloadPdf,
              ],
            ),
            popUpMenuItemSelected: onStatisticsPopupMenuItemTapped,
            chartAdditionalData: viewsAndVisitorsAdditionalData,
          ),
        SpacingFoundation.verticalSpace16,
        if (feedbackStats != null)
          UiKitLineChart(
            loading: loadingVisitorsStatistics,
            key: ValueKey(feedbackStats),
            chartData: feedbackStats!,
          ),
        SpacingFoundation.verticalSpace16,
        if (noShows != null || showUp != null)
          UiKitCardWrapper(
            color: colorScheme?.surface3,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: UiKitNoShowStatisticCard(
                        percent: noShows,
                        group: _group,
                      ),
                    ),
                    SpacingFoundation.horizontalSpace8,
                    Expanded(
                      child: UiKitNoShowStatisticCard(
                        percent: showUp,
                        isNoShows: false,
                        group: _group,
                      ),
                    ),
                  ],
                ),
                SpacingFoundation.verticalSpace8,
                UiKitAdvertisingShowCard(
                  isBigShowUpPercent: (showUp ?? 0) >= 70,
                  onTap: onAdvertisingShowTap,
                ),
              ],
            ).paddingAll(EdgeInsetsFoundation.all16),
          ).paddingOnly(bottom: SpacingFoundation.verticalSpacing16),
        if (bookingAndFavorites != null)
          UiKitLineChart(
            loading: loadingVisitorsStatistics,
            key: ValueKey(bookingAndFavorites),
            chartData: bookingAndFavorites!,
            action: onFeedbackStatActionTapped,
          ),
        SpacingFoundation.verticalSpace16,
        if (invites != null)
          UiKitLineChart(
            loading: loadingVisitorsStatistics,
            key: ValueKey(invites),
            chartData: invites!,
          ),
        SpacingFoundation.verticalSpace16,
        if (miniChartData != null)
          UiKitCardWrapper(
            color: colorScheme?.surface3,
            padding: EdgeInsets.all(EdgeInsetsFoundation.all16),
            child: UiKitMiniChart(data: miniChartData!),
          ),
        SpacingFoundation.verticalSpace16,
        Text(
          S.current.UniqueStatistics,
          style: boldTextTheme?.title1,
        ),
        SpacingFoundation.verticalSpace16,
        if (uniqueStatisticsModel != null)
          UiKitCardWrapper(
            color: colorScheme?.surface3,
            padding: EdgeInsets.all(EdgeInsetsFoundation.all16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UiKitGlowingProgressIndicator(
                  maxWidth: 1.sw - 16,
                  progressColor: ColorsFoundation.warning,
                  maxValue: uniqueStatisticsModel!.ratingBarProgress.maxValue,
                  value: uniqueStatisticsModel!.ratingBarProgress.value,
                  title: uniqueStatisticsModel!.ratingBarProgress.title,
                ),
                UiKitRoundedDivider(
                  thickness: 2,
                  height: SpacingFoundation.verticalSpacing32,
                ),
                UiKitVerticalTitledInfoBoard(
                  title: S.current.MostActiveAgeSegment,
                  infoList: [
                    TitledInfoModel(
                      title: S.current.Gender,
                      info: uniqueStatisticsModel!.mostActiveAgeSegment.gender,
                    ),
                    TitledInfoModel(
                      title: S.current.Age,
                      info: uniqueStatisticsModel!.mostActiveAgeSegment.name,
                    ),
                    TitledInfoModel(
                      title: S.current.Interests,
                      info: uniqueStatisticsModel!.mostActiveAgeSegment.interests.join(', '),
                    ),
                  ],
                ),
                UiKitRoundedDivider(
                  thickness: 2,
                  height: SpacingFoundation.verticalSpacing32,
                ),
                Text(
                  S.current.ViewSources,
                  style: boldTextTheme?.caption2Medium.copyWith(color: ColorsFoundation.mutedText),
                ),
                SpacingFoundation.verticalSpace2,
                SizedBox(
                  height: 0.275625.sw,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 4,
                        child: UiKitPieChart(
                          data: uniqueStatisticsModel!.viewSourcesData,
                          renderHeight: 0.275625.sw,
                        ),
                      ),
                      SpacingFoundation.horizontalSpace24,
                      Expanded(
                        flex: 8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: uniqueStatisticsModel!.viewSourcesData.legend
                              .map<Widget>(
                                (legendItem) => UiKitChartLegendWidget(
                                  valueTitle: legendItem.title,
                                  value: legendItem.value,
                                  leading: Container(
                                    width: SpacingFoundation.verticalSpacing8,
                                    height: SpacingFoundation.verticalSpacing8,
                                    decoration: BoxDecoration(
                                      color: legendItem.color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ).paddingSymmetric(vertical: EdgeInsetsFoundation.vertical2),
                      ),
                    ],
                  ),
                ),
                // UiKitRoundedDivider(
                //   thickness: 2,
                //   height: SpacingFoundation.verticalSpacing32,
                // ),
                // if (uniqueStatisticsModel.topEventTitles != null && uniqueStatisticsModel.topEventsDate != null)
                //   UiKitRankedTitledBoard(
                //     title: S.current.TopEventsFor(
                //       formatDateWithCustomPattern('MMMM dd', uniqueStatisticsModel.topEventsDate!),
                //     ),
                //     rankItems: uniqueStatisticsModel.topEventTitles!,
                //   ),
                // if (uniqueStatisticsModel.topEventTitles != null && uniqueStatisticsModel.topEventsDate != null)
                //   UiKitRoundedDivider(
                //     thickness: 2,
                //     height: SpacingFoundation.verticalSpacing32,
                //   ),
                // UiKitGlowingProgressIndicator(
                //   maxWidth: 1.sw - 16,
                //   progressColor: ColorsFoundation.success,
                //   maxValue: uniqueStatisticsModel.interestBarProgress.maxValue,
                //   value: uniqueStatisticsModel.interestBarProgress.value,
                //   title: uniqueStatisticsModel.interestBarProgress.title,
                // ),
              ],
            ),
          ),
        if (events != null && events!.isNotEmpty)
          Text(
            S.current.Events,
            style: boldTextTheme?.title1,
            textAlign: TextAlign.start,
          ).paddingSymmetric(vertical: EdgeInsetsFoundation.vertical16),
        if (events != null && events!.isNotEmpty)
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final event = events!.elementAt(index);

              return UiKitContentPreviewTile(
                avatarPath: event.verticalPreview?.link ?? event.owner?.logo,
                title: event.title ?? '',
                subtitle: event.eventType?.title,
                onTap: () => onEventTapped?.call(event),
              );
            },
            separatorBuilder: (context, index) => SpacingFoundation.verticalSpace16,
            itemCount: events!.length,
          ),
        SpacingFoundation.verticalSpace24,
      ],
    );
  }
}
