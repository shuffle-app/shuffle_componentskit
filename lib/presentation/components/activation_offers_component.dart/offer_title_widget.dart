import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/notification_offer_reminder_components/universal_not_offer_rem_ui_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class OfferTitleWidget extends StatelessWidget {
  final UniversalNotOfferRemUiModel? offerUiModel;

  const OfferTitleWidget({
    super.key,
    this.offerUiModel,
  });

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          offerUiModel?.title ?? S.of(context).NothingFound,
          style: boldTextTheme?.title2,
        ),
        SpacingFoundation.verticalSpace2,
        Row(
          children: [
            Text(
              '${offerUiModel?.pointPrice ?? 0} ${S.of(context).PointsCount(offerUiModel?.pointPrice ?? 0).capitalize()}',
              style: boldTextTheme?.caption2Bold.copyWith(color: ColorsFoundation.mutedText),
            ),
            const Spacer(),
            Text(
              '${formatDateWithCustomPattern(
                'dd.MM',
                (offerUiModel?.selectedDates?.first ?? DateTime.now()).toLocal(),
              )} - ${formatDateWithCustomPattern(
                'dd.MM.yyyy',
                (offerUiModel?.selectedDates?.last ?? DateTime.now()).toLocal(),
              )}',
              style: boldTextTheme?.caption2Bold.copyWith(color: ColorsFoundation.mutedText),
            ),
          ],
        ),
      ],
    );
  }
}
