import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import 'linear_influencer_indicator.dart';

showCompleteInfluencerDialog({
  required BuildContext context,
  int? actualReviewProgress,
  int? maxReviewProgress,
  int? actualVideoReactionProgress,
  int? maxVideoReactionProgress,
}) {
  final theme = context.uiKitTheme;
  final width = 1.sw <= 380 ? 0.4.sw : 0.44.sw;

  showGeneralDialog(
    transitionBuilder: (context, animation1, animation2, child) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: animation1.value * 30, sigmaY: animation1.value * 30),
      child: child,
    ),
    transitionDuration: const Duration(milliseconds: 200),
    context: context,
    pageBuilder: (context, animation1, animation2) {
      return Dialog(
        insetPadding: EdgeInsets.all(EdgeInsetsFoundation.all16),
        backgroundColor: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusFoundation.all24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: context.pop,
              child: ImageWidget(
                iconData: ShuffleUiKitIcons.cross,
                color: theme?.colorScheme.darkNeutral900,
                height: 19.h,
                fit: BoxFit.fitHeight,
              ),
            ),
            SpacingFoundation.verticalSpace16,
            UiKitCardWrapper(
              padding: EdgeInsets.all(EdgeInsetsFoundation.all24),
              color: theme?.colorScheme.inversePrimary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).YouProgressed,
                    style: theme?.boldTextTheme.title2.copyWith(color: theme.colorScheme.primary),
                  ),
                  SpacingFoundation.verticalSpace16,
                  Text(
                    S.of(context).AvailableSoon,
                    style: theme?.regularTextTheme.body.copyWith(color: theme.colorScheme.primary),
                  ),
                  SpacingFoundation.verticalSpace16,
                  Row(
                    children: [
                      ImageWidget(
                        link: GraphicsFoundation.instance.png.chess3Nobg.path,
                        width: 0.3.sw,
                        height: 0.3.sw,
                      ),
                      SpacingFoundation.horizontalSpace16,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: width,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    S.of(context).Reviews,
                                    style:
                                        theme?.boldTextTheme.caption3Medium.copyWith(color: theme.colorScheme.primary),
                                  ),
                                ),
                                Text(
                                  '${actualReviewProgress ?? 50}/${maxReviewProgress ?? 50}',
                                  style:
                                      theme?.boldTextTheme.caption3Medium.copyWith(color: ColorsFoundation.mutedText),
                                ),
                              ],
                            ),
                          ),
                          SpacingFoundation.verticalSpace2,
                          LinearInfluencerIndicator(
                            sum: maxReviewProgress?.toDouble() ?? 50,
                            actualSum: actualReviewProgress?.toDouble() ?? 50,
                            width: width,
                          ),
                          SpacingFoundation.verticalSpace8,
                          SizedBox(
                            width: width,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    S.of(context).VideoReactions,
                                    style:
                                        theme?.boldTextTheme.caption3Medium.copyWith(color: theme.colorScheme.primary),
                                  ),
                                ),
                                Text(
                                  '${actualVideoReactionProgress ?? 50}/${maxVideoReactionProgress ?? 50}',
                                  style:
                                      theme?.boldTextTheme.caption3Medium.copyWith(color: ColorsFoundation.mutedText),
                                ),
                              ],
                            ),
                          ),
                          SpacingFoundation.verticalSpace2,
                          LinearInfluencerIndicator(
                            sum: maxVideoReactionProgress?.toDouble() ?? 50,
                            actualSum: actualVideoReactionProgress?.toDouble() ?? 50,
                            width: width,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      );
    },
  );
}
