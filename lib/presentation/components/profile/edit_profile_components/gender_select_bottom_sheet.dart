import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class GenderSelectBottomSheet extends StatelessWidget {
  final List<UiKitTag> genders;
  final ValueChanged<int> onGenderSelected;

  const GenderSelectBottomSheet({
    super.key,
    required this.genders,
    required this.onGenderSelected,
  });

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;
    final colorScheme = context.uiKitTheme?.colorScheme;
    final Widget separator = Divider(color: colorScheme?.surface2, height: 1, thickness: 1);

    return SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              S.current.SelectGender,
              style: boldTextTheme?.subHeadline,
              textAlign: TextAlign.center,
            ),
            SpacingFoundation.verticalSpace16,
            ...genders.map((e) {
              return GestureDetector(
                onTap: () {
                  onGenderSelected(e.id!);
                  context.pop();
                },
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    separator,
                    SpacingFoundation.verticalSpace16,
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ImageWidget(
                          link: e.icon,
                          height: 20.h,
                          width: 20.h,
                        ),
                        SpacingFoundation.horizontalSpace8,
                        Expanded(
                          child: Text(
                            e.title,
                            style: boldTextTheme?.caption1UpperCaseMedium,
                          ),
                        ),
                      ],
                    ),
                    SpacingFoundation.verticalSpace16,
                    separator,
                  ],
                ),
              );
            }).toList(),
          ],
        ).paddingAll(EdgeInsetsFoundation.all16));
  }
}
