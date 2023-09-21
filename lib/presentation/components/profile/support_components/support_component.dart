import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class SupportComponent extends StatelessWidget {
  final TextEditingController _nameController;
  final TextEditingController _emailController;
  final TextEditingController _textController;
  final PositionModel? position;
  final ContentBaseModel content;
  final ValueChanged<bool> onSupportSubmitted;
  final bool isSupportActive;

  SupportComponent(
      {super.key,
      this.position,
      this.isSupportActive = false,
      required this.onSupportSubmitted,
      required this.content,
      TextEditingController? nameController,
      TextEditingController? emailController,
      TextEditingController? textController})
      : _nameController = nameController ?? TextEditingController(),
        _emailController = emailController ?? TextEditingController(),
        _textController = textController ?? TextEditingController();

  @override
  Widget build(BuildContext context) {
    final toolBarHeight = context.uiKitTheme?.customAppBapTheme.toolbarHeight ?? 90.0;
    final remainingHeight = 1.sh - toolBarHeight - EdgeInsetsFoundation.vertical16 - SpacingFoundation.verticalSpacing24;

    return BlurredAppBarPage(
      centerTitle: true,
      autoImplyLeading: true,
      title: 'Support',
      body: SizedBox(
        height: remainingHeight,
        child:  Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            UiKitGradientSwitchTile(
              title: 'Enable hint system',
              onChanged: onSupportSubmitted,
              switchedOn: isSupportActive,
            ),
            SpacingFoundation.verticalSpace24,
            UiKitCardWrapper(
              child: Theme(
                data: ThemeData(
                  textButtonTheme: TextButtonThemeData(
                    style: context.uiKitTheme?.textButtonStyle,
                  ),
                ),
                child: context
                    .button(
                      reversed: true,
                      isTextButton: true,
                      data: BaseUiKitButtonData(
                        onPressed: () => context.push(
                          FAQComponent(
                            positionModel: position,
                            faqData: content.body![ContentItemType.pageOpener]!.properties!.map(
                              (key, value) => MapEntry(
                                key,
                                value.value!,
                              ),
                            ),
                          ),
                        ),
                        text: 'FAQ',
                        icon: DecoratedBox(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.fromBorderSide(
                              BorderSide(width: 2, color: Colors.white),
                            ),
                          ),
                          child: ImageWidget(
                            svgAsset: GraphicsFoundation.instance.svg.chevronRight,
                            color: Colors.white,
                          ).paddingAll(SpacingFoundation.verticalSpacing12),
                        ),
                      ),
                    )
                    .paddingAll(SpacingFoundation.verticalSpacing16),
              ),
            ),
            SpacingFoundation.verticalSpace24,
            const Spacer(),
            UiKitCardWrapper(
              color: ColorsFoundation.surface1,
              child: Form(
                // key: GlobalKey<FormState>(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    UiKitInputFieldNoIcon(
                      controller: _nameController,
                      hintText: 'your NAME'.toUpperCase(),
                      // validator: inputFieldValidator,
                      fillColor: ColorsFoundation.surface3,
                      // onChanged: (value) => onNameChanged?.call(value),
                    ),
                    SpacingFoundation.verticalSpace16,
                    UiKitInputFieldNoIcon(
                      controller: _emailController,
                      hintText: 'your EMAIL'.toUpperCase(),

                      // validator: inputFieldValidator,
                      fillColor: ColorsFoundation.surface3,
                      // onChanged: (value) => onNickNameChanged?.call(value),
                    ),
                    SpacingFoundation.verticalSpace16,
                    UiKitInputFieldNoIcon(
                      borderRadius: BorderRadiusFoundation.all24,
                      controller: _textController,
                      minLines: 3,
                      hintText: 'describe your issue'.toUpperCase(),

                      // validator: inputFieldValidator,
                      fillColor: ColorsFoundation.surface3,
                      // onChanged: (value) => onNickNameChanged?.call(value),
                    ),
                  ],
                ),
              ).paddingAll(EdgeInsetsFoundation.all4),
            ),
            SpacingFoundation.verticalSpace24,
            SizedBox(
              width: double.infinity,
              child: context.gradientButton(
                data: BaseUiKitButtonData(
                  text: 'send',
                  onPressed: () => SnackBarUtils.show(message: 'will be implemented soon', context: context),
                ),
              ),
            )
          ],
        ).paddingSymmetric(
          vertical: position?.verticalMargin?.toDouble() ?? 0,
          horizontal: position?.horizontalMargin?.toDouble() ?? 0,
        ),
      ),
    );
  }
}
