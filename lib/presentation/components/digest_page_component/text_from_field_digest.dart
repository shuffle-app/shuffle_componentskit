import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/common/web_form_field.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class TextFromFieldDigest extends StatelessWidget {
  final String title;
  final TextEditingController? controller;
  final VoidCallback? onTap;

  const TextFromFieldDigest({
    super.key,
    required this.title,
    this.controller,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final bool isReadOnly = controller == null;
    final Widget child = UiKitInputFieldNoIcon(
      controller: controller ?? TextEditingController(),
      readOnly: isReadOnly,
      textInputAction: TextInputAction.newline,
      hintText: 'Placeholder',
      fillColor: theme?.colorScheme.surface1,
      borderRadius: BorderRadiusFoundation.all12,
      onTap: onTap,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: WebFormField(
        title: title,
        isRequired: true,
        child: isReadOnly ? IgnorePointer(child: child) : child,
      ),
    );
  }
}
