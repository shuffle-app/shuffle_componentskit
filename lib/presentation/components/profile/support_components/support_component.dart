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
    final theme = context.uiKitTheme;
    final surface1 = theme?.colorScheme.surface1;
    final surface3 = theme?.colorScheme.surface3;

    return Scaffold(
      body: BlurredAppBarPage(
        centerTitle: true,
        autoImplyLeading: true,
        title: S.of(context).Support,
        childrenPadding: EdgeInsets.symmetric(
          horizontal: position?.horizontalMargin?.toDouble() ?? 0,
        ),
        children: [
          SpacingFoundation.verticalSpace16,
          UiKitGradientSwitchTile(
            title: S.of(context).EnableHintSystem,
            onChanged: onSupportSubmitted,
            switchedOn: isSupportActive,
          ),
          SpacingFoundation.verticalSpace24,
          UiKitCardWrapper(
            child: Theme(
              data: ThemeData(
                textButtonTheme: TextButtonThemeData(
                  style: context.uiKitTheme?.textButtonStyle(context.uiKitTheme!.colorScheme.inversePrimary),
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
                      text: S.of(context).Faq.toUpperCase(),
                      iconWidget: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.fromBorderSide(
                            BorderSide(
                              width: 2,
                              color: context.uiKitTheme?.colorScheme.inversePrimary ?? Colors.transparent,
                            ),
                          ),
                        ),
                        child: ImageWidget(
                          iconData: ShuffleUiKitIcons.chevronright,
                          color: context.uiKitTheme?.colorScheme.inversePrimary,
                        ).paddingAll(SpacingFoundation.verticalSpacing12),
                      ),
                    ),
                  )
                  .paddingAll(SpacingFoundation.verticalSpacing16),
            ),
          ),
          SpacingFoundation.verticalSpace24,
          Form(
            // key: GlobalKey<FormState>(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                UiKitCardWrapper(
                  borderRadius: BorderRadiusFoundation.max,
                  color: surface1,
                  child: UiKitInputFieldNoIcon(
                    controller: _nameController,
                    hintText: S.of(context).YourName.toUpperCase(),
                    // validator: inputFieldValidator,
                    fillColor: surface3,
                    // onChanged: (value) => onNameChanged?.call(value),
                  ).paddingAll(EdgeInsetsFoundation.all4),
                ),
                SpacingFoundation.verticalSpace16,
                UiKitCardWrapper(
                  borderRadius: BorderRadiusFoundation.max,
                  color: surface1,
                  child: UiKitInputFieldNoIcon(
                    controller: _emailController,
                    hintText: S.of(context).YourEmail.toUpperCase(),
                    // validator: inputFieldValidator,
                    fillColor: surface3,
                    // onChanged: (value) => onNickNameChanged?.call(value),
                  ).paddingAll(EdgeInsetsFoundation.all4),
                ),
                SpacingFoundation.verticalSpace16,
                UiKitCardWrapper(
                  color: surface1,
                  child: UiKitInputFieldNoIcon(
                    borderRadius: BorderRadiusFoundation.all24,
                    controller: _textController,
                    minLines: 3,
                    hintText: S.of(context).DescribeYourIssue.toUpperCase(),
                    // validator: inputFieldValidator,
                    fillColor: surface3,
                    // onChanged: (value) => onNickNameChanged?.call(value),
                  ).paddingAll(EdgeInsetsFoundation.all4),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: context
          .gradientButton(
            data: BaseUiKitButtonData(
              text: S.of(context).Send.toLowerCase(),
              onPressed: () => SnackBarUtils.show(
                message: S.of(context).WillBeImplementedSoon.toLowerCase(),
                context: context,
              ),
            ),
          )
          .paddingOnly(
            left: EdgeInsetsFoundation.horizontal16,
            right: EdgeInsetsFoundation.horizontal16,
            bottom: EdgeInsetsFoundation.vertical24,
            top: EdgeInsetsFoundation.vertical24,
          ),
    );
  }
}
