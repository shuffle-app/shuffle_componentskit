import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class FeedBackModeration extends StatelessWidget {
  final Function() deleteFunction;
  final Function() sortFunction;
  final List<FeedbackModerationUiModel> feedbackUiModelList;

  const FeedBackModeration({
    super.key,
    required this.deleteFunction,
    required this.sortFunction,
    required this.feedbackUiModelList,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final textTheme = theme?.boldTextTheme;

    //TODO remove safeArea
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: theme?.colorScheme.surface,
          borderRadius: BorderRadiusFoundation.all24,
        ),
        child: Column(
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
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
                    onPressed: deleteFunction,
                  ),
                ),
                SpacingFoundation.horizontalSpace12,
                context.iconButtonNoPadding(
                  data: BaseUiKitButtonData(
                    onPressed: sortFunction,
                    iconInfo: BaseUiKitButtonIconData(
                      iconData: ShuffleUiKitIcons.arrowssort,
                    ),
                  ),
                )
              ],
            ).paddingAll(EdgeInsetsFoundation.all24),
            Expanded(
              child: ListView.builder(
                itemCount: feedbackUiModelList.length,
                itemBuilder: (context, index) {
                  final feedBackModel = feedbackUiModelList[index];

                  return Row(
                    children: [
                      Expanded(
                        child: UiKitFeedbackCard(
                          avatarUrl: feedBackModel.avatarUrl,
                          title: feedBackModel.title,
                          datePosted: feedBackModel.datePosted
                              ?.subtract(const Duration(days: 2)),
                          rating: feedBackModel.rating,
                          companyAnswered: feedBackModel.companyAnswered,
                          helpfulCount: feedBackModel.helpfulCount,
                          text: feedBackModel.text,
                          onPressed: feedBackModel.onPressed,
                          onLike: feedBackModel.onLike,
                        ),
                      ),
                      Expanded(
                        child: UiKitFeedbackInfo(
                          dateTime: feedBackModel.datePosted ?? DateTime.now(),
                          removeFunction: feedBackModel.removeFunction,
                          userName: feedBackModel.title ?? '',
                          showExpand: feedBackModel.showExpand,
                        ),
                      ),
                    ],
                  ).paddingOnly(
                    bottom: SpacingFoundation.verticalSpacing24,
                    left: SpacingFoundation.horizontalSpacing24,
                    right: SpacingFoundation.horizontalSpacing24,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FeedbackModerationUiModel {
  final String? title;
  final String? avatarUrl;
  final DateTime? datePosted;
  final int? rating;
  final bool? companyAnswered;
  final int? helpfulCount;
  final String? text;
  final VoidCallback? onLike;
  final VoidCallback? onPressed;
  final VoidCallback removeFunction;
  final bool showExpand;

  FeedbackModerationUiModel({
    required this.title,
    required this.avatarUrl,
    required this.datePosted,
    required this.rating,
    required this.companyAnswered,
    required this.helpfulCount,
    required this.text,
    required this.onLike,
    required this.onPressed,
    required this.removeFunction,
    this.showExpand = false,
  });
}
