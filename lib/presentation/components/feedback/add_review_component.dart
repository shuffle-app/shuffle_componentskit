import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class AddReviewComponent extends StatelessWidget {
  final VoidCallback? onConfirm;
  final int? feedbackRating;
  final String feedbackOwnerName;
  final String? feedbackOwnerImage;
  final String? feedbackDate;
  final UserTileType feedbackOwnerType;
  final TextEditingController reviewController;

  const AddReviewComponent({
    Key? key,
    required this.feedbackOwnerName,
    required this.feedbackOwnerType,
    required this.reviewController,
    this.onConfirm,
    this.feedbackRating,
    this.feedbackOwnerImage,
    this.feedbackDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;
    Widget feedbackOwnerAccountMark = const SizedBox.shrink();
    if (feedbackOwnerType == UserTileType.influencer) feedbackOwnerAccountMark = InfluencerAccountMark();
    if (feedbackOwnerType == UserTileType.pro) feedbackOwnerAccountMark = ProAccountMark();
    if (feedbackOwnerType == UserTileType.premium) feedbackOwnerAccountMark = PremiumAccountMark();

    return Scaffold(
      body: BlurredAppBarPage(
        autoImplyLeading: true,
        centerTitle: true,
        title: S.current.AddReview,
        childrenPadding: EdgeInsets.symmetric(horizontal: EdgeInsetsFoundation.horizontal16),
        children: [
          SpacingFoundation.verticalSpace24,
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              context.userAvatar(
                size: UserAvatarSize.x24x24,
                type: UserTileType.influencer,
                userName: feedbackOwnerName,
                imageUrl: feedbackOwnerImage,
              ),
              SpacingFoundation.horizontalSpace12,
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          feedbackOwnerName,
                          style: boldTextTheme?.caption1Bold,
                        ),
                        SpacingFoundation.horizontalSpace8,
                        feedbackOwnerAccountMark,
                      ],
                    ),
                    Text(
                      feedbackDate ?? '',
                      style: boldTextTheme?.caption1Medium,
                    ),
                  ],
                ),
              ),
              SpacingFoundation.horizontalSpace12,
              UiKitRatingBadge(rating: feedbackRating ?? 0),
            ],
          ),
          SpacingFoundation.verticalSpace24,
          UiKitTitledWrappedInput(
            input: UiKitSymbolsCounterInputField(
              controller: reviewController,
              maxLines: 5,
              hintText: S.current.AddReviewFieldHint,
              enabled: true,
              obscureText: false,
              maxSymbols: 500,
            ),
            title: S.current.AddReviewFieldTitle,
            popOverMessage: S.current.AddReviewPopOverText,
          ),
        ],
      ),
      bottomNavigationBar: KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(animation),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            ),
            child: isKeyboardVisible
                ? const SizedBox()
                : SizedBox(
                    height: kBottomNavigationBarHeight,
                    child: context.button(
                      data: BaseUiKitButtonData(
                        text: S.current.Confirm,
                        onPressed: onConfirm,
                        fit: ButtonFit.fitWidth,
                      ),
                    ),
                  ).paddingSymmetric(
                    horizontal: EdgeInsetsFoundation.horizontal16, vertical: EdgeInsetsFoundation.vertical24),
          );
        },
      ),
    );
  }
}
