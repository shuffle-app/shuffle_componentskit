import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class ReligionsSelectBottomSheet extends StatelessWidget {
  final List<UiKitTag> religions;
  final List<UiKitTag> selectedReligions;
  final ValueChanged<UiKitTag> selectedReligionChanged;

  const ReligionsSelectBottomSheet({
    super.key,
    required this.religions,
    this.selectedReligions = const [],
    required this.selectedReligionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;

    return SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              S.current.SelectYourReligions,
              style: boldTextTheme?.subHeadline,
              textAlign: TextAlign.center,
            ),
            SpacingFoundation.verticalSpace16,
            Wrap(
              spacing: SpacingFoundation.verticalSpacing8,
              runSpacing: SpacingFoundation.verticalSpacing8,
              children: religions
                  .map(
                    (element) => UiKitBorderedChipWithIcon(
                      isSelected: selectedReligions.any((e) => e.id == element.id),
                      title: element.title,
                      icon: ImageWidget(
                        link: element.icon,
                        fit: BoxFit.cover,
                      ),
                      onPressed: () => selectedReligionChanged(element),
                    ),
                  )
                  .toList(),
            ),
            SpacingFoundation.verticalSpace16,
          ],
        ).paddingAll(EdgeInsetsFoundation.all16));
  }
}
