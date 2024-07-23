import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/domain/domain.dart';
import 'package:shuffle_components_kit/presentation/components/feed/uifeed_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class ReactionViewComponent extends StatelessWidget {
  final VideoReactionUiModel videoReactionModel;
  final VoidCallback? onSwipeUp;
  final VoidCallback? onSwipeDown;
  final VoidCallback? onSingleTapRight;
  final VoidCallback? onSingleTapLeft;
  final UiUniversalModel content;
  final VoidCallback? onPlaceNameTapped;
  final VoidCallback? onVideoLiked;
  final VoidCallback? onVideoDisliked;
  final VoidCallback? onSeeMorePopOverCallback;
  final bool Function()? onAuthorTapped;
  final VoidCallback? onVideoStarted;

  ReactionViewComponent({
    super.key,
    required this.videoReactionModel,
    required this.content,
    this.onSwipeUp,
    this.onSwipeDown,
    this.onSeeMorePopOverCallback,
    this.onPlaceNameTapped,
    this.onAuthorTapped,
    this.onSingleTapRight,
    this.onSingleTapLeft,
    this.onVideoStarted,
    this.onVideoLiked,
    this.onVideoDisliked,
  });

  final videoProgressNotifier = ValueNotifier<double>(0);

  bool get swipeActionEnabled => onSwipeUp != null;

  bool get contentIsEvent => videoReactionModel.isReactionForEvent;

  bool get contentIsPlace => videoReactionModel.isReactionForPlace;

  bool get canSwipeUp => (videoReactionModel.eventDate?.isAfter(DateTime.now()) ?? true) && swipeActionEnabled;

  void _verticalSwipeHandler(DragEndDetails details) {
    if (details.velocity.pixelsPerSecond.dy < 0 && canSwipeUp) {
      onSwipeUp?.call();
    }
    if (details.velocity.pixelsPerSecond.dy > 100 && onSwipeDown != null) {
      onSwipeDown?.call();
    }
  }

  void _tapUpHandler(TapUpDetails details) {
    if (details.globalPosition.dx > 0.8.sw && onSingleTapRight != null) {
      onSingleTapRight?.call();
    } else if (details.globalPosition.dx < 0.2.sw && onSingleTapLeft != null) {
      onSingleTapLeft?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;

    return Stack(
      fit: StackFit.expand,
      children: [
        UiKitFullScreenPortraitVideoPlayer(
          videoUrl: videoReactionModel.videoUrl!,
          coverImageUrl: videoReactionModel.previewImageUrl,
          onProgressChanged: (progress) => videoProgressNotifier.value = progress,
          onTapUp: _tapUpHandler,
          onVerticalSwipe: _verticalSwipeHandler,
          onVideoComplete: onSingleTapRight,
          onVideoInited: onVideoStarted,
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
          left: SpacingFoundation.horizontalSpacing16,
          top: kToolbarHeight,
          child: AnimatedBuilder(
            animation: videoProgressNotifier,
            builder: (context, child) {
              return UiKitProgressIndicator(
                backgroundColor: ColorsFoundation.neutral40,
                color: Colors.white,
                progress: videoProgressNotifier.value,
                width: 1.sw - EdgeInsetsFoundation.horizontal32,
              );
            },
          ),
        ),
        Positioned(
          top: kToolbarHeight + SpacingFoundation.verticalSpacing8,
          width: 1.sw,
          child: UiKitVideoReactionTile(
            onSeeMorePopOverCallback: onSeeMorePopOverCallback,
            canNavigateToPublicProfile: onAuthorTapped,
            onPlaceNameTapped: onPlaceNameTapped,
            authorAvatarUrl: videoReactionModel.authorAvatarUrl,
            authorName: videoReactionModel.authorName,
            authorType: videoReactionModel.authorType,
            reactionDate: videoReactionModel.videoReactionDateTime,
            placeName: videoReactionModel.placeName,
            eventName: contentIsEvent && onSwipeUp != null ? content.title : null,
            eventDate: videoReactionModel.eventDate,
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
                  onPressed: () {
                    onVideoDisliked?.call();
                    FeedbackIsolate.instance.addEvent(FeedbackIsolateHaptics(
                      intensities: [170, 200],
                      pattern: [10, 5],
                    ));
                  },
                  iconInfo: BaseUiKitButtonIconData(
                    iconData: ShuffleUiKitIcons.heartbrokenfill,
                    color: Colors.white,
                  ),
                ),
              ),
              SpacingFoundation.horizontalSpace20,
              Expanded(
                child: GestureDetector(
                  onTapUp: _tapUpHandler,
                  onVerticalDragEnd: _verticalSwipeHandler,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: canSwipeUp
                        ? [
                            SpacingFoundation.verticalSpace24,
                            ImageWidget(
                              iconData: ShuffleUiKitIcons.chevronuplong,
                              color: Colors.white,
                              width: 48.w,
                            ),
                            SpacingFoundation.verticalSpace16,
                            Text(
                              contentIsPlace ? S.current.MoreAboutThisPlace : S.current.MoreAboutThisEvent,
                              style: boldTextTheme?.body,
                              textAlign: TextAlign.center,
                            ),
                          ]
                        : [],
                  ),
                ),
              ),
              if (videoReactionModel.eventDate?.isBefore(DateTime.now()) ?? false) const Expanded(child: Column()),
              SpacingFoundation.horizontalSpace20,
              context.bouncingButton(
                blurred: true,
                small: true,
                data: BaseUiKitButtonData(
                  onPressed: () {
                    onVideoLiked?.call();
                    FeedbackIsolate.instance.addEvent(FeedbackIsolateHaptics(
                      intensities: [170, 200],
                      pattern: [10, 5],
                    ));
                  },
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
