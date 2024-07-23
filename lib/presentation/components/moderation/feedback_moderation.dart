import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class FeedbackModeration extends StatefulWidget {
  final Function() sortFunction;
  final List<FeedbackModerationUiModel> feedbackUiModelList;

  const FeedbackModeration({
    super.key,
    required this.sortFunction,
    required this.feedbackUiModelList,
  });

  @override
  State<FeedbackModeration> createState() => _FeedbackModerationState();
}

class _FeedbackModerationState extends State<FeedbackModeration> {
  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final textTheme = theme?.boldTextTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme?.colorScheme.surface,
        borderRadius: BorderRadiusFoundation.all24,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                S.of(context).Feedback,
                style: textTheme?.title1,
              ),
              const Spacer(),
              context.iconButtonNoPadding(
                data: BaseUiKitButtonData(
                  onPressed: widget.sortFunction,
                  iconInfo: BaseUiKitButtonIconData(
                    iconData: ShuffleUiKitIcons.arrowssort,
                  ),
                ),
              )
            ],
          ).paddingAll(EdgeInsetsFoundation.all24),
          Expanded(
            child: ListView(
              padding: EdgeInsetsDirectional.zero,
              children: List.generate(
                widget.feedbackUiModelList.length,
                (index) {
                  final feedbackUiModel = widget.feedbackUiModelList[index];
                  final bool companyFeedbackIsNotEmpty = widget
                      .feedbackUiModelList[index]
                      .companyFeedbackItemUiModel
                      .isNotEmpty;
                  return FeedbackItem(
                    feedBackModel: feedbackUiModel.feedbackItemUiModel,
                    companyFeedbackItemUiModel:
                        feedbackUiModel.companyFeedbackItemUiModel,
                    showExpand: companyFeedbackIsNotEmpty,
                  ).paddingOnly(
                    bottom: SpacingFoundation.verticalSpacing24,
                  );
                },
              ),
            ).paddingSymmetric(
                horizontal: SpacingFoundation.horizontalSpacing24),
          )
        ],
      ),
    );
  }
}

class FeedbackItem extends StatefulWidget {
  final FeedbackItemUiModel feedBackModel;
  final List<FeedbackItemUiModel>? companyFeedbackItemUiModel;
  final bool showExpand;
  final bool? isLast;
  final VoidCallback? onExpandedTap;

  const FeedbackItem({
    super.key,
    required this.feedBackModel,
    required this.showExpand,
    this.companyFeedbackItemUiModel,
    this.isLast,
    this.onExpandedTap,
  });

  @override
  State<FeedbackItem> createState() => _FeedbackItemState();
}

class _FeedbackItemState extends State<FeedbackItem> {
  bool showExpandIsTap = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: UiKitFeedbackCard(
                avatarSize: kIsWeb ? const Size(40, 40) : null,
                avatarUrl: widget.feedBackModel.avatarUrl,
                title: widget.feedBackModel.title,
                datePosted: widget.feedBackModel.datePosted
                    ?.subtract(const Duration(days: 2)),
                rating: widget.feedBackModel.rating,
                companyAnswered: widget.feedBackModel.companyAnswered,
                helpfulCount: widget.feedBackModel.helpfulCount,
                text: widget.feedBackModel.text,
                maxLines: 20,
              ),
            ),
            SpacingFoundation.horizontalSpace16,
            Expanded(
              child: UiKitFeedbackInfo(
                isModerated: widget.feedBackModel.isModerated,
                onModerated: widget.feedBackModel.onModerated,
                dateTime: widget.feedBackModel.datePosted ?? DateTime.now(),
                removeFunction: widget.feedBackModel.removeFunction,
                userName: widget.feedBackModel.title ?? '',
                expandThreadIsOpen: showExpandIsTap,
                responsesFromCompanyToReview: getShowExpandValue(
                    currentValue: showExpandIsTap,
                    isExpanded: widget.showExpand),
                onSubmit: (widget.isLast ?? false)
                    ? widget.onExpandedTap!
                    : () {
                        setState(() {
                          showExpandIsTap = !showExpandIsTap;
                        });
                      },
              ),
            ),
          ],
        ),
        if (showExpandIsTap) ...[
          SpacingFoundation.verticalSpace24,
          ...List.generate(
            widget.companyFeedbackItemUiModel?.length ?? 0,
            (index) {
              return FeedbackItem(
                feedBackModel: widget.companyFeedbackItemUiModel![index],
                showExpand:
                    index == widget.companyFeedbackItemUiModel!.length - 1,
                onExpandedTap:
                    index == widget.companyFeedbackItemUiModel!.length - 1
                        ? () {
                            setState(() {
                              showExpandIsTap = !showExpandIsTap;
                            });
                          }
                        : null,
                isLast: index == widget.companyFeedbackItemUiModel!.length - 1,
              ).paddingOnly(
                bottom: SpacingFoundation.verticalSpacing24,
              );
            },
          ),
        ]
      ],
    );
  }
}

class FeedbackModerationUiModel {
  final FeedbackItemUiModel feedbackItemUiModel;
  final List<FeedbackItemUiModel> companyFeedbackItemUiModel;

  FeedbackModerationUiModel({
    required this.feedbackItemUiModel,
    required this.companyFeedbackItemUiModel,
  });
}

class FeedbackItemUiModel {
  final String? title;
  final String? avatarUrl;
  final DateTime? datePosted;
  final int? rating;
  final bool? companyAnswered;
  final int? helpfulCount;
  final String? text;
  final bool isModerated;
  final VoidCallback onModerated;
  final VoidCallback removeFunction;

  FeedbackItemUiModel({
    required this.title,
    required this.avatarUrl,
    required this.datePosted,
    required this.rating,
    required this.companyAnswered,
    required this.helpfulCount,
    required this.text,
    required this.removeFunction,
    required this.isModerated,
    required this.onModerated,
  });
}

bool getShowExpandValue(
    {required bool isExpanded, required bool currentValue, bool? isLast}) {
  if (isLast != null) {
    return true;
  } else if (!isExpanded) {
    return false;
  } else if (isExpanded && currentValue) {
    return false;
  } else if (isExpanded && !currentValue) {
    return true;
  }
  return false;
}
