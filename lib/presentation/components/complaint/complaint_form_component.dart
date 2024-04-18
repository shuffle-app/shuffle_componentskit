import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/components.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class ComplaintFormComponent extends StatefulWidget {
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
    this.getUserData
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController issueController;
  final GlobalKey<FormState> formKey;
  final VoidCallback onSend;
  final UiProfileModel Function()? getUserData;
  final String? Function(String?)? nameValidator;
  final String? Function(String?)? emailValidator;
  final String? Function(String?)? issueValidator;

  @override
  State<ComplaintFormComponent> createState() => _ComplaintFormComponentState();
}

class _ComplaintFormComponentState extends State<ComplaintFormComponent> {
  final ValueNotifier<bool> formFillNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    if(widget.getUserData!=null){
      final data = widget.getUserData!();
      widget.nameController.text = data.name ?? '';
      widget.emailController.text = data.email ?? '';
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.nameController.addListener(_textControllersListener);
      widget.emailController.addListener(_textControllersListener);
      widget.issueController.addListener(_textControllersListener);
    });
  }

  _textControllersListener() {
    formFillNotifier.value =
        widget.emailController.text.isNotEmpty && widget.nameController.text.isNotEmpty && widget.issueController.text.isNotEmpty;
  }

  @override
  void dispose() {
    widget.nameController.removeListener(_textControllersListener);
    widget.emailController.removeListener(_textControllersListener);
    widget.issueController.removeListener(_textControllersListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          SpacingFoundation.verticalSpace12,
          Text(S.of(context).DescribeYourClaim, style: theme?.boldTextTheme.title2),
          SpacingFoundation.verticalSpace16,
          SpacingFoundation.verticalSpace16,
          UiKitInputFieldNoIcon(
            controller: widget.nameController,
            validator: widget.nameValidator,
            hintText: S.of(context).YourName.toUpperCase(),
            fillColor: theme?.colorScheme.surface3,
          ),
          SpacingFoundation.verticalSpace16,
          UiKitInputFieldNoIcon(
            controller: widget.emailController,
            validator: widget.emailValidator,
            hintText: S.of(context).YourEmail.toUpperCase(),
            fillColor: theme?.colorScheme.surface3,
          ),
          SpacingFoundation.verticalSpace16,
          UiKitInputFieldNoIcon(
            controller: widget.issueController,
            validator: widget.issueValidator,
            hintText: S.of(context).DescribeYourIssue.toUpperCase(),
            fillColor: theme?.colorScheme.surface3,
            minLines: 3,
            borderRadius: BorderRadiusFoundation.all24,
          ),
          SpacingFoundation.verticalSpace16,
          ValueListenableBuilder(
            valueListenable: formFillNotifier,
            builder: (context, hasFilled, child) {
              return context.gradientButton(
                data: BaseUiKitButtonData(
                  onPressed: hasFilled
                      ? () {
                          if (widget.formKey.currentState!.validate()) {
                            context.pop();
                            widget.onSend();
                          }
                        }
                      : null,
                  text: S.of(context).Send.toLowerCase(),
                  fit: ButtonFit.fitWidth,
                ),
              );
            },
          ),
          SpacingFoundation.verticalSpace16,
          MediaQuery.viewInsetsOf(context).bottom.heightBox
        ],
      ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
    );
  }
}
