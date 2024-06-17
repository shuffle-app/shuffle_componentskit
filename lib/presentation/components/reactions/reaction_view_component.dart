import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/domain/domain.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class ReactionViewComponent extends StatelessWidget {
  final VideoReactionUiModel videoReactionModel;

  const ReactionViewComponent({
    Key? key,
    required this.videoReactionModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;

    return Stack(
      fit: StackFit.expand,
      children: [
        UiKitFullScreenPortraitVideoPlayer(
          videoUrl: videoReactionModel.videoUrl!,
          coverImageUrl: videoReactionModel.previewImageUrl,
        ),
        Positioned(
          top: 0,
          child: Container(
            height: 0.18.sh,
            width: 1.sw,
            decoration: const BoxDecoration(
              gradient: GradientFoundation.blackLinearGradientInverted,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            height: 0.18.sh,
            width: 1.sw,
            decoration: const BoxDecoration(
              gradient: GradientFoundation.blackLinearGradient,
            ),
          ),
        ),
        Positioned(
          top: 0,
          child: Container(
            width: 1.sw,
            height: kToolbarHeight,
            decoration: const BoxDecoration(
              // color: Colors.black,
              gradient: GradientFoundation.blackLinearGradientInverted,
            ),
          ),
        ),
        Positioned(
          top: kToolbarHeight,
          width: 1.sw,
          child: UiKitVideoReactionTile(
            authorAvatarUrl: videoReactionModel.authorAvatarUrl,
            authorName: videoReactionModel.authorName,
            reactionDate: videoReactionModel.videoReactionDateTime,
            placeName: videoReactionModel.placeName,
            eventDate: videoReactionModel.eventDate,
            eventName: videoReactionModel.eventName,
          ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
        ),
        Positioned(
          width: 1.sw,
          bottom: SpacingFoundation.verticalSpacing24 + SpacingFoundation.verticalSpacing16,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              context.bouncingButton(
                blurred: true,
                small: true,
                data: BaseUiKitButtonData(
                  onPressed: () {},
                  iconInfo: BaseUiKitButtonIconData(
                    iconData: ShuffleUiKitIcons.heartbrokenfill,
                    color: Colors.white,
                  ),
                ),
              ),
              SpacingFoundation.horizontalSpace20,
              if (videoReactionModel.eventDate?.isAfter(DateTime.now()) ?? true)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SpacingFoundation.verticalSpace24,
                      const ImageWidget(
                        iconData: ShuffleUiKitIcons.chevronup,
                        color: Colors.white,
                        width: 48,
                      ),
                      SpacingFoundation.verticalSpace16,
                      Text(
                        videoReactionModel.eventName == null
                            ? S.current.MoreAboutThisPlace
                            : S.current.MoreAboutThisEvent,
                        style: boldTextTheme?.body,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              if (videoReactionModel.eventDate?.isBefore(DateTime.now()) ?? false) const Expanded(child: Column()),
              SpacingFoundation.horizontalSpace20,
              context.bouncingButton(
                blurred: true,
                small: true,
                data: BaseUiKitButtonData(
                  onPressed: () {},
                  iconInfo: BaseUiKitButtonIconData(
                    iconData: ShuffleUiKitIcons.heartfill,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
        ),
      ],
    );
  }
}
