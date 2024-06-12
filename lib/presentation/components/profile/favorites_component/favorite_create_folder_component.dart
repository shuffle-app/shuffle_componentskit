import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class FavoriteCreateFolderComponent extends StatelessWidget {
  const FavoriteCreateFolderComponent(
      {super.key, required this.titleController, this.onConfirm});

  final TextEditingController titleController;
  final VoidCallback? onConfirm;

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
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.of(context).EnterTitle,
                style:
                    theme?.boldTextTheme.title2.copyWith(color: Colors.black),
              ),
              SpacingFoundation.verticalSpace12,
              UiKitSymbolsCounterInputFieldNoFill(
                controller: titleController,
                enabled: true,
                obscureText: false,
                maxSymbols: 25,
                maxLines: 2,
                minLines: 1,
                customFocusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        width: 2,
                        color: context.uiKitTheme!.colorScheme.darkNeutral400)),
                customEnabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        width: 2,
                        color: context.uiKitTheme!.colorScheme.darkNeutral400)),
                customInputTextColor:
                    context.uiKitTheme?.colorScheme.inverseBodyTypography,
              ),
              SpacingFoundation.verticalSpace16,
              KeyboardVisibilityBuilder(
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
                              builder: (context, child) {
                                if (titleController.text.isEmpty) {
                                  return context.button(
                                    data: BaseUiKitButtonData(
                                      text: S.current.Confirm,
                                      onPressed: null,
                                      fit: ButtonFit.fitWidth,
                                    ),
                                  );
                                } else {
                                  return context.button(
                                    data: BaseUiKitButtonData(
                                      text: S.current.Confirm,
                                      backgroundColor: context
                                          .uiKitTheme?.colorScheme.surface,
                                      textColor: context
                                          .uiKitTheme?.colorScheme.onSurface,
                                      onPressed: onConfirm,
                                      fit: ButtonFit.fitWidth,
                                    ),
                                  );
                                }
                              },
                              listenable: titleController,
                            ),
                          ),
                  );
                },
              )
            ],
          ).paddingAll(EdgeInsetsFoundation.all16),
        ),
      ],
    ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16);
  }
}
