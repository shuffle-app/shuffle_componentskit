import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';

class BookingBarcodeComponent extends StatelessWidget {
  final Map<String, bool>? tickets;
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
    final isNotEmptyTickets = tickets != null && tickets!.isNotEmpty;

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
            Expanded(
              child: AutoSizeText(
                title ?? S.of(context).NothingFound,
                style: theme?.boldTextTheme.title2,
                maxLines: 3,
              ),
            ),
          ],
        ),
        if (isNotEmptyTickets)
          ...tickets!.entries.map(
            (e) {
              return Column(
                children: [
                  SpacingFoundation.verticalSpace24,
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${S.of(context).Ticket} ${tickets!.keys.toList().indexWhere((element) => element == e.key) + 1}',
                          style: theme?.boldTextTheme.body,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (!e.value) {
                            onShare?.call(e.key);
                          }
                        },
                        child: ImageWidget(
                          height: 15.h,
                          iconData: ShuffleUiKitIcons.share,
                          color: e.value ? ColorsFoundation.mutedText : theme?.colorScheme.inversePrimary,
                        ),
                      ),
                    ],
                  ),
                  SpacingFoundation.verticalSpace16,
                  CustomBarcode(
                    barcodeNumber: e.key,
                    isBeenActivated: e.value,
                  ),
                  if (e.value)
                    Text(
                      S.of(context).BarcodeAlreadyBeenActivated,
                      style: theme?.regularTextTheme.caption1,
                    ).paddingOnly(top: SpacingFoundation.verticalSpacing16),
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
        if (isNotEmptyTickets)
          Text(
            S.of(context).ShowTheBarcodeCheckout,
            style: theme?.regularTextTheme.caption1,
          ),
      ],
    ).paddingAll(EdgeInsetsFoundation.all16);
  }
}
