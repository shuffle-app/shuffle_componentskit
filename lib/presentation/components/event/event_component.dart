import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:url_launcher/url_launcher_string.dart';

final AutoSizeGroup group = AutoSizeGroup();

class EventComponent extends StatefulWidget {
  final UiEventModel event;
  final bool isEligibleForEdit;
  final VoidCallback? onEditPressed;
  final VoidCallback? onSharePressed;
  final Future<bool> Function()? onAddReactionTapped;
  final PagedLoaderCallback<VideoReactionUiModel> reactionsLoaderCallback;
  final PagedLoaderCallback<FeedbackUiModel> feedbackLoaderCallback;
  final ComplaintFormComponent? complaintFormComponent;
  final ValueChanged<VideoReactionUiModel>? onReactionTap;
  final Future<bool> Function()? onAddFeedbackTapped;
  final Future<bool> Function(int eventId) canLeaveFeedback;
  final bool canLeaveVideoReaction;
  final ValueChanged<int>? onLikedFeedback;
  final ValueChanged<int>? onDislikedFeedback;
  final ValueChanged<FeedbackUiModel>? onFeedbackTap;
  final bool showOfferButton;
  final int? priceForOffer;
  final VoidCallback? onOfferButtonTap;
  final ValueNotifier<BookingUiModel?>? bookingNotifier;
  final VoidCallback? onSpendPointTap;

  const EventComponent({
    super.key,
    required this.event,
    required this.reactionsLoaderCallback,
    required this.feedbackLoaderCallback,
    required this.canLeaveFeedback,
    this.complaintFormComponent,
    this.onAddFeedbackTapped,
    this.isEligibleForEdit = false,
    this.onEditPressed,
    this.onSharePressed,
    this.onReactionTap,
    this.onAddReactionTapped,
    this.canLeaveVideoReaction = true,
    this.onLikedFeedback,
    this.onDislikedFeedback,
    this.onFeedbackTap,
    this.showOfferButton = false,
    this.priceForOffer,
    this.onOfferButtonTap,
    this.bookingNotifier,
    this.onSpendPointTap,
  });

  @override
  State<EventComponent> createState() => _EventComponentState();
}

class _EventComponentState extends State<EventComponent> {
  final reactionsPagingController = PagingController<int, VideoReactionUiModel>(firstPageKey: 1);

  final feedbackPagingController = PagingController<int, FeedbackUiModel>(firstPageKey: 1);

  Set<int> likedReviews = {};

  bool get _noFeedbacks => feedbackPagingController.itemList?.isEmpty ?? true;

  bool get _noReactions => reactionsPagingController.itemList?.isEmpty ?? true;

  bool? canLeaveFeedback;

  bool isHide = true;

  late double scrollPosition;
  final ScrollController listViewController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      canLeaveFeedback = await widget.canLeaveFeedback(widget.event.id);
      reactionsPagingController.addPageRequestListener(_onReactionsPageRequest);
      reactionsPagingController.notifyPageRequestListeners(1);
      feedbackPagingController.addPageRequestListener(_onFeedbackPageRequest);
      feedbackPagingController.notifyPageRequestListeners(1);
      setState(() {});
    });
  }

  void _onReactionsPageRequest(int page) async {
    final data = await widget.reactionsLoaderCallback(page, widget.event.id);
    if (data.any((e) => reactionsPagingController.itemList?.any((el) => el.id == e.id) ?? false)) return;
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
    setState(() {});
  }

  void _updateFeedbackList(int feedbackId, int addValue) {
    final updatedFeedbackIndex = feedbackPagingController.itemList?.indexWhere((element) => element.id == feedbackId);
    if (updatedFeedbackIndex != null && updatedFeedbackIndex >= 0) {
      final updatedFeedback = feedbackPagingController.itemList?.removeAt(updatedFeedbackIndex);
      if (updatedFeedback != null) {
        feedbackPagingController.itemList?.insert(
          updatedFeedbackIndex,
          updatedFeedback.copyWith(
              helpfulCount: (updatedFeedback.helpfulCount ?? 0) + addValue, helpfulForUser: addValue > 0),
        );
      }
    }
    setState(() {});
  }

  void _onFeedbackPageRequest(int page) async {
    final data = await widget.feedbackLoaderCallback(page, widget.event.id);
    if (data.any((e) => feedbackPagingController.itemList?.any((el) => el.id == e.id) ?? false)) return;
    likedReviews.addAll(data.where((e) => e.helpfulForUser ?? false).map((e) => e.id));
    if (data.isEmpty) {
      feedbackPagingController.appendLastPage(data);
      return;
    }
    if (data.last.empty) {
      data.removeLast();
      feedbackPagingController.appendLastPage(data);
    } else {
      if (data.length < 10) {
        feedbackPagingController.appendLastPage(data);
      } else {
        feedbackPagingController.appendPage(data, page + 1);
      }
    }

    setState(() {});
  }

  void _handleAddReactionTapped() async {
    final addedReaction = await widget.onAddReactionTapped?.call();
    if (addedReaction == true) {
      setState(() {
        reactionsPagingController.refresh();
      });
    }
  }

  @override
  void dispose() {
    reactionsPagingController.dispose();
    feedbackPagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentEventModel model = kIsWeb
        ? ComponentEventModel(
            version: '0',
            pageBuilderType: PageBuilderType.page,
            positionModel:
                PositionModel(bodyAlignment: Alignment.topLeft, version: '', horizontalMargin: 16, verticalMargin: 10))
        : ComponentEventModel.fromJson(config['event']);

    final theme = context.uiKitTheme;
    final titleAlignment = model.positionModel?.titleAlignment;
    final colorScheme = theme?.colorScheme;
    final boldTextTheme = theme?.boldTextTheme;
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();

    return ListView(
      controller: listViewController,
      physics: const BouncingScrollPhysics(),
      addAutomaticKeepAlives: false,
      children: [
        SpacingFoundation.verticalSpace8,
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: titleAlignment.mainAxisAlignment,
          crossAxisAlignment: titleAlignment.crossAxisAlignment,
          children: [
            if (widget.event.title != null) ...[
              SizedBox(
                width: 1.sw,
                child: Stack(
                  alignment: titleAlignment.crossAxisAlignment == CrossAxisAlignment.center
                      ? Alignment.center
                      : AlignmentDirectional.topStart,
                  children: [
                    SizedBox(
                      width: 1.sw - (horizontalMargin * 2 + 35.w),
                      child: AutoSizeText(
                        widget.event.title!,
                        minFontSize: 18.w,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        stepGranularity: 1.w,
                        style: theme?.boldTextTheme.title2,
                        textAlign: widget.isEligibleForEdit ? TextAlign.start : titleAlignment.textAlign,
                      ),
                    ).paddingOnly(right: widget.isEligibleForEdit ? SpacingFoundation.horizontalSpacing44 : 0),
                    if (widget.isEligibleForEdit)
                      Positioned(
                        right: 0,
                        child: IconButton(
                          icon: ImageWidget(
                            link: GraphicsFoundation.instance.svg.pencil.path,
                            height: 20.h,
                            color: theme?.colorScheme.inversePrimary,
                            fit: BoxFit.fitHeight,
                          ),
                          onPressed: () => widget.onEditPressed?.call(),
                        ),
                      )
                    else if (widget.onSharePressed != null)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: widget.onSharePressed,
                          child: ImageWidget(
                            iconData: ShuffleUiKitIcons.share,
                            color: context.uiKitTheme?.colorScheme.darkNeutral800,
                          ),
                        ),
                      ),
                  ],
                ).paddingSymmetric(horizontal: horizontalMargin),
              ),
              SpacingFoundation.verticalSpace8,
            ],
            if (widget.event.archived) ...[
              UiKitBadgeOutlined.text(
                text: S.of(context).Archived,
              ),
              SpacingFoundation.verticalSpace4,
            ],
            if (widget.event.owner != null)
              widget.event.owner!.buildUserTile(context).paddingSymmetric(horizontal: horizontalMargin)
          ],
        ),
        SpacingFoundation.verticalSpace16,
        // Column(
        //   mainAxisSize: MainAxisSize.min,
        //   mainAxisAlignment: bodyAlignment.mainAxisAlignment,
        //   crossAxisAlignment: bodyAlignment.crossAxisAlignment,
        //   children: [
        Align(
          alignment: Alignment.center,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              UiKitPhotoSlider(
                media: widget.event.media,
                onTap: null,
                width: 1.sw - horizontalMargin * 2,
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
                weatherType: widget.event.weatherType,
              ),
            ],
          ).paddingSymmetric(horizontal: horizontalMargin),
        ),
        SpacingFoundation.verticalSpace14,
        UiKitTagsWidget(
          rating: widget.event.rating,
          baseTags: widget.event.baseTags,
          uniqueTags: widget.event.tags,
        ).paddingSymmetric(horizontal: horizontalMargin),
        SpacingFoundation.verticalSpace14,
        if (widget.event.description != null) ...[
          RepaintBoundary(
              child: DescriptionWidget(
            description: widget.event.description!,
            isHide: isHide,
            onReadLess: () {
              setState(() {
                listViewController
                    .animateTo(scrollPosition, duration: const Duration(milliseconds: 100), curve: Curves.easeIn)
                    .then(
                  (value) {
                    setState(() {
                      isHide = true;
                    });
                  },
                );
              });
            },
            onReadMore: () {
              setState(() {
                isHide = false;
                scrollPosition = listViewController.position.pixels;
              });
            },
          ).paddingSymmetric(horizontal: horizontalMargin)),
          SpacingFoundation.verticalSpace24,
        ],
        if (widget.showOfferButton)
          UiKitCardWrapper(
            color: theme?.colorScheme.surface1,
            padding: EdgeInsets.all(EdgeInsetsFoundation.all16),
            borderRadius: BorderRadiusFoundation.all24r,
            child: Column(
              children: [
                Text(
                  S.of(context).CreateAUSP(widget.priceForOffer ?? 5),
                  style: boldTextTheme?.caption1Medium,
                ),
                SpacingFoundation.verticalSpace4,
                SizedBox(
                  width: double.infinity,
                  child: context.smallOutlinedButton(
                    gradient: GradientFoundation.defaultLinearGradient,
                    data: BaseUiKitButtonData(
                      text: S.of(context).Offer.toUpperCase(),
                      onPressed: widget.onOfferButtonTap,
                    ),
                  ),
                ),
              ],
            ),
          ).paddingOnly(
            left: horizontalMargin,
            right: horizontalMargin,
            bottom: SpacingFoundation.verticalSpacing24,
          ),
        Row(
          children: [
            Expanded(
              child: AddToSchedulerEventActionCard(
                group: group,
                action: null,
                rasterIconAsset: GraphicsFoundation.instance.png.events,
                value: '',
                buttonTitle: S.of(context).Add,
              ),
            ),
            SpacingFoundation.horizontalSpace8,
            Expanded(
              child: PointBalancePlaceActionCard(
                value: widget.event.userPoints?.toString() ?? '0',
                group: group,
                rasterIconAsset: GraphicsFoundation.instance.png.money,
                buttonTitle: S.of(context).SpendIt,
                action: widget.onSpendPointTap,
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: horizontalMargin, vertical: EdgeInsetsFoundation.vertical24),
        if (widget.bookingNotifier != null)
          ListenableBuilder(
            listenable: widget.bookingNotifier!,
            builder: (context, child) => AnimatedSize(
              duration: const Duration(milliseconds: 250),
              child: (widget.bookingNotifier?.value?.subsUiModel != null &&
                      widget.bookingNotifier!.value!.showSubsInContentCard &&
                      widget.bookingNotifier!.value!.subsUiModel!.isNotEmpty)
                  ? SizedBox(
                      width: 1.sw,
                      child: SubsInContentCard(
                        subs: widget.bookingNotifier!.value!.subsUiModel!,
                        onItemTap: (id) {
                          final sub =
                              widget.bookingNotifier!.value!.subsUiModel!.firstWhere((element) => element.id == id);
                          subInformationDialog(context, sub);
                        },
                      ),
                    ).paddingOnly(
                      top: SpacingFoundation.verticalSpacing12,
                      bottom: SpacingFoundation.verticalSpacing24,
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        if (widget.event.upsalesItems != null) ...[
          UiKitCardWrapper(
            color: theme?.colorScheme.surface2,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).UpsalesAvailable,
                        style: theme?.boldTextTheme.body,
                      ),
                      SpacingFoundation.verticalSpace2,
                      Text(
                        widget.event.upsalesItems!
                            .map((e) {
                              if (e.isNotEmpty) {
                                return e.trim();
                              }
                            })
                            .nonNulls
                            .join(', '),
                        style: theme?.regularTextTheme.caption2,
                      )
                    ],
                  ).paddingAll(EdgeInsetsFoundation.all16),
                ),
                ImageWidget(
                  height: 45.h,
                  fit: BoxFit.fitWidth,
                  link: GraphicsFoundation.instance.png.merch.path,
                ),
                SpacingFoundation.horizontalSpace16,
              ],
            ),
          ).paddingSymmetric(horizontal: horizontalMargin),
          SpacingFoundation.verticalSpace24,
        ],
        if (!_noReactions || widget.canLeaveVideoReaction)
          ValueListenableBuilder(
            valueListenable: reactionsPagingController,
            builder: (context, value, child) {
              return UiKitColoredAccentBlock(
                color: colorScheme?.surface1,
                title: _noReactions
                    ? Text(S.of(context).NoReactionsMessage, style: boldTextTheme?.body)
                    : RichText(
                        text: TextSpan(
                        children: [
                          TextSpan(text: '${S.of(context).ReactionsBy} ', style: boldTextTheme?.body),
                          WidgetSpan(
                            child: Transform.translate(offset: const Offset(0, 4), child: const MemberPlate()),
                          ),
                        ],
                      )),
                contentHeight: 0.205.sh,
                content: UiKitHorizontalScrollableList<VideoReactionUiModel>(
                  leftPadding: horizontalMargin,
                  spacing: SpacingFoundation.horizontalSpacing8,
                  shimmerLoadingChild: UiKitReactionPreview(
                    customHeight: 0.205.sh,
                    imagePath: GraphicsFoundation.instance.png.place.path,
                  ).paddingOnly(left: EdgeInsetsFoundation.horizontal16),
                  noItemsFoundIndicator: UiKitReactionPreview.empty(
                    customHeight: 0.205.sh,
                    onTap: _handleAddReactionTapped,
                  ).paddingOnly(left: EdgeInsetsFoundation.horizontal16),
                  itemBuilder: (context, reaction, index) {
                    if (index == 0 && widget.canLeaveVideoReaction) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          UiKitReactionPreview.empty(
                            customHeight: 0.205.sh,
                            onTap: _handleAddReactionTapped,
                          ).paddingOnly(left: EdgeInsetsFoundation.horizontal16),
                          UiKitReactionPreview(
                            customHeight: 0.205.sh,
                            imagePath: reaction.previewImageUrl ?? '',
                            viewed: reaction.isViewed,
                            onTap: () => widget.onReactionTap?.call(reaction),
                          ).paddingOnly(left: EdgeInsetsFoundation.horizontal8),
                        ],
                      );
                    }

                    return UiKitReactionPreview(
                      customHeight: 0.205.sh,
                      imagePath: reaction.previewImageUrl ?? '',
                      viewed: reaction.isViewed,
                      onTap: () => widget.onReactionTap?.call(reaction),
                    ).paddingOnly(left: index == 0 ? EdgeInsetsFoundation.all16 : 0);
                  },
                  pagingController: reactionsPagingController,
                ),
              );
            },
          ).paddingOnly(bottom: EdgeInsetsFoundation.vertical24),
        if (!_noFeedbacks || (canLeaveFeedback ?? false))
          ValueListenableBuilder(
            valueListenable: feedbackPagingController,
            builder: (context, value, child) {
              return UiKitColoredAccentBlock(
                contentHeight: _noFeedbacks ? 0 : 0.28.sh,
                color: colorScheme?.surface1,
                title: Text(
                  _noFeedbacks ? S.of(context).NoReviewsMessage : S.of(context).ReviewsByCritics,
                  style: boldTextTheme?.body,
                ),
                action: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: canLeaveFeedback ?? false
                      ? context
                          .smallOutlinedButton(
                            blurred: false,
                            data: BaseUiKitButtonData(
                              iconInfo: BaseUiKitButtonIconData(
                                iconData: ShuffleUiKitIcons.plus,
                              ),
                              onPressed: () => widget.onAddFeedbackTapped?.call().then((addedFeedback) {
                                setState(() {
                                  canLeaveFeedback = false;
                                  feedbackPagingController.refresh();
                                  feedbackPagingController.notifyPageRequestListeners(1);
                                });
                              }),
                            ),
                          )
                          .paddingOnly(right: SpacingFoundation.horizontalSpacing16)
                      : null,
                ),
                content: _noFeedbacks
                    ? null
                    : UiKitHorizontalScrollableList<FeedbackUiModel>(
                        leftPadding: horizontalMargin,
                        spacing: SpacingFoundation.horizontalSpacing8,
                        shimmerLoadingChild: SizedBox(width: 0.95.sw, child: const UiKitFeedbackCard()),
                        noItemsFoundIndicator: SizedBox(
                          width: 1.sw,
                          child: Center(
                            child: Text(
                              S.of(context).NoFeedbacksYet,
                              style: boldTextTheme?.subHeadline,
                            ).paddingAll(EdgeInsetsFoundation.all16),
                          ),
                        ),
                        itemBuilder: (context, feedback, index) {
                          return SizedBox(
                            width: 0.95.sw,
                            child: UiKitFeedbackCard(
                              title: feedback.feedbackAuthorName,
                              avatarUrl: feedback.feedbackAuthorPhoto,
                              userTileType: feedback.feedbackAuthorType,
                              datePosted: feedback.feedbackDateTime,
                              companyAnswered: false,
                              text: feedback.feedbackText,
                              rating: feedback.feedbackRating,
                              isHelpful: feedback.helpfulForUser,
                              helpfulCount: feedback.helpfulCount == 0 ? null : feedback.helpfulCount,
                              onPressed: () {
                                if (widget.onFeedbackTap != null) {
                                  widget.onFeedbackTap?.call(feedback);
                                } else {
                                  feedback.onTap?.call();
                                }
                              },
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
                        pagingController: feedbackPagingController,
                      ),
              );
            },
          ).paddingOnly(bottom: EdgeInsetsFoundation.vertical24),
        if (widget.event.descriptionItems != null)
          ...widget.event.descriptionItems!.map(
            (e) => GestureDetector(
              onTap: () {
                if (e.descriptionUrl == 'times' && widget.event.schedule != null) {
                  showTimeInfoDialog(context, widget.event.schedule!.getReadableScheduleString());
                } else if (e.descriptionUrl != null) {
                  launchUrlString(e.descriptionUrl!);
                } else if (e.description.startsWith('http')) {
                  launchUrlString(e.description);
                } else if (e.description.replaceAll(RegExp(r'[0-9]'), '').replaceAll('+', '').trim().isEmpty) {
                  launchUrlString('tel:${e.description}');
                }
              },
              child: TitledAccentInfo(
                title: e.title,
                info: e.description,
                showFullInfo: true,
              ),
            ).paddingSymmetric(vertical: SpacingFoundation.verticalSpacing4, horizontal: horizontalMargin),
          ),
        (kBottomNavigationBarHeight * 1.5).heightBox
      ],
    ).paddingSymmetric(
      vertical: (model.positionModel?.verticalMargin ?? 0).toDouble(),
    );
  }
}
