import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class SupportComponent extends StatelessWidget {
  final TextEditingController _nameController;
  final TextEditingController _emailController;
  final TextEditingController _textController;
  final Map<String, String>? content;

  final FocusNode daysFocusNode;
  final ValueChanged<bool> onSupportSubmitted;
  final bool isSupportActive;
  final String? versionText;

  final VoidCallback? onSupportRequestPressed;

  SupportComponent({
    super.key,
    this.versionText,
    this.content,
    this.isSupportActive = false,
    required this.onSupportSubmitted,
    required this.daysFocusNode,
    TextEditingController? nameController,
    TextEditingController? emailController,
    TextEditingController? textController,
    TextEditingController? daysCountController,
    this.onSupportRequestPressed,
  })  : _nameController = nameController ?? TextEditingController(),
        _emailController = emailController ?? TextEditingController(),
        _textController = textController ?? TextEditingController();

  // _daysCountController = daysCountController ?? TextEditingController()

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final surface1 = theme?.colorScheme.surface1;
    final surface3 = theme?.colorScheme.surface3;
    final textTheme = theme?.boldTextTheme;

    return Scaffold(
      body: BlurredAppBarPage(
        centerTitle: true,
        autoImplyLeading: true,
        title: S.of(context).Support,
        appBarTrailing: versionText != null
            ? Text(
                versionText!,
                style: textTheme?.caption1Bold,
              )
            : null,
        childrenPadding: EdgeInsets.symmetric(
          horizontal: SpacingFoundation.horizontalSpacing16,
        ),
        children: [
          SpacingFoundation.verticalSpace16,
          // UiKitGradientSwitchTile(
          //   title: S.of(context).EnableHintSystem,
          //   onChanged: onSupportSubmitted,
          //   switchedOn: isSupportActive,
          //   subtitle: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       Text(
          //         S.current.ForPeriod.toLowerCase(),
          //         style: textTheme?.labelLarge,
          //       ),
          //       SpacingFoundation.horizontalSpace16,
          //       SizedBox(
          //         width: 0.2.sw,
          //         height: 0.625 * 0.2.sw,
          //         child: UiKitInputFieldNoIcon(
          //           textAlign: TextAlign.center,
          //           keyboardType: TextInputType.number,
          //           inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          //           customPadding: EdgeInsets.symmetric(
          //             vertical: EdgeInsetsFoundation.vertical12,
          //             horizontal: EdgeInsetsFoundation.horizontal16,
          //           ),
          //           fillColor: surface3,
          //           hintText: '123',
          //           node: daysFocusNode,
          //           controller: _daysCountController,
          //         ),
          //       ),
          //       SpacingFoundation.horizontalSpace16,
          //       Text(
          //         S.current.Days(int.tryParse(_daysCountController.text) ?? 0).toLowerCase(),
          //         style: textTheme?.labelLarge,
          //       ),
          //     ],
          //   ),
          // ),
          // SpacingFoundation.verticalSpace24,
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
                          faqData: content ?? Map<String, String>.identity(),
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
            data: BaseUiKitButtonData(text: S.of(context).Send.toLowerCase(), onPressed: onSupportRequestPressed),
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
