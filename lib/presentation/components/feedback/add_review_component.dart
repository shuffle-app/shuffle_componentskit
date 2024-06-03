import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:shuffle_components_kit/domain/data_uimodels/review_ui_model.dart';
import 'package:shuffle_components_kit/presentation/components/components.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class AddReviewComponent extends StatelessWidget {
  final ValueChanged<ReviewUiModel> onConfirm;
  final UiProfileModel profileModel;
  final String feedbackDate;
  final int rating;
  final TextEditingController reviewController;

  const AddReviewComponent({
    Key? key,

    required this.reviewController,
  required  this.onConfirm,
    required this.profileModel,required
    this.feedbackDate,required
    this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;
    Widget feedbackOwnerAccountMark = const SizedBox.shrink();
    if (profileModel.userTileType == UserTileType.influencer) {
      feedbackOwnerAccountMark = InfluencerAccountMark();
    }
    if (profileModel.userTileType == UserTileType.pro) {
      feedbackOwnerAccountMark = ProAccountMark();
    }
    if (profileModel.userTileType == UserTileType.premium) {
      feedbackOwnerAccountMark = PremiumAccountMark();
    }

    return Scaffold(
      body: BlurredAppBarPage(
        autoImplyLeading: true,
        centerTitle: true,
        title: S.current.AddReview,
        childrenPadding:
            EdgeInsets.symmetric(horizontal: EdgeInsetsFoundation.horizontal16),
        children: [
          SpacingFoundation.verticalSpace24,
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              context.userAvatar(
                size: UserAvatarSize.x24x24,
                type: UserTileType.influencer,
                userName: profileModel.name ?? 'Marry Alliance',
                imageUrl: profileModel.avatarUrl ??
                    GraphicsFoundation.instance.png.place.path,
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
                          profileModel.name ?? 'Marry Alliance',
                          style: boldTextTheme?.caption1Bold,
                        ),
                        SpacingFoundation.horizontalSpace8,
                        feedbackOwnerAccountMark,
                      ],
                    ),
                    Text(
                      feedbackDate ,
                      style: boldTextTheme?.caption1Medium,
                    ),
                  ],
                ),
              ),
              SpacingFoundation.horizontalSpace12,
              UiKitRatingBadge(rating: rating ),
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
                        onPressed: reviewController.text.isNotEmpty
                            ? () {
                                onConfirm.call(
                                  ReviewUiModel(
                                    rating: rating ,
                                    reviewDescription: reviewController.text,
                                    reviewTime: DateTime.now(),
                                  ),
                                );
                              }
                            : null,
                        fit: ButtonFit.fitWidth,
                      ),
                    ),
                  ).paddingSymmetric(
                    horizontal: EdgeInsetsFoundation.horizontal16,
                    vertical: EdgeInsetsFoundation.vertical24,
                  ),
          );
        },
      ),
    );
  }
}
