part of 'create_web_place_component.dart';

class WebTextFormField extends StatelessWidget {
  const WebTextFormField({
    super.key,
    required this.title,
    required this.controller,
    this.isRequired = false,
    this.validator,
  });

  final String title;
  final bool isRequired;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: theme?.boldTextTheme.body.copyWith(
                color: theme.colorScheme.darkNeutral900,
              ),
            ),
            if (isRequired)
              Text(
                '*',
                style: theme?.boldTextTheme.title2.copyWith(color: theme.colorScheme.error),
              ),
          ],
        ),
        SpacingFoundation.verticalSpace12,
        UiKitInputFieldNoIcon(
          controller: TextEditingController(),
          hintText: 'DESCRIBE YOUR ISSUE',
          fillColor: theme?.colorScheme.surface3,
          borderRadius: BorderRadiusFoundation.all12,
        ),
      ],
    );
  }
}
