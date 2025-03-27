import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class FeelingSelectGrid extends StatelessWidget {
  final List<String> allFeelings;
  final List<String> selectedFeelings;
  final ValueChanged<String> onSelectionChange;

  const FeelingSelectGrid(
      {super.key, required this.allFeelings, required this.selectedFeelings, required this.onSelectionChange});

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final colorScheme = theme?.colorScheme;

    return BlurredAppBarPage(
        title: S.current.Mood,
        autoImplyLeading: true,
        centerTitle: true,
        // childrenPadding: EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing16),
        children: [
          SpacingFoundation.verticalSpace16,
          SizedBox(
              height: 0.85.sh,
              child: GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: SpacingFoundation.horizontalSpacing8,
                  mainAxisSpacing: SpacingFoundation.verticalSpacing8,
                ),
                itemCount: allFeelings.length,
                itemBuilder: (context, index) {
                  final item = allFeelings[index];
                  return GestureDetector(
                    onTap: () => onSelectionChange(item),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: selectedFeelings.contains(item) ? GradientFoundation.defaultLinearGradient : null,
                        color: selectedFeelings.contains(item) ? null : colorScheme?.surface2,
                        borderRadius: BorderRadiusFoundation.all24,
                      ),
                      child: Center(
                        child: Text(
                          item,
                          textAlign: TextAlign.center,
                          style: theme?.boldTextTheme.caption3Medium.copyWith(
                              color:
                                  selectedFeelings.contains(item) ? colorScheme?.surface : colorScheme?.darkNeutral900),
                        ).paddingSymmetric(
                            horizontal: SpacingFoundation.horizontalSpacing8,
                            vertical: SpacingFoundation.verticalSpacing8),
                      ),
                    ),
                  );
                },
              ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16))
        ]);
  }
}
