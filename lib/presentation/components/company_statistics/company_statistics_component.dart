import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/domain/data_uimodels/unique_statistics_model.dart';
import 'package:shuffle_components_kit/presentation/components/event/uievent_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../place/uiplace_model.dart';

class CompanyStatisticsComponent extends StatefulWidget {
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
  final ValueChanged<UiPlaceModel>? onPlaceTapped;
  final VoidCallback? onFeedbackStatActionTapped;
  final bool loadingVisitorsStatistics;
  final ValueChanged<String>? onStatisticsPopupMenuItemTapped;
  final List<UiEventModel>? events;
  final List<UiPlaceModel>? places;

  const CompanyStatisticsComponent({
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
    this.places,
    this.onEventTapped,
    this.onPlaceTapped,
  });

  @override
  State<CompanyStatisticsComponent> createState() => _CompanyStatisticsComponentState();
}

class _CompanyStatisticsComponentState extends State<CompanyStatisticsComponent> {
  final _contentTabs = [
    UiKitCustomTab(title: S.current.Places.toUpperCase(), customValue: 'places'),
    UiKitCustomTab(title: S.current.Events.toUpperCase(), customValue: 'events'),
  ];

  String selectedContentTab = 'places';

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;
    final colorScheme = context.uiKitTheme?.colorScheme;
    TextStyle? textStyle = boldTextTheme?.title1 ?? Theme.of(context).primaryTextTheme.titleMedium;
    textStyle = textStyle?.copyWith(color: colorScheme?.inversePrimary);

    return BlurredAppBarPage(
      customTitle: Expanded(
        child: AutoSizeText(
          S.current.Statistics,
          maxLines: 1,
          style: textStyle,
          textAlign: TextAlign.center,
        ),
      ),
      expandTitle: true,
      childrenPadding: EdgeInsets.symmetric(horizontal: EdgeInsetsFoundation.horizontal16),
      children: [
        SpacingFoundation.verticalSpace16,
        // UiKitTabBarWithUnderlineIndicator(
        //   tabController: widget.tabController,
        //   onTappedTab: (index) => widget.onTabTapped?.call(_chartTabs.elementAtOrNull(index)?.customValue),
        //   tabs: _chartTabs,
        // ),
        // SpacingFoundation.verticalSpace16,
        if (widget.viewsAndVisitorsStat != null)
          UiKitLineChart(
            loading: widget.loadingVisitorsStatistics,
            chartData: widget.viewsAndVisitorsStat!.copyWith(
              popUpMenuOptions: [
                S.current.Settings,
                S.current.DownloadPdf,
              ],
            ),
            popUpMenuItemSelected: widget.onStatisticsPopupMenuItemTapped,
            chartAdditionalData: widget.viewsAndVisitorsAdditionalData,
          ),
        SpacingFoundation.verticalSpace16,
        if (widget.feedbackStats != null)
          UiKitLineChart(
            chartData: widget.feedbackStats!,
          ),
        SpacingFoundation.verticalSpace16,
        if (widget.bookingAndFavorites != null)
          UiKitLineChart(
            chartData: widget.bookingAndFavorites!,
            action: widget.onFeedbackStatActionTapped,
          ),
        SpacingFoundation.verticalSpace16,
        if (widget.invites != null)
          UiKitLineChart(
            chartData: widget.invites!,
          ),
        SpacingFoundation.verticalSpace16,
        if (widget.miniChartData != null)
          UiKitCardWrapper(
            color: colorScheme?.surface3,
            padding: EdgeInsets.all(EdgeInsetsFoundation.all16),
            child: UiKitMiniChart(data: widget.miniChartData!),
          ),
        SpacingFoundation.verticalSpace16,
        Text(
          S.current.UniqueStatistics,
          style: boldTextTheme?.title1,
        ),
        SpacingFoundation.verticalSpace16,
        if (widget.uniqueStatisticsModel != null)
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
                  maxValue: widget.uniqueStatisticsModel!.ratingBarProgress.maxValue,
                  value: widget.uniqueStatisticsModel!.ratingBarProgress.value,
                  title: widget.uniqueStatisticsModel!.ratingBarProgress.title,
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
                      info: widget.uniqueStatisticsModel!.mostActiveAgeSegment.gender,
                    ),
                    TitledInfoModel(
                      title: S.current.Age,
                      info: widget.uniqueStatisticsModel!.mostActiveAgeSegment.name,
                    ),
                    TitledInfoModel(
                      title: S.current.Interests,
                      info: widget.uniqueStatisticsModel!.mostActiveAgeSegment.interests.join(', '),
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
                        child: UiKitPieChart(data: widget.uniqueStatisticsModel!.viewSourcesData),
                      ),
                      SpacingFoundation.horizontalSpace24,
                      Expanded(
                        flex: 8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: widget.uniqueStatisticsModel!.viewSourcesData.legend
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
                // if (widget.uniqueStatisticsModel.topEventsDate != null &&
                //     widget.uniqueStatisticsModel.topEventTitles != null)
                //   UiKitRankedTitledBoard(
                //     title: S.current.TopEventsFor(
                //       formatDateWithCustomPattern('MMMM dd', widget.uniqueStatisticsModel.topEventsDate!),
                //     ),
                //     rankItems: widget.uniqueStatisticsModel.topEventTitles!,
                //   ),
                // if (widget.uniqueStatisticsModel.topEventsDate != null &&
                //     widget.uniqueStatisticsModel.topEventTitles != null)
                //   UiKitRoundedDivider(
                //     thickness: 2,
                //     height: SpacingFoundation.verticalSpacing32,
                //   ),
                // UiKitGlowingProgressIndicator(
                //   maxWidth: 1.sw - 16,
                //   progressColor: ColorsFoundation.success,
                //   maxValue: widget.uniqueStatisticsModel.interestBarProgress.maxValue,
                //   value: widget.uniqueStatisticsModel.interestBarProgress.value,
                //   title: widget.uniqueStatisticsModel.interestBarProgress.title,
                // ),
              ],
            ),
          ),
        SpacingFoundation.verticalSpace16,
        UiKitCustomTabBar(
          tabs: _contentTabs,
          onTappedTab: (index) => setState(
            () => selectedContentTab = _contentTabs.elementAtOrNull(index)?.customValue ?? 'events',
          ),
        ),
        SpacingFoundation.verticalSpace16,
        if (widget.places != null && widget.places!.isNotEmpty && selectedContentTab == 'places')
          ListView.separated(
            key: ValueKey(widget.places),
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final place = widget.places!.elementAt(index);

              return UiKitContentPreviewTile(
                avatarPath: place.logo,
                title: place.title ?? '',
                subtitle: place.location,
                onTap: () => widget.onPlaceTapped?.call(place),
              );
            },
            separatorBuilder: (context, index) => SpacingFoundation.verticalSpace16,
            itemCount: widget.places!.length,
          ),
        if (widget.events != null && widget.events!.isNotEmpty && selectedContentTab == 'events')
          ListView.separated(
            key: ValueKey(widget.events),
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final event = widget.events!.elementAt(index);

              return UiKitContentPreviewTile(
                avatarPath: event.verticalPreview?.link ?? event.owner?.logo,
                title: event.title ?? '',
                subtitle: event.eventType?.title,
                onTap: () => widget.onEventTapped?.call(event),
              );
            },
            separatorBuilder: (context, index) => SpacingFoundation.verticalSpace16,
            itemCount: widget.events!.length,
          ),
        SpacingFoundation.bottomNavigationBarSpacing,
      ],
    );
  }
}
