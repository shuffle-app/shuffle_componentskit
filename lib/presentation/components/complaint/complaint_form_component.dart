import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class ComplaintFormComponent extends StatelessWidget {
  const ComplaintFormComponent({
    super.key,
    required this.onSend,
    required this.nameController,
    required this.emailController,
    required this.issueController,
    required this.formKey,
    this.nameValidator,
    this.emailValidator,
    this.issueValidator,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController issueController;
  final GlobalKey<FormState> formKey;
  final VoidCallback onSend;

  final String? Function(String?)? nameValidator;
  final String? Function(String?)? emailValidator;
  final String? Function(String?)? issueValidator;

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return Form(
      key: formKey,
      child: Column(
        children: [
          SpacingFoundation.verticalSpace12,
          Text(S.of(context).DescribeYourClaim, style: theme?.boldTextTheme.title2),
          SpacingFoundation.verticalSpace16,
          SpacingFoundation.verticalSpace16,
          UiKitInputFieldNoIcon(
            controller: nameController,
            validator: nameValidator,
            hintText: S.of(context).YourName.toUpperCase(),
            fillColor: theme?.colorScheme.surface3,
          ),
          SpacingFoundation.verticalSpace16,
          UiKitInputFieldNoIcon(
            controller: emailController,
            validator: emailValidator,
            hintText: S.of(context).YourEmail.toUpperCase(),
            fillColor: theme?.colorScheme.surface3,
          ),
          SpacingFoundation.verticalSpace16,
          UiKitInputFieldNoIcon(
            controller: issueController,
            validator: issueValidator,
            hintText: S.of(context).DescribeYourIssue.toUpperCase(),
            fillColor: theme?.colorScheme.surface3,
            minLines: 3,
            borderRadius: BorderRadiusFoundation.all24,
          ),
          SpacingFoundation.verticalSpace16,
          context.gradientButton(
            data: BaseUiKitButtonData(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  context.pop();
                  onSend();
                }
              },
              text: S.of(context).Send.toLowerCase(),
              fit: ButtonFit.fitWidth,
            ),
          ),
          SpacingFoundation.verticalSpace16,
          MediaQuery.viewInsetsOf(context).bottom.heightBox
        ],
      ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
    );
  }
}
