import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class PasswordUpdatingComponent extends StatefulWidget {
  const PasswordUpdatingComponent({
    super.key,
    required this.formKey,
    required this.userEmail,
    required this.codeController,
    required this.passwordController,
    required this.onPasswordChanged,
    required this.loading,
    this.passwordFieldEnabled = true,
    this.onCodeSubmit,
    this.passwordValidator,
    this.codeErrorText,
    this.passwordErrorText,
  });

  final GlobalKey<FormState> formKey;
  final String userEmail;
  final TextEditingController codeController;
  final TextEditingController passwordController;
  final ValueChanged<String> onPasswordChanged;
  final bool passwordFieldEnabled;
  final bool loading;

  final ValueChanged<String>? onCodeSubmit;
  final String? Function(String?)? passwordValidator;
  final String? codeErrorText;
  final String? passwordErrorText;

  @override
  State<PasswordUpdatingComponent> createState() => _PasswordUpdatingComponentState();
}

class _PasswordUpdatingComponentState extends State<PasswordUpdatingComponent> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  late final FocusNode _passwordFocus;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      value: 1.0,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    _passwordFocus = FocusNode()
      ..addListener(() {
        if (_passwordFocus.hasFocus) {
          _hideCodeInput();
        } else {
          _showCodeInput();
        }
      });
  }

  void _hideCodeInput() {
    _controller.reverse();
  }

  void _showCodeInput() {
    _controller.forward();
  }

  @override
  void dispose() {
    _passwordFocus.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final globalContent = GlobalComponent.of(context)?.globalConfiguration.appConfig.content;
    final config = globalContent ?? GlobalConfiguration().appConfig.content;
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;
    final codeDigits = config['additional_settings']?['code_digits'] ?? 4;

    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: MediaQuery.of(context).viewPadding.top),
          Text('Reset password', style: boldTextTheme?.title1),
          SpacingFoundation.verticalSpace16,
          Stack(
            children: [
              Text(
                'Please type verification code sent to ',
                style: boldTextTheme?.subHeadline,
              ),
              GradientableWidget(
                gradient: GradientFoundation.attentionCard,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Please type verification code sent to ',
                        style: boldTextTheme?.subHeadline.copyWith(
                          color: Colors.transparent,
                        ),
                      ),
                      TextSpan(
                        text: widget.userEmail,
                        recognizer: TapGestureRecognizer()..onTap = () => context.pop(),
                        style: boldTextTheme?.subHeadline,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizeTransition(
                        sizeFactor: _animation,
                        axisAlignment: 1,
                        child: Column(
                          children: [
                            UiKitCodeInputField(
                              controller: widget.codeController,
                              codeDigitsCount: codeDigits,
                              onDone: (code) => widget.onCodeSubmit?.call(code),
                              errorText: widget.codeErrorText,
                            ),
                            SpacingFoundation.verticalSpace24,
                          ],
                        ),
                      ),
                      UiKitTitledTextField(
                        title: 'Enter new password',
                        controller: widget.passwordController,
                        hintText: 'password'.toUpperCase(),
                        validator: widget.passwordValidator,
                        errorText: widget.passwordErrorText,
                        focusNode: _passwordFocus,
                        enabled: widget.passwordFieldEnabled,
                        validationLetters: 'Letters, numbers, ! “ @ # \$ % & symbols, 8 characters',
                      ),
                    ],
                  ),
                ),
                context.button(
                  data: BaseUiKitButtonData(
                    loading: widget.loading,
                    onPressed: () {
                      if (widget.formKey.currentState!.validate()) {
                        widget.onPasswordChanged.call(widget.passwordController.text);
                      }
                    },
                    text: 'next',
                    fit: ButtonFit.fitWidth,
                  ),
                ),
                SpacingFoundation.verticalSpace4,
              ],
            ),
          ),
        ],
      ).paddingSymmetric(
        horizontal: EdgeInsetsFoundation.horizontal16,
        vertical: EdgeInsetsFoundation.vertical16,
      ),
    );
  }
}
