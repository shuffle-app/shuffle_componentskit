import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:shuffle_components_kit/domain/data_uimodels/review_ui_model.dart';
import 'package:shuffle_components_kit/presentation/components/components.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class AddReviewComponent extends StatefulWidget {
  final ValueChanged<ReviewUiModel> onConfirm;
  final UiProfileModel profileModel;
  final String feedbackDate;
  final int? rating;
  final TextEditingController reviewController;
  final ReviewUiModel? reviewUiModel;

  const AddReviewComponent({
    super.key,
    required this.reviewController,
    required this.onConfirm,
    required this.profileModel,
    required this.feedbackDate,
    this.reviewUiModel,
    this.rating,
  });

  @override
  State<AddReviewComponent> createState() => _AddReviewComponentState();
}

class _AddReviewComponentState extends State<AddReviewComponent> {
  @override
  void initState() {
    if (widget.reviewUiModel != null) {
      widget.reviewController.text = widget.reviewUiModel?.reviewDescription ?? '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;
    Widget feedbackOwnerAccountMark = const SizedBox.shrink();
    if (widget.profileModel.userTileType == UserTileType.influencer) {
      feedbackOwnerAccountMark = InfluencerAccountMark();
    }
    if (widget.profileModel.userTileType == UserTileType.pro) {
      feedbackOwnerAccountMark = ProAccountMark();
    }
    if (widget.profileModel.userTileType == UserTileType.premium) {
      feedbackOwnerAccountMark = PremiumAccountMark();
    }

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
                userName: widget.profileModel.name ?? 'Marry Alliance',
                imageUrl: widget.profileModel.avatarUrl ?? GraphicsFoundation.instance.png.place.path,
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
                          widget.profileModel.name ?? 'Marry Alliance',
                          style: boldTextTheme?.caption1Bold,
                        ),
                        SpacingFoundation.horizontalSpace8,
                        feedbackOwnerAccountMark,
                      ],
                    ),
                    Text(
                      widget.feedbackDate,
                      style: boldTextTheme?.caption1Medium,
                    ),
                  ],
                ),
              ),
              SpacingFoundation.horizontalSpace12,
              if (widget.rating != null) UiKitRatingBadge(rating: widget.rating!),
            ],
          ),
          SpacingFoundation.verticalSpace24,
          UiKitTitledWrappedInput(
            input: UiKitSymbolsCounterInputField(
              controller: widget.reviewController,
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
                        onPressed: widget.reviewController.text.isNotEmpty
                            ? () {
                                widget.onConfirm.call(
                                  ReviewUiModel(
                                    id: widget.reviewUiModel?.id ?? -1,
                                    // rating: widget.rating,
                                    reviewDescription: widget.reviewController.text,
                                    reviewTime: widget.reviewUiModel?.reviewTime ?? DateTime.now(),
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
