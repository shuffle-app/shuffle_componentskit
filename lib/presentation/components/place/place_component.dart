import 'dart:async';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PlaceComponent extends StatefulWidget {
  final UiPlaceModel place;
  final bool isCreateEventAvaliable;
  final VoidCallback? onEventCreate;
  final AsyncCallback? onAddReactionTapped;
  final Future<List<UiEventModel>>? events;
  final ComplaintFormComponent? complaintFormComponent;
  final ValueChanged<UiEventModel>? onEventTap;
  final VoidCallback? onSharePressed;
  final PagedLoaderCallback<VideoReactionUiModel> placeReactionLoaderCallback;
  final PagedLoaderCallback<VideoReactionUiModel> eventReactionLoaderCallback;
  final PagedLoaderCallback<FeedbackUiModel> placeFeedbackLoaderCallback;
  final PagedLoaderCallback<FeedbackUiModel> eventFeedbackLoaderCallback;
  final ValueChanged<VideoReactionUiModel>? onReactionTap;
  final ValueChanged<FeedbackUiModel>? onFeedbackTap;
  final AsyncCallback? onAddFeedbackTapped;
  final bool canLeaveFeedback;
  final bool canLeaveVideoReaction;
  final ValueChanged<int>? onLikedFeedback;
  final ValueChanged<int>? onDislikedFeedback;

  const PlaceComponent({
    super.key,
    required this.place,
    required this.placeReactionLoaderCallback,
    required this.eventReactionLoaderCallback,
    required this.placeFeedbackLoaderCallback,
    required this.eventFeedbackLoaderCallback,
    this.onFeedbackTap,
    this.onReactionTap,
    this.onAddFeedbackTapped,
    this.complaintFormComponent,
    this.isCreateEventAvaliable = false,
    this.onEventCreate,
    this.onAddReactionTapped,
    this.onEventTap,
    this.onSharePressed,
    this.events,
    this.canLeaveFeedback = false,
    this.onLikedFeedback,
    this.onDislikedFeedback,
    this.canLeaveVideoReaction = false,
  });

  @override
  State<PlaceComponent> createState() => _PlaceComponentState();
}

class _PlaceComponentState extends State<PlaceComponent> {
  final reactionsPagingController = PagingController<int, VideoReactionUiModel>(firstPageKey: 1);

  final feedbacksPagedController = PagingController<int, FeedbackUiModel>(firstPageKey: 1);

  List<int> likedReviews = List<int>.empty(growable: true);

  final ScrollController listViewController = ScrollController();

  bool get _noFeedbacks => feedbacksPagedController.itemList?.isEmpty ?? true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _reactionsListener(1);
      reactionsPagingController.addPageRequestListener(_reactionsListener);
      _feedbacksListener(1);
      feedbacksPagedController.addPageRequestListener(_feedbacksListener);
    });
  }

  void _reactionsListener(int page) async {
    final data = await widget.placeReactionLoaderCallback(page, widget.place.id);

    if (data.isEmpty) {
      reactionsPagingController.appendLastPage(data);
      return;
    }
    if (data.last.empty) {
      data.removeLast();
      reactionsPagingController.appendLastPage(data);
    } else {
      if (data.length < 10) {
        reactionsPagingController.appendLastPage(data);
      } else {
        reactionsPagingController.appendPage(data, page + 1);
      }
    }
  }

  void _updateFeedbackList(int feedbackId, int addValue) {
    final updatedFeedbackIndex = feedbacksPagedController.itemList?.indexWhere((element) => element.id == feedbackId);
    if (updatedFeedbackIndex != null && updatedFeedbackIndex >= 0) {
      final updatedFeedback = feedbacksPagedController.itemList?.removeAt(updatedFeedbackIndex);
      if (updatedFeedback != null) {
        feedbacksPagedController.itemList?.insert(
          updatedFeedbackIndex,
          updatedFeedback.copyWith(helpfulCount: (updatedFeedback.helpfulCount ?? 0) + addValue),
        );
      }
    }
  }

  void _feedbacksListener(int page) async {
    final data = await widget.placeFeedbackLoaderCallback(page, widget.place.id);
    if (data.isEmpty) {
      feedbacksPagedController.appendLastPage(data);
      return;
    }
    if (data.last.empty) {
      data.removeLast();
      feedbacksPagedController.appendLastPage(data);
    } else {
      if (data.length < 10) {
        feedbacksPagedController.appendLastPage(data);
      } else {
        feedbacksPagedController.appendPage(data, page + 1);
      }
    }
  }

  @override
  void dispose() {
    reactionsPagingController.dispose();
    feedbacksPagedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentPlaceModel model = kIsWeb
        ? ComponentPlaceModel(
            version: '',
            pageBuilderType: PageBuilderType.page,
            positionModel: PositionModel(
              version: '',
              horizontalMargin: 16,
              verticalMargin: 10,
              bodyAlignment: Alignment.centerLeft,
            ),
          )
        : ComponentPlaceModel.fromJson(config['place']);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();

    final theme = context.uiKitTheme;
    final colorScheme = theme?.colorScheme;
    final boldTextTheme = theme?.boldTextTheme;

    return ListView(
      addAutomaticKeepAlives: false,
      physics: const BouncingScrollPhysics(),
      controller: listViewController,
      children: [
        SpacingFoundation.verticalSpace16,
        TitleWithAvatar(
          title: widget.place.title,
          avatarUrl: widget.place.logo,
          horizontalMargin: horizontalMargin,
          trailing: GestureDetector(
            onTap: widget.onSharePressed,
            child: Icon(
              ShuffleUiKitIcons.share,
              color: colorScheme?.darkNeutral800,
            ),
          ),
        ),
        SpacingFoundation.verticalSpace16,
        UiKitMediaSliderWithTags(
          listViewController: listViewController,
          rating: widget.place.rating,
          media: widget.place.media,
          description: widget.place.description,
          baseTags: widget.place.baseTags,
          uniqueTags: widget.place.tags,
          horizontalMargin: horizontalMargin,
          branches: widget.place.branches
          // ?? Future.value( [
          //     /// mock branches
          //     HorizontalCaptionedImageData(
          //       imageUrl: GraphicsFoundation.instance.png.place.path,
          //       caption: 'Dubai mall 1st floor, next to the Aquarium. This is a mock branch to see how it looks in app',
          //     ),
          //     HorizontalCaptionedImageData(
          //       imageUrl: GraphicsFoundation.instance.png.place.path,
          //       caption: 'Dubai mall 1st floor, next to the Aquarium. This is a mock branch to see how it looks in app',
          //     ),
          //     HorizontalCaptionedImageData(
          //       imageUrl: GraphicsFoundation.instance.png.place.path,
          //       caption: 'Dubai mall 1st floor, next to the Aquarium. This is a mock branch to see how it looks in app',
          //     ),
          //     HorizontalCaptionedImageData(
          //       imageUrl: GraphicsFoundation.instance.png.place.path,
          //       caption: 'Dubai mall 1st floor, next to the Aquarium. This is a mock branch to see how it looks in app',
          //     ),
          //   ])
          ,
          actions: [
            if (widget.complaintFormComponent != null)
              context.smallOutlinedButton(
                blurred: true,
                data: BaseUiKitButtonData(
                  backgroundColor: Colors.white.withOpacity(0.01),
                  iconInfo: BaseUiKitButtonIconData(
                    iconData: ShuffleUiKitIcons.alertcircle,
                    color: context.uiKitTheme?.colorScheme.darkNeutral800,
                  ),
                  onPressed: () {
                    showUiKitGeneralFullScreenDialog(
                      context,
                      GeneralDialogData(
                        topPadding: 0.3.sh,
                        useRootNavigator: false,
                        child: widget.complaintFormComponent!,
                      ),
                    );
                  },
                ),
                blurValue: 25,
              ),
          ],
        ),
        if (widget.canLeaveVideoReaction)
          ValueListenableBuilder(
            valueListenable: reactionsPagingController,
            builder: (context, value, child) {
              return UiKitColoredAccentBlock(
                color: colorScheme?.surface1,
                title: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      S.current.ReactionsBy,
                      style: boldTextTheme?.body,
                    ),
                    SpacingFoundation.horizontalSpace12,
                    const Expanded(child: MemberPlate()),
                  ],
                ),
                contentHeight: 0.2605.sh,
                content: UiKitHorizontalScrollableList<VideoReactionUiModel>(
                  leftPadding: horizontalMargin,
                  spacing: SpacingFoundation.horizontalSpacing8,
                  shimmerLoadingChild: UiKitReactionPreview(
                    imagePath: GraphicsFoundation.instance.png.place.path,
                  ).paddingOnly(
                    left: EdgeInsetsFoundation.horizontal8,
                  ),
                  noItemsFoundIndicator: UiKitReactionPreview.empty(
                      onTap: () => widget.onAddReactionTapped?.call().then((_) => setState(() {
                            reactionsPagingController.refresh();
                          }))).paddingOnly(left: EdgeInsetsFoundation.horizontal8),
                  itemBuilder: (context, reaction, index) {
                    print('reaction.previewImageUrl: ${reaction.previewImageUrl}');

                    if (index == 0 && widget.canLeaveVideoReaction) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          UiKitReactionPreview.empty(
                              onTap: () => widget.onAddReactionTapped?.call().then((_) => setState(() {
                                    reactionsPagingController.refresh();
                                  }))).paddingOnly(left: EdgeInsetsFoundation.horizontal8),
                          UiKitReactionPreview(
                            imagePath: reaction.previewImageUrl ?? '',
                            viewed: false,
                            onTap: () => widget.onReactionTap?.call(reaction),
                          ).paddingOnly(left: EdgeInsetsFoundation.horizontal8),
                        ],
                      );
                    }

                    return UiKitReactionPreview(
                      imagePath: reaction.previewImageUrl ?? '',
                      viewed: false,
                      onTap: () => widget.onReactionTap?.call(reaction),
                    );
                  },
                  pagingController: reactionsPagingController,
                ),
              );
            },
          ).paddingSymmetric(vertical: EdgeInsetsFoundation.vertical24),
        if (widget.isCreateEventAvaliable)
          FutureBuilder<List<UiEventModel>>(
            future: widget.events,
            builder: (context, snapshot) => UiKitCardWrapper(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.of(context).UpcomingEvent, style: boldTextTheme?.subHeadline),
                  if (snapshot.data != null && snapshot.data!.isNotEmpty) ...[
                    SpacingFoundation.verticalSpace8,
                    for (UiEventModel event in snapshot.data!)
                      ListTile(
                        isThreeLine: true,
                        contentPadding: EdgeInsets.zero,
                        leading: BorderedUserCircleAvatar(
                          imageUrl: event.media.firstWhere((element) => element.type == UiKitMediaType.image).link,
                          size: 40.w,
                        ),
                        title: Text(
                          event.title ?? '',
                          style: boldTextTheme?.caption1Bold,
                        ),
                        subtitle: event.scheduleString != null
                            ? Text(
                                event.scheduleString!,
                                style: boldTextTheme?.caption1Medium.copyWith(
                                  color: colorScheme?.darkNeutral500,
                                ),
                              )
                            : null,
                        // event.date != null
                        //     ? Text(
                        //         DateFormat('MMMM d').format(event.date!),
                        //         style: theme?.boldTextTheme.caption1Medium.copyWith(
                        //           color: theme.colorScheme.darkNeutral500,
                        //         ),
                        //       )
                        //     : const SizedBox.shrink(),
                        trailing: context
                            .smallButton(
                              data: BaseUiKitButtonData(
                                onPressed: () {
                                  if (widget.onEventTap != null) {
                                    widget.onEventTap?.call(event);
                                  } else {
                                    buildComponent(
                                      context,
                                      ComponentEventModel.fromJson(config['event']),
                                      ComponentBuilder(
                                        child: EventComponent(
                                          event: event,
                                          feedbackLoaderCallback: widget.eventFeedbackLoaderCallback,
                                          reactionsLoaderCallback: widget.eventReactionLoaderCallback,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                iconInfo: BaseUiKitButtonIconData(
                                  iconData: CupertinoIcons.right_chevron,
                                  color: colorScheme?.inversePrimary,
                                  size: 20.w,
                                ),
                              ),
                            )
                            .paddingOnly(top: SpacingFoundation.verticalSpacing4),
                      ),
                  ],
                  SpacingFoundation.verticalSpace4,
                  context.gradientButton(
                    data: BaseUiKitButtonData(
                      text: S.of(context).CreateEvent,
                      onPressed: widget.onEventCreate,
                      fit: ButtonFit.fitWidth,
                    ),
                  )
                ],
              ).paddingSymmetric(
                horizontal: SpacingFoundation.horizontalSpacing16,
                vertical: SpacingFoundation.verticalSpacing8,
              ),
            ).paddingSymmetric(
              horizontal: horizontalMargin,
              vertical: EdgeInsetsFoundation.vertical8,
            ),
          )
        else
          FutureBuilder<List<UiEventModel>>(
            future: widget.events,
            builder: (context, snapshot) => Row(
              mainAxisSize: MainAxisSize.max,
              children: () {
                final AutoSizeGroup group = AutoSizeGroup();
                log('here we are building ${snapshot.data?.length ?? 0} events', name: 'PlaceComponent');

                final List<UiEventModel> tempSorted = List.from(snapshot.data ?? []);
                if (tempSorted.isNotEmpty) {
                  tempSorted.sort((a, b) => (a.startDate ?? DateTime.now()).compareTo(b.startDate ?? DateTime.now()));
                }

                final closestEvent = tempSorted.firstOrNull;

                final Duration daysToEvent = (closestEvent?.startDate ?? DateTime.now()).difference(DateTime.now());

                return [
                  Expanded(
                    child: UpcomingEventPlaceActionCard(
                      value: closestEvent == null
                          ? 'none'
                          : S.current.WithInDays(daysToEvent.inDays > 0 ? daysToEvent.inDays : 0),
                      group: group,
                      rasterIconAsset: GraphicsFoundation.instance.png.events,
                      action: closestEvent == null
                          ? null
                          : () {
                              if (widget.onEventTap != null) {
                                widget.onEventTap?.call(closestEvent!);
                              }
                              // else {
                              //   buildComponent(context, ComponentEventModel.fromJson(config['event']),
                              //       ComponentBuilder(child: EventComponent(event: closestEvent!,
                              //   feedbackLoaderCallback: widget.eventFeedbackLoaderCallback,
                              //   reactionsLoaderCallback: widget.eventReactionLoaderCallback,
                              // ),
                              // ),);
                              // }
                            },
                    ),
                  ),
                  SpacingFoundation.horizontalSpace8,
                  Expanded(
                    child: PointBalancePlaceActionCard(
                        value: widget.place.userPoints?.toString() ?? '0',
                        group: group,
                        rasterIconAsset: GraphicsFoundation.instance.png.money,
                        action: null
                        //     () {
                        //   log('balance was pressed');
                        // },
                        ),
                  ),
                ];
              }(),
            ),
          ).paddingSymmetric(horizontal: horizontalMargin, vertical: EdgeInsetsFoundation.vertical8),
        if (widget.canLeaveFeedback)
          ValueListenableBuilder(
            valueListenable: feedbacksPagedController,
            builder: (context, value, child) {
              return UiKitColoredAccentBlock(
                title: Text(
                  S.current.ReactionsByCritics,
                  style: boldTextTheme?.body,
                ),
                color: colorScheme?.surface1,
                contentHeight: _noFeedbacks ? 0.15.sh : 0.28.sh,
                action: widget.canLeaveFeedback
                    ? context
                        .smallOutlinedButton(
                          blurred: false,
                          data: BaseUiKitButtonData(
                              iconInfo: BaseUiKitButtonIconData(
                                iconData: ShuffleUiKitIcons.plus,
                              ),
                              onPressed: () => widget.onAddFeedbackTapped
                                  ?.call()
                                  .then((_) => setState(() => feedbacksPagedController.refresh()))),
                        )
                        .paddingOnly(right: SpacingFoundation.horizontalSpacing16)
                    : null,
                content: UiKitHorizontalScrollableList<FeedbackUiModel>(
                  leftPadding: horizontalMargin,
                  spacing: SpacingFoundation.horizontalSpacing8,
                  shimmerLoadingChild: SizedBox(width: 0.85.sw, child: const UiKitFeedbackCard()),
                  noItemsFoundIndicator: SizedBox(
                    width: 1.sw,
                    child: Center(
                      child: Text(
                        S.current.NoFeedbacksYet,
                        style: boldTextTheme?.subHeadline,
                      ).paddingAll(EdgeInsetsFoundation.all16),
                    ),
                  ),
                  itemBuilder: (context, feedback, index) {
                    return SizedBox(
                      width: 0.85.sw,
                      child: UiKitFeedbackCard(
                        title: feedback.feedbackAuthorName,
                        avatarUrl: feedback.feedbackAuthorPhoto,
                        datePosted: feedback.feedbackDateTime,
                        companyAnswered: false,
                        rating: feedback.feedbackRating,
                        text: feedback.feedbackText,
                        helpfulCount: feedback.helpfulCount,
                        onLike: () {
                          final feedbackId = feedback.id;
                          if (likedReviews.contains(feedbackId)) {
                            likedReviews.remove(feedbackId);
                            widget.onDislikedFeedback?.call(feedbackId);
                            _updateFeedbackList(feedbackId, -1);
                          } else {
                            likedReviews.add(feedbackId);
                            widget.onLikedFeedback?.call(feedbackId);
                            _updateFeedbackList(feedbackId, 1);
                          }
                          setState(() {});
                        },
                      ).paddingOnly(left: index == 0 ? horizontalMargin : 0),
                    );
                  },
                  pagingController: feedbacksPagedController,
                ),
              );
            },
          ).paddingSymmetric(vertical: EdgeInsetsFoundation.vertical24),
        Wrap(
          runSpacing: SpacingFoundation.verticalSpacing8,
          spacing: SpacingFoundation.horizontalSpacing8,
          children: widget.place.descriptionItems!
              .map(
                (e) => GestureDetector(
                  onTap: () {
                    final url = e.descriptionUrl ?? e.description;

                    if (url.startsWith('http')) {
                      launchUrlString(url);
                    } else if (url.replaceAll(RegExp(r'[0-9]'), '').replaceAll('+', '').trim().isEmpty) {
                      log('launching $url', name: 'PlaceComponent');
                      launchUrlString('tel:${url}');
                    }
                  },
                  child: UiKitTitledDescriptionGridWidget(
                    title: e.title,
                    description: e.description,
                    spacing: (SpacingFoundation.horizontalSpacing4 + horizontalMargin) / 2,
                  ),
                ),
              )
              .toList(),
        ).paddingSymmetric(horizontal: horizontalMargin),
        SpacingFoundation.verticalSpace8,
        (kBottomNavigationBarHeight * 1.5).heightBox,
      ],
    ).paddingSymmetric(vertical: verticalMargin);
  }
}
