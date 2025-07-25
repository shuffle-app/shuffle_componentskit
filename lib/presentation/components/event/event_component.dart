import 'dart:developer';

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
  final VoidCallback? onAddToSchedulerPressed;
  final VoidCallback? onArchivePressed;
  final AsyncValueGetter<bool>? onAddReactionTapped;
  final PagedLoaderCallback<VideoReactionUiModel> reactionsLoaderCallback;
  final PagedLoaderCallback<FeedbackUiModel> feedbackLoaderCallback;
  final ComplaintFormComponent? complaintFormComponent;
  final ValueChanged<VideoReactionUiModel>? onReactionTap;
  final AsyncValueGetter<bool>? onAddFeedbackTapped;
  final Future<bool> Function(int eventId) canLeaveFeedback;
  final bool canLeaveVideoReaction;
  final ValueChanged<int>? onLikedFeedback;
  final ValueChanged<int>? onDislikedFeedback;
  final Future<EditReviewModel> Function(FeedbackUiModel)? onFeedbackTap;
  final bool showOfferButton;
  final int? priceForOffer;
  final int? priceForRefresher;
  final VoidCallback? onOfferButtonTap;
  final VoidCallback? onRefresherButtonTap;
  final ValueNotifier<BookingUiModel?>? bookingNotifier;
  final VoidCallback? onSpendPointTap;
  final ValueNotifier<bool>? showTranslateButton;
  final int? currentUserId;
  final Set<int>? likedReviews;
  final ValueChanged<BaseUiKitUserTileData?>? onAvatarTap;
  final VoidCallback? onAddVoiceTap;
  final VoidCallback? onInterviewTap;
  final bool isInfluencer;
  final ValueNotifier<List<VoiceUiModel?>?>? voiceUiModels;
  final VoidCallback? onViewAllVoicesTap;
  final AsyncValueGetter<String?>? onTranslateTap;

  const EventComponent({
    super.key,
    required this.event,
    required this.reactionsLoaderCallback,
    required this.feedbackLoaderCallback,
    required this.canLeaveFeedback,
    this.complaintFormComponent,
    this.onAddFeedbackTapped,
    this.onArchivePressed,
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
    this.priceForRefresher,
    this.onOfferButtonTap,
    this.onRefresherButtonTap,
    this.bookingNotifier,
    this.onSpendPointTap,
    this.showTranslateButton,
    this.currentUserId,
    this.likedReviews,
    this.onAddToSchedulerPressed,
    this.onAvatarTap,
    this.onAddVoiceTap,
    this.onInterviewTap,
    this.isInfluencer = false,
    this.voiceUiModels,
    this.onViewAllVoicesTap,
    this.onTranslateTap,
  });

  @override
  State<EventComponent> createState() => _EventComponentState();
}

class _EventComponentState extends State<EventComponent> {
  final AutoSizeGroup group = AutoSizeGroup();
  final AutoSizeGroup _personalToolInContentCardGroup = AutoSizeGroup();
  final AutoSizeGroup _influencerGroup = AutoSizeGroup();

  late final reactionsPagingController = PagingController<int, VideoReactionUiModel>(
      getNextPageKey: (PagingState<int, VideoReactionUiModel> state) => (state.keys?.last ?? 0) + 1,
      fetchPage: _onReactionsPageRequest);

  late final feedbackPagingController = PagingController<int, FeedbackUiModel>(
      fetchPage: _onFeedbackPageRequest,
      getNextPageKey: (PagingState<int, FeedbackUiModel> state) => (state.keys?.last ?? 0) + 1);

  bool get _noFeedbacks => feedbackPagingController.items?.isEmpty ?? true;

  bool get _noReactions => reactionsPagingController.items?.isEmpty ?? true;

  bool cannotLeaveLike(id) =>
      widget.currentUserId == id || widget.onLikedFeedback == null || widget.onDislikedFeedback == null;

  bool? canLeaveFeedback;

  bool isHide = true;
  bool isTranslate = false;
  bool isLoadingTranslate = false;
  String? translateText;

  late double scrollPosition;
  final ScrollController listViewController = ScrollController();

  String currentDescription = '';

  @override
  void initState() {
    currentDescription = widget.event.description ?? '';
    super.initState();
    reactionsPagingController.addListener(updateStateIfNotEmpty);
    feedbackPagingController.addListener(updateStateIfNotEmpty);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      feedbackPagingController.fetchNextPage();
      reactionsPagingController.fetchNextPage();
      canLeaveFeedback = await widget.canLeaveFeedback(widget.event.id);
      log('going to update reviews');
      setState(() {});
    });
  }

  updateStateIfNotEmpty() {
    if (!_noFeedbacks || !_noReactions) {
      setState(() {});
    }
  }

  Future<List<VideoReactionUiModel>> _onReactionsPageRequest(int page) async {
    final data = await widget.reactionsLoaderCallback(page, widget.event.id);
    if (data.any((e) => reactionsPagingController.items?.any((el) => el.id == e.id) ?? false)) return [];
    if (data.isEmpty) {
      reactionsPagingController.value = reactionsPagingController.value.copyWith(hasNextPage: false);
      return data;
    }
    if (data.last.empty) {
      data.removeLast();
      reactionsPagingController.value = reactionsPagingController.value.copyWith(hasNextPage: false);
      return data;
    } else {
      if (data.length < 10) {
        reactionsPagingController.value = reactionsPagingController.value.copyWith(hasNextPage: false);
        return data;
      } else {
        return data;
      }
    }
  }

  void _updateFeedbackList(int feedbackId, int addValue) {
    final updatedFeedbackIndex = feedbackPagingController.items?.indexWhere((element) => element.id == feedbackId);
    if (updatedFeedbackIndex != null && updatedFeedbackIndex >= 0) {
      final updatedFeedback = feedbackPagingController.items?.removeAt(updatedFeedbackIndex);
      if (updatedFeedback != null) {
        feedbackPagingController.items?.insert(
          updatedFeedbackIndex,
          updatedFeedback.copyWith(
              helpfulCount: (updatedFeedback.helpfulCount ?? 0) + addValue, helpfulForUser: addValue > 0),
        );
      }
    }
    setState(() {});
  }

  Future<List<FeedbackUiModel>> _onFeedbackPageRequest(int page) async {
    final data = await widget.feedbackLoaderCallback(page, widget.event.id);
    if (data.any((e) => feedbackPagingController.items?.any((el) => el.id == e.id) ?? false)) return [];
    widget.likedReviews?.addAll(data.where((e) => e.helpfulForUser ?? false).map((e) => e.id));
    if (data.isEmpty) {
      feedbackPagingController.value = feedbackPagingController.value.copyWith(hasNextPage: false);
      return data;
    }
    if (data.last.empty) {
      data.removeLast();
      feedbackPagingController.value = feedbackPagingController.value.copyWith(hasNextPage: false);
      return data;
    } else {
      if (data.length < 10) {
        feedbackPagingController.value = feedbackPagingController.value.copyWith(hasNextPage: false);
        return data;
      } else {
        return data;
      }
    }
  }

  void _handleAddReactionTapped() async {
    final addedReaction = await widget.onAddReactionTapped?.call();
    if (addedReaction == true) {
      setState(() {
        reactionsPagingController.refresh();
        reactionsPagingController.fetchNextPage();
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

    final isSmallScreen = MediaQuery.sizeOf(context).width <= 375;

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
                    else
                      Positioned(
                          right: -horizontalMargin - 2,
                          child: UiKitPopUpMenuButton.optionWithIcon(options: [
                            UiKitPopUpMenuButtonOption(
                              title: S.of(context).Share,
                              icon: ShuffleUiKitIcons.share,
                              value: 'share',
                              onTap: widget.onSharePressed,
                            ),
                            UiKitPopUpMenuButtonOption(
                              title: S.of(context).AddToScheduler,
                              icon: ShuffleUiKitIcons.calendar,
                              value: 'addToScheduler',
                              onTap: widget.onAddToSchedulerPressed,
                            ),
                          ]))
                  ],
                ).paddingSymmetric(horizontal: horizontalMargin),
              ),
              SpacingFoundation.verticalSpace8,
            ],
            if (widget.event.archived) ...[
              InkWell(
                  borderRadius: BorderRadiusFoundation.all24,
                  onTap: () => widget.onArchivePressed?.call(),
                  child: UiKitBadgeOutlined.text(
                    text: S.of(context).Archived,
                  )),
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
                onTap: (index) {
                  if (index != null) {
                    final media = widget.event.media[index];
                    if (media.type == UiKitMediaType.video || media.link.isEmpty) return;

                    final heroTag = '${media.link}--$index';

                    context.push(
                        PhotoDialog(
                          images: widget.event.media
                              .where((e) => e.type == UiKitMediaType.image)
                              .map((e) => e.link)
                              .toList(),
                          initialIndex: index,
                          tag: heroTag,
                        ),
                        nativeTransition: false,
                        transitionDuration: const Duration(milliseconds: 500));
                  }
                },
                width: 1.sw - horizontalMargin * 2,
                actions: [
                  if (widget.complaintFormComponent != null)
                    context.smallOutlinedButton(
                      blurred: true,
                      data: BaseUiKitButtonData(
                        backgroundColor: Colors.white.withValues(alpha: 0.01),
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
          onTagTap: (value) {
            if (widget.event.schedule != null && value == ShuffleUiKitIcons.clock) {
              showTimeInfoDialog(context, widget.event.schedule!.getReadableScheduleString());
            }
          },
        ).paddingSymmetric(horizontal: horizontalMargin),
        SpacingFoundation.verticalSpace14,
        if (widget.event.description != null) ...[
          RepaintBoundary(
            child: DescriptionWidget(
              isLoading: isLoadingTranslate,
              description: currentDescription,
              showTranslateButton: widget.showTranslateButton,
              onTranslateTap: () async {
                isLoadingTranslate = true;
                setState(() {});

                if (isTranslate) {
                  currentDescription = widget.event.description ?? '';
                  isTranslate = !isTranslate;
                } else {
                  if (translateText != null && translateText!.isNotEmpty) {
                    currentDescription = translateText!;
                    isTranslate = !isTranslate;
                  } else {
                    final translateDescription = await widget.onTranslateTap?.call();
                    if (translateDescription != null && translateDescription.isNotEmpty) {
                      translateText = translateDescription;
                      currentDescription = translateText!;
                      isTranslate = !isTranslate;
                    }
                  }
                }

                isLoadingTranslate = false;
                setState(() {});
              },
              isHide: isHide,
              isTranslate: isTranslate,
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
            ).paddingSymmetric(horizontal: horizontalMargin),
          ),
          SpacingFoundation.verticalSpace24,
        ],
        if (widget.showOfferButton)
          SizedBox(
            height: 0.383.sw,
            child: Row(
              children: [
                Expanded(
                  child: UiKitPersonalToolInContentCard(
                    text: S.of(context).CreateAUSP(widget.priceForOffer ?? 5),
                    group: _personalToolInContentCardGroup,
                    onTap: widget.onOfferButtonTap,
                  ),
                ),
                SpacingFoundation.horizontalSpace16,
                Expanded(
                  child: UiKitPersonalToolInContentCard(
                    group: _personalToolInContentCardGroup,
                    text: S.of(context).SetUpARefresherForX(widget.priceForRefresher ?? 1),
                    onTap: widget.onRefresherButtonTap,
                  ),
                ),
              ],
            ).paddingOnly(
              left: horizontalMargin,
              right: horizontalMargin,
              bottom: SpacingFoundation.verticalSpacing24,
            ),
          ),
        ColoredBox(
          color: theme?.colorScheme.surface ?? ColorsFoundation.surface,
          child: Row(
            children: [
              Expanded(
                child: AddToSchedulerEventActionCard(
                  group: group,
                  action: widget.onAddToSchedulerPressed,
                  rasterIconAsset: GraphicsFoundation.instance.png.events,
                  value: '\n',
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
        ),
        if (widget.bookingNotifier != null)
          ListenableBuilder(
            listenable: widget.bookingNotifier!,
            //TODO here
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
                contentHeight: _noFeedbacks ? 0 : (isSmallScreen ? 172.h : 0.286.sh),
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
                                if (addedFeedback) {
                                  setState(() {
                                    canLeaveFeedback = false;
                                    feedbackPagingController.refresh();
                                    feedbackPagingController.fetchNextPage();
                                  });
                                }
                              }),
                            ),
                          )
                          .paddingOnly(right: SpacingFoundation.horizontalSpacing16)
                      : const SizedBox.shrink(),
                ),
                content: _noFeedbacks
                    ? null
                    : UiKitHorizontalScrollableList<FeedbackUiModel>(
                        leftPadding: horizontalMargin,
                        spacing: SpacingFoundation.horizontalSpacing8,
                        shimmerLoadingChild: SizedBox(width: 0.95.sw, child: UiKitFeedbackCard()),
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
                              onAvatarTap: () => widget.onAvatarTap?.call(BaseUiKitUserTileData(
                                id: feedback.feedbackAuthorId,
                                type: feedback.feedbackAuthorType,
                              )),
                              title: feedback.feedbackAuthorName,
                              avatarUrl: feedback.feedbackAuthorPhoto,
                              userTileType: feedback.feedbackAuthorType,
                              datePosted: feedback.feedbackDateTime,
                              companyAnswered: false,
                              text: feedback.feedbackText,
                              rating: feedback.feedbackRating,
                              isHelpful: feedback.helpfulForUser,
                              media: feedback.media,
                              helpfulCount: feedback.helpfulCount == 0 ? null : feedback.helpfulCount,
                              onPressed: () async {
                                if (widget.onFeedbackTap != null) {
                                  await widget.onFeedbackTap?.call(feedback).then(
                                    (model) {
                                      if (model.isEdited) {
                                        feedbackPagingController.refresh();
                                        // feedbackPagingController.notifyPageRequestListeners(1);
                                      }
                                      final feedbackId = feedback.id;

                                      if ((model.countToUpdate ?? 0) > 0) {
                                        widget.likedReviews?.add(feedbackId);
                                        widget.onLikedFeedback?.call(feedbackId);
                                        _updateFeedbackList(feedbackId, 1);
                                      } else if ((model.countToUpdate ?? 0) < 0) {
                                        widget.likedReviews?.remove(feedbackId);
                                        widget.onDislikedFeedback?.call(feedbackId);
                                        _updateFeedbackList(feedbackId, -1);
                                      }

                                      setState(() {});
                                    },
                                  );
                                } else {
                                  feedback.onTap?.call();
                                }
                              },
                              onLike: cannotLeaveLike(feedback.feedbackAuthorId)
                                  ? null
                                  : () {
                                      final feedbackId = feedback.id;
                                      if (widget.likedReviews != null && widget.likedReviews!.contains(feedbackId)) {
                                        widget.likedReviews?.remove(feedbackId);
                                        widget.onDislikedFeedback?.call(feedbackId);
                                        _updateFeedbackList(feedbackId, -1);
                                      } else {
                                        widget.likedReviews?.add(feedbackId);
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
        if (widget.isInfluencer)
          SizedBox(
            height: 1.sw <= 380 ? 0.33.sw : 0.29.sw,
            child: Row(
              children: [
                Expanded(
                  child: UiKitInfluencerToolInContentCard(
                    group: _influencerGroup,
                    iconData: ShuffleUiKitIcons.record,
                    onTap: widget.onAddVoiceTap,
                    title: S.of(context).AddVoice,
                  ),
                ),
                SpacingFoundation.horizontalSpace12,
                Expanded(
                  child: UiKitInfluencerToolInContentCard(
                    group: _influencerGroup,
                    iconData: ShuffleUiKitIcons.conversation,
                    onTap: widget.onInterviewTap,
                    title: S.of(context).Interview,
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: horizontalMargin),
          ).paddingOnly(
            bottom: SpacingFoundation.verticalSpacing24,
          ),
        if (widget.voiceUiModels != null)
          ListenableBuilder(
            listenable: widget.voiceUiModels!,
            builder: (ctx, _) {
              if (widget.voiceUiModels?.value != null && widget.voiceUiModels!.value!.isNotEmpty) {
                final currentUiModel = widget.voiceUiModels?.value?.firstWhere((e) => e?.source != null);

                return AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  child: currentUiModel != null
                      ? VoiceInContentCard(
                          onUserTap: (user) =>
                              widget.onAvatarTap?.call(BaseUiKitUserTileData(id: user?.id, type: user?.userTileType)),
                          voice: currentUiModel,
                          onViewAllTap: widget.onViewAllVoicesTap,
                        ).paddingOnly(
                          bottom: SpacingFoundation.verticalSpacing24,
                          left: horizontalMargin,
                          right: horizontalMargin,
                        )
                      : SizedBox.shrink(),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        if (widget.event.descriptionItems != null)
          ...widget.event.descriptionItems!.map(
            (e) {
              final bool isSchedule = e.descriptionUrl == 'times' && widget.event.schedule != null;

              return GestureDetector(
                onTap: () {
                  if (isSchedule) {
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
                  showFullInfo: !isSchedule,
                ),
              ).paddingSymmetric(vertical: SpacingFoundation.verticalSpacing4, horizontal: horizontalMargin);
            },
          ),
        (kBottomNavigationBarHeight * 1.5).heightBox
      ],
    ).paddingSymmetric(
      vertical: (model.positionModel?.verticalMargin ?? 0).toDouble(),
    );
  }
}
