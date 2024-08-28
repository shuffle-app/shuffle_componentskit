import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class FavoriteCreateFolderComponent extends StatelessWidget {
  const FavoriteCreateFolderComponent({super.key, required this.titleController, this.onConfirm});

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
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S
                    .of(context)
                    .EnterTitle,
                style:
                theme?.boldTextTheme.title2.copyWith(color: Colors.black),
              ),
              SpacingFoundation.verticalSpace12,
              UiKitSymbolsCounterInputFieldNoFill(
                controller: titleController,
                enabled: true,
                autofocus: true,
                obscureText: false,
                maxSymbols: 25,
                textInputAction: TextInputAction.done,
                maxLines: 2,
                minLines: 1,
                onFieldSubmitted: (_) => onConfirm,
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
              SizedBox(
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


            ],
          ).paddingAll(EdgeInsetsFoundation.all16),
        ),
      ],
    ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16);
  }
}
