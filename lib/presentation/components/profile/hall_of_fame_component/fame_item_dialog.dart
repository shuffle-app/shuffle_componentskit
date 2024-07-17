import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/influencer/linear_influencer_indicator.dart';
import 'dart:math' as math;
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FameItemDialog extends StatelessWidget {
  final UiRewardProgressModel? uiRewardProgressModel;
  final String? cachedPathForModel;
  final UiKitAchievementsModel uiKitAchievementsModel;

  const FameItemDialog({
    super.key,
    this.uiRewardProgressModel,
    this.cachedPathForModel,
    required this.uiKitAchievementsModel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    debugPrint('FameItemDialog build with obj path $cachedPathForModel and env as $cachedEnvImage');

    return Column(
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
          height: 0.7.sh,
          width: double.infinity,
          padding: EdgeInsets.all(EdgeInsetsFoundation.all24),
          color: theme?.colorScheme.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                uiKitAchievementsModel.title,
                style: theme?.boldTextTheme.title2,
              ),
              SizedBox(height: 1.sw <= 380 ? 25.h : 35.h),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.rotate(
                      angle: 45 * math.pi / 180,
                      child: SizedBox(
                        height: 0.6.sw,
                        width: 0.6.sw,
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
                        height: 0.8.sw,
                        width: 0.8.sw,
                        child: UiKitBase3DViewer(
                          key: UniqueKey(),
                          localPath: cachedPathForModel ?? uiKitAchievementsModel.objectUrl!,
                          poster: uiKitAchievementsModel.posterUrl,
                          // environmentImage: 'legacy',
                          // environmentImage:'https://shuffle-app-production.s3.eu-west-2.amazonaws.com/static-files/3dmodels/environments/environment1.jpeg',
                          // environmentImage: 'https://shuffle-app-production.s3.eu-west-2.amazonaws.com/static-files/3dmodels/environments/Vestibule+4k+HDR.hdr',
                          // cachedEnvImage ??
                          //     'aircraft_workshop_01_1k.hdr',
                          // skyboxImage:
                          //     'https://shuffle-app-production.s3.eu-west-2.amazonaws.com/static-files/3dmodels/environments/21.hdr',
                          autoRotate: true,
                          autoPlay: false,
                          onWebViewCreated: (controller){
                            controller.setJavaScriptMode(JavaScriptMode.unrestricted);
                            controller.setOnConsoleMessage((message) {
                              debugPrint('Console Message from FameItemDialog: $message');
                            });
                            controller.runJavaScript('''
                      var viewer = document.querySelector('#model-viewer');
                      viewer.setAttribute('tone-mapping', 'neutral');
                      viewer.setAttribute('environment-image', $cachedEnvImage);
                      
                      ''');
                            controller.reload();
                          },
                        )),
                  ],
                ),
              ),
              SpacingFoundation.verticalSpace16,
              if (uiKitAchievementsModel.description != null) ...[
                Text(
                  uiKitAchievementsModel.description!,
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
          ),
        )
      ],
    );
  }
}

String? cachedEnvImage;