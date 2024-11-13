import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/presentation.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class AddLinkComponent extends StatefulWidget {
  final TextEditingController linkController;
  final VoidCallback onSave;
  final String? Function(String?)? validator;

  const AddLinkComponent({
    super.key,
    this.validator,
    required this.linkController,
    required this.onSave,
  });

  @override
  State<AddLinkComponent> createState() => _AddLinkComponentState();
}

class _AddLinkComponentState extends State<AddLinkComponent> {
  bool isLinkValid = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SpacingFoundation.verticalSpace16,
        Text(
          S.of(context).AddLink,
          style: theme?.boldTextTheme.subHeadline,
        ),
        SpacingFoundation.verticalSpace16,
        Form(
          key: _formKey,
          child: UiKitInputFieldNoFill(
            label: 'URL',
            keyboardType: TextInputType.url,
            hintText: 'https://yoursite.com',
            inputFormatters: [HttpsPrefixFormatter()],
            controller: widget.linkController,
            validator: bookingWebsiteValidator,
            onChanged: (value) {
              setState(() {
                isLinkValid = _formKey.currentState!.validate();
              });
            },
          ),
        ),
        SpacingFoundation.verticalSpace24,
        SafeArea(
          top: false,
          child: context.gradientButton(
            data: BaseUiKitButtonData(
              fit: ButtonFit.fitWidth,
              text: S.of(context).Save.toUpperCase(),
              onPressed: isLinkValid ? widget.onSave : null,
            ),
          ),
        ),
      ],
    ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16);
  }
}
