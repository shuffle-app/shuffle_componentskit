// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class BookingBarcodeComponent extends StatelessWidget {
  final List<String>? tickets;
  final String? title;
  final ValueChanged<String>? onShare;
  final String? imageUrl;

  const BookingBarcodeComponent({
    super.key,
    required this.tickets,
    this.title,
    this.onShare,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            context.userAvatar(
              size: UserAvatarSize.x40x40,
              type: UserTileType.ordinary,
              userName: '',
              imageUrl: imageUrl,
            ),
            SpacingFoundation.horizontalSpace12,
            Text(
              title ?? S.of(context).NothingFound,
              style: theme?.boldTextTheme.title2,
            ),
          ],
        ),
        if (tickets != null && tickets!.isNotEmpty)
          ...tickets!.map(
            (e) {
              return Column(
                children: [
                  SpacingFoundation.verticalSpace24,
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${S.of(context).Ticket} ${tickets!.indexWhere((element) => element == e) + 1}',
                          style: theme?.boldTextTheme.body,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => onShare?.call(e),
                        child: ImageWidget(
                          height: 15.h,
                          iconData: ShuffleUiKitIcons.share,
                          color: theme?.colorScheme.inversePrimary,
                        ),
                      ),
                    ],
                  ),
                  SpacingFoundation.verticalSpace16,
                  CustomBarcode(barcodeNumber: e),
                  SpacingFoundation.verticalSpace16,
                  Text(
                    S.of(context).YouSharedTicket,
                    style: theme?.regularTextTheme.caption1,
                  ),
                  SpacingFoundation.verticalSpace24,
                  Divider(
                    color: theme?.colorScheme.surface2,
                    thickness: 2,
                  ),
                  SpacingFoundation.verticalSpace24,
                ],
              );
            },
          )
        else
          Text(
            S.of(context).NothingFound,
            style: theme?.regularTextTheme.caption1,
          ),
        if (tickets != null && tickets!.isNotEmpty)
          Text(
            S.of(context).ShowTheBarcodeCheckout,
            style: theme?.regularTextTheme.caption1,
          ),
      ],
    ).paddingAll(EdgeInsetsFoundation.all16);
  }
}
