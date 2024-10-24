import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class AgeSelectBottomSheet extends StatelessWidget {
  final ValueChanged<int> onAgeChanged;

  const AgeSelectBottomSheet({super.key, required this.onAgeChanged});

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final boldTextTheme = theme?.boldTextTheme;
    return SafeArea(
        top: false,
        child: Column(children: [
          Text(
            S.of(context).YourAge,
            style: boldTextTheme?.labelLarge,
          ).paddingAll(EdgeInsetsFoundation.all16),
          SpacingFoundation.verticalSpace10,
          UiKitHorizontalWheelNumberSelector(
            hideTitle: true,
            values: List<int>.generate(70, (index) => index + 13),
            backgroundColor: theme?.colorScheme.surface,
            initialValue: 11,
            onValueChanged: (age) => onAgeChanged(age),
          )
        ]));
  }
}
