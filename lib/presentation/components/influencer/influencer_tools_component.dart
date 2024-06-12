import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/influencer/linear_influencer_indicator.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class InfluencerToolsComponent extends StatelessWidget {
  final List<String> newToolsInfluncerList;
  final List<InfluencerToolUiModel> influencerUiModelList;
  final Function() onTap;

  const InfluencerToolsComponent({
    super.key,
    required this.influencerUiModelList,
    required this.newToolsInfluncerList,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).YouWillReceiveNewTools,
            textAlign: TextAlign.center,
            style: theme?.boldTextTheme.title2,
          ).paddingSymmetric(vertical: SpacingFoundation.verticalSpacing16),
          SpacingFoundation.verticalSpace4,
          Text(
            '${S.of(context).YourNewTools}:',
            style: theme?.boldTextTheme.subHeadline,
          ),
          SpacingFoundation.verticalSpace16,
          Container(
            decoration: BoxDecoration(
              color: theme?.colorScheme.surface1,
              borderRadius: BorderRadiusFoundation.all24,
            ),
            child: Column(
              children: newToolsInfluncerList.map(
                (e) {
                  double padding = 0.0;
                  if (e != newToolsInfluncerList.last) padding = 16.0;

                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GradientableWidget(
                        gradient: GradientFoundation.starLinearGradient,
                        child: ImageWidget(
                          iconData: ShuffleUiKitIcons.gradientStar,
                          color: Colors.white,
                          width: 0.0625.sw,
                          height: 0.0625.sw,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SpacingFoundation.horizontalSpace8,
                      Expanded(
                        child: Text(
                          e,
                          style: theme?.boldTextTheme.body,
                        ),
                      ),
                    ],
                  ).paddingOnly(bottom: padding);
                },
              ).toList(),
            ).paddingAll(EdgeInsetsFoundation.all16),
          ),
          SpacingFoundation.verticalSpace24,
          Text(
            '${S.of(context).ToOpenTheNextSetOfToolsYouNeedToDo}:',
            style: theme?.boldTextTheme.subHeadline,
          ),
          SpacingFoundation.verticalSpace16,
          Container(
            decoration: BoxDecoration(
              color: theme?.colorScheme.surface1,
              borderRadius: BorderRadiusFoundation.all24,
            ),
            child: Column(
              children: influencerUiModelList.map(
                (e) {
                  double padding = 0.0;
                  if (e != influencerUiModelList.last) padding = 16.0;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${e.progress} ${e.title}',
                        style: theme?.boldTextTheme.body,
                      ),
                      SpacingFoundation.verticalSpace4,
                      Row(
                        children: [
                          Text(
                            S.of(context).YourProgress,
                            style: theme?.regularTextTheme.caption1,
                          ),
                          const Spacer(),
                          Text(
                            '${e.actualProgress}/${e.progress}',
                            style: theme?.regularTextTheme.caption1,
                          )
                        ],
                      ),
                      SpacingFoundation.verticalSpace2,
                      LinearInfluencerIndicator(
                        actualSum: e.actualProgress,
                        sum: e.progress,
                        width: 1.sw,
                      ),
                    ],
                  ).paddingOnly(bottom: padding);
                },
              ).toList(),
            ).paddingAll(EdgeInsetsFoundation.all16),
          ),
          SafeArea(
            top: false,
            child: context.gradientButton(
              data: BaseUiKitButtonData(
                fit: ButtonFit.fitWidth,
                text: S.of(context).Continue.toUpperCase(),
                onPressed: onTap,
              ),
            ),
          ).paddingSymmetric(vertical: SpacingFoundation.verticalSpacing24)
        ],
      ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16),
    );
  }
}

class InfluencerToolUiModel {
  final String title;
  final int progress;
  final int actualProgress;

  InfluencerToolUiModel({
    required this.title,
    required this.progress,
    required this.actualProgress,
  });
}
