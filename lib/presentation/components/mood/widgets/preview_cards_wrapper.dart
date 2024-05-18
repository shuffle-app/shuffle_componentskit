import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class PreviewCardsWrapper extends StatelessWidget {
  final List<PlacePreview> cards;
  final DateTime? shouldVisitAt;

  const PreviewCardsWrapper({super.key, required this.cards, this.shouldVisitAt});

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final double calculatedOpacity = (shouldVisitAt?.isAtSameDay ?? true) ? 1 : 0.2;

    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
      if (shouldVisitAt != null)
        Text(shouldVisitAt!.isAtSameDay ? S.of(context).Today : DateFormat('MMM dd, yyyy').format(shouldVisitAt!),
                style: theme?.boldTextTheme.title2)
            .paddingOnly(top: SpacingFoundation.verticalSpacing6, bottom: SpacingFoundation.verticalSpacing24),
      Stack(
        alignment: Alignment.center,
        children: [
          IgnorePointer(
              ignoring: calculatedOpacity == 1 ? false : true,
              child: Opacity(
                  opacity: calculatedOpacity,
                  child: Column(
                    children:
                        cards.map((e) => e.paddingSymmetric(vertical: SpacingFoundation.verticalSpacing16)).toList(),
                  ))),
          if (shouldVisitAt != null && !shouldVisitAt!.isAtSameDay)
            UiKitCardWrapper(
              color: theme?.colorScheme.surface2.withOpacity(0.35),
              child: Center(
                child: Text(S.of(context).VisitFirstToOpenNext, style: theme?.boldTextTheme.body),
              ).paddingSymmetric(
                  horizontal: SpacingFoundation.horizontalSpacing20, vertical: SpacingFoundation.verticalSpacing12),
            ),
        ],
      )
    ]);
  }
}
