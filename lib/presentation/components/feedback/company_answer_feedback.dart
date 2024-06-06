import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:shuffle_components_kit/domain/data_uimodels/review_ui_model.dart';
import 'package:shuffle_components_kit/presentation/components/profile/uiprofile_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class CompanyAnswerFeedback extends StatelessWidget {
  const CompanyAnswerFeedback(
      {super.key,
      required this.uiProfileModel,
      required this.reviewUiModel,
      required this.feedbackTextController,
      this.onConfirm,
      this.helpfulCount});

  final UiProfileModel uiProfileModel;
  final ReviewUiModel reviewUiModel;
  final int? helpfulCount;
  final TextEditingController feedbackTextController;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;
    return Scaffold(
      body: BlurredAppBarPage(
        customToolbarBaseHeight: 0.13.sh,
        autoImplyLeading: true,
        centerTitle: true,
        customTitle: Expanded(
          child: Text(
            'Reply ${uiProfileModel.name}',
            style: context.uiKitTheme?.boldTextTheme.title1,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
        childrenPadding: EdgeInsets.all(EdgeInsetsFoundation.all16),
        children: [
          UiKitCardWrapper(
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    context.userAvatar(
                      size: UserAvatarSize.x24x24,
                      type: UserTileType.influencer,
                      userName: uiProfileModel.name ?? 'Marry Alliance',
                      imageUrl: uiProfileModel.avatarUrl ??
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
                                uiProfileModel.name ?? 'Marry Alliance',
                                style: boldTextTheme?.caption1Bold,
                              ),
                            ],
                          ),
                          Text(
                            '${reviewUiModel.reviewTime.day.toString()} days ago',
                            style: boldTextTheme?.caption1Medium
                                .copyWith(color: ColorsFoundation.mutedText),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SpacingFoundation.verticalSpace12,
                Text(
                  reviewUiModel.reviewDescription,
                  style: boldTextTheme?.caption1Medium,
                ),
                SpacingFoundation.verticalSpace12,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(ShuffleUiKitIcons.like,
                        color: ColorsFoundation.mutedText, size: 16.sp),
                    SpacingFoundation.horizontalSpace8,
                    Text(
                      '${S.current.Helpful} ${helpfulCount ?? 0}',
                      style: boldTextTheme?.caption1Medium
                          .copyWith(color: ColorsFoundation.mutedText),
                    ),
                  ],
                ),
              ],
            ).paddingAll(EdgeInsetsFoundation.all16),
          ),
          UiKitTitledWrappedInput(
              input: UiKitSymbolsCounterInputField(
                  controller: TextEditingController(),
                  enabled: true,
                  obscureText: false,
                  maxSymbols: 500),
              title: 'Write the Answer')
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
                    child: ListenableBuilder(
                      listenable: feedbackTextController,
                      builder: (context, child) {
                        if (feedbackTextController.text.isEmpty) {
                          return context.button(
                            data: BaseUiKitButtonData(
                              text: S.current.Confirm,
                              fit: ButtonFit.fitWidth,
                            ),
                          );
                        } else {
                          return context.button(
                            data: BaseUiKitButtonData(
                              onPressed: onConfirm,
                              text: S.current.Confirm,
                              fit: ButtonFit.fitWidth,
                            ),
                          );
                        }
                      },
                    ),
                  ).paddingSymmetric(
                    horizontal: EdgeInsetsFoundation.horizontal16,
                    vertical: EdgeInsetsFoundation.vertical24),
          );
        },
      ),
    );
  }
}
