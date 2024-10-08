import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import 'bookings_control_ui_models/bookings_place_or_even_ui_model.dart';

class BookingsControlEventItem extends StatelessWidget {
  final String? title;
  final String? description;
  final List<BookingsPlaceOrEventUiModel>? events;
  final ValueChanged<int>? onTap;

  const BookingsControlEventItem({
    super.key,
    this.title,
    this.description,
    this.events,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title ?? '',
          style: boldTextTheme?.title2,
        ),
        SpacingFoundation.verticalSpace2,
        Text(
          description ?? '',
          style: boldTextTheme?.caption2Bold.copyWith(color: ColorsFoundation.mutedText),
        ),
        SpacingFoundation.verticalSpace16,
        if (events != null && events!.isNotEmpty)
          ...events!.map(
            (e) => BookingsControlPlaceItemUiKit(
              title: e.title,
              description: e.description,
              imageUrl: e.imageUrl,
              onTap: () => onTap?.call(e.id),
            ).paddingOnly(bottom: SpacingFoundation.verticalSpacing16),
          ),
      ],
    );
  }
}
