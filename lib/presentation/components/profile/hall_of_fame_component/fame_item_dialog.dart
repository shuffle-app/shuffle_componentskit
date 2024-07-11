import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/influencer/linear_influencer_indicator.dart';
import 'dart:math' as math;
import 'package:shuffle_uikit/shuffle_uikit.dart';

class FameItemDialog extends StatelessWidget {
  final UiRewardProgressModel? uiRewardProgressModel;
  final String filePath;
  final String filePoster;
  final String? description;

  const FameItemDialog({
    super.key,
    this.uiRewardProgressModel,
    this.description,
    required this.filePath,
    required this.filePoster,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: ImageWidget(
            iconData: ShuffleUiKitIcons.cross,
            color: theme?.colorScheme.darkNeutral900,
            height: 19.h,
            fit: BoxFit.fitHeight,
          ),
        ),
        SpacingFoundation.verticalSpace16,
        UiKitCardWrapper(
          color: theme?.colorScheme.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                uiRewardProgressModel?.title ?? S.of(context).NothingFound,
                style: theme?.boldTextTheme.title2,
              ),
              SizedBox(height: 35.h),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.rotate(
                      angle: 45 * math.pi / 180,
                      child: SizedBox(
                        height: 1.sw <= 380 ? 150 : 250,
                        width: 1.sw <= 380 ? 150 : 250,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadiusFoundation.all24r,
                            color: ColorsFoundation.darkNeutral100.withOpacity(0.16),
                            backgroundBlendMode: BlendMode.plus,
                            gradient: GradientFoundation.fameLinearGradient,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1.sw <= 380 ? 150 : 250,
                      width: 1.sw <= 380 ? 150 : 250,
                      child: UiKitBase3DViewer(
                        localPath: filePath,
                        poster: filePoster,
                        autoRotate: true,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50.h),
              if (description != null) ...[
                Text(
                  description!,
                  style: theme?.regularTextTheme.caption2,
                ),
              ],
              if (uiRewardProgressModel != null && uiRewardProgressModel?.total != null) ...[
                SpacingFoundation.verticalSpace16,
                Text(
                  S.of(context).ReviewsCount(uiRewardProgressModel?.total?.toInt() ?? 1),
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
                      '${uiRewardProgressModel?.current?.toInt() ?? 0}/${uiRewardProgressModel?.total?.toInt() ?? 1}',
                      style: theme?.regularTextTheme.caption1,
                    ),
                  ],
                ),
                SpacingFoundation.verticalSpace2,
                LinearInfluencerIndicator(
                  width: 0.7.sw,
                  actualSum: uiRewardProgressModel?.current ?? 0.0,
                  sum: uiRewardProgressModel?.total ?? 1.0,
                ),
              ]
            ],
          ).paddingAll(EdgeInsetsFoundation.all24),
        )
      ],
    );
  }
}