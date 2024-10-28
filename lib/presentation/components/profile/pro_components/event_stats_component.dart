import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class ContentStatisticsComponent extends StatelessWidget {
  final TabController tabController;
  final UniqueStatisticsModel uniqueStatisticsModel;
  final UiKitLineChartData<num> viewsAndVisitorsStat;
  final UiKitLineChartAdditionalData? viewsAndVisitorsAdditionalData;
  final UiKitLineChartData<num> feedbackStats;
  final UiKitLineChartData<num> bookingAndFavorites;
  final UiKitLineChartData<num> invites;
  final List<UiKitMiniChartData> miniChartData;
  final ValueChanged<String?>? onTabTapped;
  final VoidCallback? onFeedbackStatActionTapped;
  final bool loadingVisitorsStatistics;
  final ValueChanged<String>? onStatisticsPopupMenuItemTapped;
  final UiPlaceModel? place;
  final UiEventModel? event;

  String get title => place?.title ?? event?.title ?? '';

  // final _tabs = [
  //   CustomTabData(title: S.current.GeneraFem, customValue: 'general'),
  //   CustomTabData(title: S.current.OrganicStatistics, customValue: 'organic'),
  //   CustomTabData(title: S.current.Promotion, customValue: 'promotion'),
  // ];

  const ContentStatisticsComponent({
    super.key,
    required this.uniqueStatisticsModel,
    required this.viewsAndVisitorsStat,
    required this.feedbackStats,
    required this.bookingAndFavorites,
    required this.invites,
    required this.miniChartData,
    required this.tabController,
    this.viewsAndVisitorsAdditionalData,
    this.onTabTapped,
    this.onFeedbackStatActionTapped,
    this.loadingVisitorsStatistics = false,
    this.onStatisticsPopupMenuItemTapped,
    this.place,
    this.event,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final boldTextTheme = theme?.boldTextTheme;
    final colorScheme = theme?.colorScheme;
    // final linesCount = title.length / 15;

    TextStyle? textStyle = theme?.boldTextTheme.title1 ?? Theme.of(context).primaryTextTheme.titleMedium;
    textStyle = textStyle?.copyWith(color: theme?.colorScheme.inversePrimary);

    return BlurredAppBarPage(
      centerTitle: true,
      customTitle: Expanded(child: AutoSizeText(title, maxLines: 1, style: textStyle)),
      customToolbarBaseHeight: 100,
      autoImplyLeading: true,
      canFoldAppBar: false,
      expandTitle: true,
      // customToolbarBaseHeight: linesCount > 1
      //     ? 0.125.sh
      //     : linesCount >= 2
      //         ? 0.175
      //         : null,
      childrenPadding: EdgeInsets.symmetric(horizontal: EdgeInsetsFoundation.horizontal16),
      children: [
        SpacingFoundation.verticalSpace16,
        // UiKitTabBarWithUnderlineIndicator(
        //   tabController: tabController,
        //   onTappedTab: (index) => onTabTapped?.call(_tabs.elementAtOrNull(index)?.customValue),
        //   tabs: _tabs,
        // ),
        // SpacingFoundation.verticalSpace16,
        UiKitLineChart(
          loading: loadingVisitorsStatistics,
          chartData: viewsAndVisitorsStat,
          popUpMenuItemSelected: onStatisticsPopupMenuItemTapped,
          chartAdditionalData: viewsAndVisitorsAdditionalData,
        ),
        SpacingFoundation.verticalSpace16,
        UiKitLineChart(
          chartData: feedbackStats,
        ),
        SpacingFoundation.verticalSpace16,
        UiKitLineChart(
          chartData: bookingAndFavorites,
          action: onFeedbackStatActionTapped,
        ),
        SpacingFoundation.verticalSpace16,
        UiKitLineChart(
          chartData: invites,
        ),
        SpacingFoundation.verticalSpace16,
        UiKitCardWrapper(
          color: colorScheme?.surface3,
          padding: EdgeInsets.all(EdgeInsetsFoundation.all16),
          child: UiKitMiniChart(data: miniChartData),
        ),
        SpacingFoundation.verticalSpace16,
        Text(
          S.current.UniqueStatistics,
          style: boldTextTheme?.title1,
        ),
        SpacingFoundation.verticalSpace16,
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
                maxValue: uniqueStatisticsModel.ratingBarProgress.maxValue,
                value: uniqueStatisticsModel.ratingBarProgress.value,
                title: uniqueStatisticsModel.ratingBarProgress.title,
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
                    info: uniqueStatisticsModel.mostActiveAgeSegment.gender,
                  ),
                  TitledInfoModel(
                    title: S.current.Age,
                    info: uniqueStatisticsModel.mostActiveAgeSegment.name,
                  ),
                  TitledInfoModel(
                    title: S.current.Interests,
                    info: uniqueStatisticsModel.mostActiveAgeSegment.interests.join(', '),
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
                      child: UiKitPieChart(data: uniqueStatisticsModel.viewSourcesData),
                    ),
                    SpacingFoundation.horizontalSpace24,
                    Expanded(
                      flex: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: mockPieChart.legend
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
              UiKitRoundedDivider(
                thickness: 2,
                height: SpacingFoundation.verticalSpacing32,
              ),
              if (uniqueStatisticsModel.topEventTitles != null && uniqueStatisticsModel.topEventsDate != null)
                UiKitRankedTitledBoard(
                  title: S.current.TopEventsFor(
                    formatDateWithCustomPattern('MMMM dd', uniqueStatisticsModel.topEventsDate!),
                  ),
                  rankItems: uniqueStatisticsModel.topEventTitles!,
                ),
              if (uniqueStatisticsModel.topEventTitles != null && uniqueStatisticsModel.topEventsDate != null)
                UiKitRoundedDivider(
                  thickness: 2,
                  height: SpacingFoundation.verticalSpacing32,
                ),
              UiKitGlowingProgressIndicator(
                maxWidth: 1.sw - 16,
                progressColor: ColorsFoundation.success,
                maxValue: uniqueStatisticsModel.interestBarProgress.maxValue,
                value: uniqueStatisticsModel.interestBarProgress.value,
                title: uniqueStatisticsModel.interestBarProgress.title,
              ),
            ],
          ),
        ),
        SpacingFoundation.bottomNavigationBarSpacing,
      ],
    );
  }
}
