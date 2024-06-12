import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/influencer/linear_influencer_indicator.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class ProgressBecomingInfluencerComponent extends StatelessWidget {
  final int reviewsProgress;
  final int videoReactionProgress;
  const ProgressBecomingInfluencerComponent({
    super.key,
    required this.reviewsProgress,
    required this.videoReactionProgress,
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
          color: theme?.colorScheme.inversePrimary,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${S.of(context).ToBecomeAnInfluencerYouNeedToDo}:',
                textAlign: TextAlign.center,
                style: theme?.boldTextTheme.title2.copyWith(color: theme.colorScheme.surface),
              ),
              SpacingFoundation.verticalSpace16,
              Text(
                S.of(context).CountReviews(50),
                style: theme?.boldTextTheme.title2.copyWith(color: theme.colorScheme.surface),
              ),
              SpacingFoundation.verticalSpace4,
              Row(
                children: [
                  Text(
                    S.of(context).YourProgress,
                    style: theme?.regularTextTheme.caption1.copyWith(color: theme.colorScheme.surface),
                  ),
                  const Spacer(),
                  Text(
                    '$reviewsProgress/50',
                    style: theme?.regularTextTheme.caption1.copyWith(color: theme.colorScheme.surface),
                  ),
                ],
              ),
              SpacingFoundation.verticalSpace2,
              LinearInfluencerIndicator(
                sum: 50,
                actualSum: reviewsProgress,
                width: 1.sw,
              ),
              SpacingFoundation.verticalSpace16,
              Text(
                S.of(context).CountVideoReaction(50),
                style: theme?.boldTextTheme.title2.copyWith(color: theme.colorScheme.surface),
              ),
              SpacingFoundation.verticalSpace4,
              Row(
                children: [
                  Text(
                    S.of(context).YourProgress,
                    style: theme?.regularTextTheme.caption1.copyWith(color: theme.colorScheme.surface),
                  ),
                  const Spacer(),
                  Text(
                    '$videoReactionProgress/50',
                    style: theme?.regularTextTheme.caption1.copyWith(color: theme.colorScheme.surface),
                  ),
                ],
              ),
              SpacingFoundation.verticalSpace2,
              LinearInfluencerIndicator(
                sum: 50,
                actualSum: videoReactionProgress,
                width: 1.sw,
              ),
            ],
          ).paddingAll(EdgeInsetsFoundation.all24),
        ),
      ],
    ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16);
  }
}
