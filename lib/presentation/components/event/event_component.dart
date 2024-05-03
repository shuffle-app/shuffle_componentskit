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
  final VoidCallback? onAddReactionTapped;
  final PagedLoaderCallback<VideoReactionUiModel> reactionsLoaderCallback;
  final PagedLoaderCallback<FeedbackUiModel> feedbackLoaderCallback;
  final ComplaintFormComponent? complaintFormComponent;
  final ValueChanged<VideoReactionUiModel>? onReactionTap;

  const EventComponent({
    Key? key,
    required this.event,
    required this.reactionsLoaderCallback,
    required this.feedbackLoaderCallback,
    this.complaintFormComponent,
    this.isEligibleForEdit = false,
    this.onEditPressed,
    this.onSharePressed,
    this.onReactionTap,
    this.onAddReactionTapped,
  }) : super(key: key);

  @override
  State<EventComponent> createState() => _EventComponentState();
}

class _EventComponentState extends State<EventComponent> {
  final reactionsPagingController = PagingController<int, VideoReactionUiModel>(firstPageKey: 1);

  final feedbackPagingController = PagingController<int, FeedbackUiModel>(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _onReactionsPageRequest(1);
      reactionsPagingController.addPageRequestListener(_onReactionsPageRequest);
      _onFeedbackPageRequest(1);
      feedbackPagingController.addPageRequestListener(_onFeedbackPageRequest);
    });
  }

  Future<void> _onReactionsPageRequest(int page) async {
    final data = await widget.reactionsLoaderCallback(page);

    if (data.isEmpty) {
      reactionsPagingController.appendLastPage(data);
      return;
    }
    if (data.last.empty) {
      data.removeLast();
      reactionsPagingController.appendLastPage(data);
    } else {
      reactionsPagingController.appendPage(data, page + 1);
    }
  }

  Future<void> _onFeedbackPageRequest(int page) async {
    final data = await widget.feedbackLoaderCallback(page);
    if (data.isEmpty) {
      feedbackPagingController.appendLastPage(data);
      return;
    }
    if (data.last.empty) {
      data.removeLast();
      feedbackPagingController.appendLastPage(data);
    } else {
      feedbackPagingController.appendPage(data, page + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentEventModel model = kIsWeb
        ? ComponentEventModel(
            version: '0',
            pageBuilderType: PageBuilderType.page,
            positionModel: PositionModel(bodyAlignment: Alignment.topLeft, version: '', horizontalMargin: 16, verticalMargin: 10))
        : ComponentEventModel.fromJson(config['event']);

    final theme = context.uiKitTheme;
    final titleAlignment = model.positionModel?.titleAlignment;
    final colorScheme = theme?.colorScheme;
    final boldTextTheme = theme?.boldTextTheme;
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();

    return ListView(
      physics: const ClampingScrollPhysics(),
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
                      width: 1.sw - (horizontalMargin + 28.w),
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
                      color: Colors.white.withOpacity(0.01),
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
              child: DescriptionWidget(description: widget.event.description!).paddingSymmetric(horizontal: horizontalMargin)),
          SpacingFoundation.verticalSpace16
        ],
        SpacingFoundation.verticalSpace16,
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
        SpacingFoundation.verticalSpace24,
        ValueListenableBuilder(
          valueListenable: reactionsPagingController,
          builder: (context, value, child) {
            if (reactionsPagingController.itemList?.isNotEmpty ?? false) {
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
                  shimmerLoadingChild: const UiKitReactionPreview(imagePath: ''),
                  itemBuilder: (context, reaction, index) {
                    if (index == 0) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          horizontalMargin.widthBox,
                          UiKitReactionPreview.empty(onTap: widget.onAddReactionTapped),
                          SpacingFoundation.horizontalSpace12,
                          UiKitReactionPreview(
                            imagePath: reaction.previewImageUrl ?? '',
                            viewed: false,
                            onTap: () => widget.onReactionTap?.call(reaction),
                          ),
                        ],
                      );
                    }

                    return UiKitReactionPreview(
                      imagePath: reaction.previewImageUrl ?? '',
                      viewed: false,
                      onTap: () => widget.onReactionTap?.call(reaction),
                    ).paddingOnly(left: index == 0 ? horizontalMargin : 0);
                  },
                  pagingController: reactionsPagingController,
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        SpacingFoundation.verticalSpace24,
        ValueListenableBuilder(
          valueListenable: feedbackPagingController,
          builder: (context, value, child) {
            if (feedbackPagingController.itemList?.isNotEmpty ?? false) {
              return UiKitColoredAccentBlock(
                contentHeight: 0.28.sh,
                color: colorScheme?.surface1,
                title: Text(
                  S.current.ReactionsByCritics,
                  style: boldTextTheme?.body,
                ),
                content: UiKitHorizontalScrollableList<FeedbackUiModel>(
                  leftPadding: horizontalMargin,
                  spacing: SpacingFoundation.horizontalSpacing8,
                  shimmerLoadingChild: SizedBox(width: 0.85.sw, child: const UiKitFeedbackCard()),
                  itemBuilder: (context, feedback, index) {
                    return SizedBox(
                      width: 0.85.sw,
                      child: UiKitFeedbackCard(
                        title: feedback.feedbackAuthorName,
                        avatarUrl: feedback.feedbackAuthorPhoto,
                        datePosted: feedback.feedbackDateTime,
                        companyAnswered: false,
                        text: feedback.feedbackText,
                      ).paddingOnly(left: index == 0 ? horizontalMargin : 0),
                    );
                  },
                  pagingController: feedbackPagingController,
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        (kBottomNavigationBarHeight * 1.5).heightBox
      ],
    ).paddingSymmetric(
      vertical: (model.positionModel?.verticalMargin ?? 0).toDouble(),
    );
  }
}
