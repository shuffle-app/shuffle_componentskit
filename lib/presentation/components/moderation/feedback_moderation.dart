import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class FeedbackModeration extends StatefulWidget {
  final Function() deleteFunction;
  final Function() sortFunction;
  final List<FeedbackModerationUiModel> feedbackUiModelList;

  const FeedbackModeration({
    super.key,
    required this.deleteFunction,
    required this.sortFunction,
    required this.feedbackUiModelList,
  });

  @override
  State<FeedbackModeration> createState() => _FeedbackModerationState();
}

class _FeedbackModerationState extends State<FeedbackModeration> {
  bool showCompanyItem = false;

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
              context.coloredButtonWithBorderRadius(
                data: BaseUiKitButtonData(
                  fit: ButtonFit.hugContent,
                  textColor: theme?.colorScheme.inversePrimary,
                  backgroundColor:
                      theme?.colorScheme.darkNeutral900.withOpacity(0.68),
                  text: S.of(context).ShowDeleted,
                  onPressed: widget.deleteFunction,
                ),
              ),
              SpacingFoundation.horizontalSpace12,
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
            child: ListView.builder(
              padding: EdgeInsetsDirectional.zero,
              itemCount: widget.feedbackUiModelList.length,
              itemBuilder: (context, index) {
                final feedbackUiModel = widget.feedbackUiModelList[index];
                final bool companyFeedbackIsNotEmpty = widget
                    .feedbackUiModelList[index]
                    .companyFeedbackItemUiModel
                    .isNotEmpty;

                return Column(
                  children: [
                    FeedbackItem(
                      feedBackModel: feedbackUiModel.feedbackItemUiModel,
                      showExpand: companyFeedbackIsNotEmpty,
                      onSubmit: (showExpandIsTap) {
                        setState(() {
                          showCompanyItem = showExpandIsTap;
                        });
                      },
                    ).paddingOnly(
                      bottom: SpacingFoundation.verticalSpacing24,
                    ),
                    if (showCompanyItem) ...[
                      Column(
                        children: List.generate(
                          feedbackUiModel.companyFeedbackItemUiModel.length,
                          (index) {
                            return FeedbackItem(
                              feedBackModel: feedbackUiModel
                                  .companyFeedbackItemUiModel[index],
                              showExpand: false,
                            ).paddingOnly(
                              bottom: SpacingFoundation.verticalSpacing24,
                            );
                          },
                        ),
                      )
                    ],
                  ],
                );
              },
            ).paddingSymmetric(
                horizontal: SpacingFoundation.horizontalSpacing24),
          )
        ],
      ),
    );
  }
}

class FeedbackItem extends StatelessWidget {
  final FeedbackItemUiModel feedBackModel;
  final bool showExpand;
  final Function(bool showExpandIsTap)? onSubmit;

  const FeedbackItem({
    super.key,
    required this.feedBackModel,
    required this.showExpand,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: UiKitFeedbackCard(
            avatarSize: kIsWeb ? const Size(40, 40) : null,
            avatarUrl: feedBackModel.avatarUrl,
            title: feedBackModel.title,
            datePosted:
                feedBackModel.datePosted?.subtract(const Duration(days: 2)),
            rating: feedBackModel.rating,
            companyAnswered: feedBackModel.companyAnswered,
            helpfulCount: feedBackModel.helpfulCount,
            text: feedBackModel.text,
          ),
        ),
        SpacingFoundation.horizontalSpace16,
        Expanded(
          child: UiKitFeedbackInfo(
            dateTime: feedBackModel.datePosted ?? DateTime.now(),
            removeFunction: feedBackModel.removeFunction,
            userName: feedBackModel.title ?? '',
            responsesFromCompanytoReview: showExpand,
            onSubmit: (expandThreadIsOpen) {
              if (onSubmit != null) {
                onSubmit!(expandThreadIsOpen);
              }
            },
          ),
        ),
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
  });
}
