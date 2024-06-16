import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:url_launcher/url_launcher_string.dart';

class EventComponent extends StatefulWidget {
  final UiEventModel event;
  final bool isEligibleForEdit;
  final VoidCallback? onEditPressed;
  final VoidCallback? onSharePressed;
  final AsyncCallback? onAddReactionTapped;
  final PagedLoaderCallback<VideoReactionUiModel> reactionsLoaderCallback;
  final PagedLoaderCallback<FeedbackUiModel> feedbackLoaderCallback;
  final ComplaintFormComponent? complaintFormComponent;
  final ValueChanged<VideoReactionUiModel>? onReactionTap;
  final AsyncCallback? onAddFeedbackTapped;
  final bool canLeaveVideoReaction;
  final bool canLeaveFeedback;
  final ValueChanged<int>? onLikedFeedback;
  final ValueChanged<int>? onDislikedFeedback;

  const EventComponent({
    super.key,
    required this.event,
    required this.reactionsLoaderCallback,
    required this.feedbackLoaderCallback,
    this.complaintFormComponent,
    this.onAddFeedbackTapped,
    this.isEligibleForEdit = false,
    this.onEditPressed,
    this.onSharePressed,
    this.onReactionTap,
    this.onAddReactionTapped,
    this.canLeaveVideoReaction = true,
    this.canLeaveFeedback = false,
    this.onLikedFeedback,
    this.onDislikedFeedback,
  });

  @override
  State<EventComponent> createState() => _EventComponentState();
}

class _EventComponentState extends State<EventComponent> {
  final reactionsPagingController = PagingController<int, VideoReactionUiModel>(firstPageKey: 1);

  final feedbackPagingController = PagingController<int, FeedbackUiModel>(firstPageKey: 1);

  List<int> likedReviews = List<int>.empty(growable: true);

  bool get _noFeedbacks => feedbackPagingController.itemList?.isEmpty ?? true;

  bool get _noReactions => reactionsPagingController.itemList?.isEmpty ?? true;

  bool isHide = true;
  late double scrollPosition;
  final ScrollController listViewController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _onReactionsPageRequest(1);
      reactionsPagingController.addPageRequestListener(_onReactionsPageRequest);
      feedbackPagingController.addPageRequestListener(_onFeedbackPageRequest);
    });
  }

  void _onReactionsPageRequest(int page) async {
    final data = await widget.reactionsLoaderCallback(page, widget.event.id);

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
    final updatedFeedbackIndex = feedbackPagingController.itemList?.indexWhere((element) => element.id == feedbackId);
    if (updatedFeedbackIndex != null && updatedFeedbackIndex >= 0) {
      final updatedFeedback = feedbackPagingController.itemList?.removeAt(updatedFeedbackIndex);
      if (updatedFeedback != null) {
        feedbackPagingController.itemList?.insert(
          updatedFeedbackIndex,
          updatedFeedback.copyWith(helpfulCount: (updatedFeedback.helpfulCount ?? 0) + addValue),
        );
      }
    }
  }

  void _onFeedbackPageRequest(int page) async {
    final data = await widget.feedbackLoaderCallback(page, widget.event.id);

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
                        textAlign: titleAlignment.textAlign,
                      ),
                    ),
                    if (widget.isEligibleForEdit)
                      Positioned(
                        right: 0,
                        child: IconButton(
                          icon: ImageWidget(
                              iconData: ShuffleUiKitIcons.pencil,
                              color: Colors.white,
                              height: 20.h,
                              fit: BoxFit.fitHeight),
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
          SpacingFoundation.verticalSpace16
        ],
        SpacingFoundation.verticalSpace24,
        if (widget.canLeaveVideoReaction)
          ValueListenableBuilder(
            valueListenable: reactionsPagingController,
            builder: (context, value, child) {
              return UiKitColoredAccentBlock(
                color: colorScheme?.surface1,
                title: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _noReactions
                        ? Expanded(child: Text(S.current.NoReactionsMessage, style: boldTextTheme?.body))
                        : Text(S.current.ReactionsBy, style: boldTextTheme?.body),
                    if (!_noReactions) SpacingFoundation.horizontalSpace12,
                    if (!_noReactions) const Expanded(child: MemberPlate()),
                  ],
                ),
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
                    onTap: () => widget.onAddReactionTapped
                        ?.call()
                        .then((_) => setState(() => reactionsPagingController.refresh())),
                  ).paddingOnly(left: EdgeInsetsFoundation.horizontal16),
                  itemBuilder: (context, reaction, index) {
                    if (index == 0 && widget.canLeaveVideoReaction) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          UiKitReactionPreview.empty(
                            customHeight: 0.205.sh,
                            onTap: () => widget.onAddReactionTapped
                                ?.call()
                                .then((_) => setState(() => reactionsPagingController.refresh())),
                          ).paddingOnly(left: EdgeInsetsFoundation.horizontal16),
                          UiKitReactionPreview(
                            customHeight: 0.205.sh,
                            imagePath: reaction.previewImageUrl ?? '',
                            viewed: false,
                            onTap: () => widget.onReactionTap?.call(reaction),
                          ).paddingOnly(left: EdgeInsetsFoundation.horizontal8),
                        ],
                      );
                    }

                    return UiKitReactionPreview(
                      customHeight: 0.205.sh,
                      imagePath: reaction.previewImageUrl ?? '',
                      viewed: false,
                      onTap: () => widget.onReactionTap?.call(reaction),
                    );
                  },
                  pagingController: reactionsPagingController,
                ),
              );
            },
          ).paddingOnly(bottom: EdgeInsetsFoundation.vertical24),
        if (widget.canLeaveFeedback)
          ValueListenableBuilder(
            valueListenable: feedbackPagingController,
            builder: (context, value, child) {
              return UiKitColoredAccentBlock(
                contentHeight: _noFeedbacks ? 0 : 0.28.sh,
                color: colorScheme?.surface1,
                title: Text(
                  S.current.ReactionsByCritics,
                  style: boldTextTheme?.body,
                ),
                action: widget.canLeaveFeedback
                    ? context
                        .smallOutlinedButton(
                          blurred: false,
                          data: BaseUiKitButtonData(
                            iconInfo: BaseUiKitButtonIconData(
                              iconData: ShuffleUiKitIcons.plus,
                            ),
                            onPressed: () => widget.onAddFeedbackTapped?.call().then((_) => setState(() {
                                  feedbackPagingController.refresh();
                                })),
                          ),
                        )
                        .paddingOnly(right: SpacingFoundation.horizontalSpacing16)
                    : null,
                content: UiKitHorizontalScrollableList<FeedbackUiModel>(
                  leftPadding: horizontalMargin,
                  spacing: SpacingFoundation.horizontalSpacing8,
                  shimmerLoadingChild: SizedBox(width: 0.95.sw, child: const UiKitFeedbackCard()),
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
                      width: 0.95.sw,
                      child: UiKitFeedbackCard(
                        title: feedback.feedbackAuthorName,
                        avatarUrl: feedback.feedbackAuthorPhoto,
                        datePosted: feedback.feedbackDateTime,
                        companyAnswered: false,
                        text: feedback.feedbackText,
                        helpfulCount: feedback.helpfulCount,
                        rating: feedback.feedbackRating,
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
          ...widget.event.descriptionItems!
              .map(
                (e) => GestureDetector(
                  onTap: () {
                    if (e.descriptionUrl != null) {
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
              )
              .toList(),
        (kBottomNavigationBarHeight * 1.5).heightBox
      ],
    ).paddingSymmetric(
      vertical: (model.positionModel?.verticalMargin ?? 0).toDouble(),
    );
  }
}
