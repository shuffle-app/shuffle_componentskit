part of 'create_web_place_component.dart';

class WebFormField extends StatelessWidget {
  const WebFormField({
    super.key,
    required this.title,
    required this.child,
    this.isRequired = false,
  });

  final String title;
  final bool isRequired;
  final Widget child;

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
                style: theme?.boldTextTheme.title2.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
          ],
        ),
        SpacingFoundation.verticalSpace12,
        child,
      ],
    );
  }
}
