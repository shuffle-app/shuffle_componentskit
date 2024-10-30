import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ShareBookingBarcode extends StatelessWidget {
  final BaseUiKitUserTileData? userTileData;
  final String? contentImageUrl;
  final String barcodeNumber;
  final String? eventTitle;
  final DateTime? contentDate;
  final int? price;
  final String? currency;
  final ValueChanged<Future<Uint8List?> Function()>? onShareTap;
  final bool isLoading;
  final bool isShareLoading;

  ShareBookingBarcode({
    super.key,
    this.userTileData,
    required this.barcodeNumber,
    this.contentDate,
    this.price,
    this.currency,
    this.eventTitle,
    this.onShareTap,
    this.isLoading = false,
    this.isShareLoading = false,
    this.contentImageUrl,
  });

  final GlobalKey globalKey = GlobalKey();

  Future<Uint8List?> _capturePng() async {
    RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    if (boundary.debugNeedsPaint) {
      await Future.delayed(const Duration(milliseconds: 20));
    }
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final boldTextTheme = theme?.boldTextTheme;

    return Column(
      children: [
        SpacingFoundation.verticalSpace16,
        Text(
          S.of(context).Ticket,
          style: boldTextTheme?.title2,
        ),
        RepaintBoundary(
          key: globalKey,
          child: Column(
            children: [
              SpacingFoundation.verticalSpace24,
              ImageWidget(
                width: 100.w,
                fit: BoxFit.fill,
                link: GraphicsFoundation.instance.png.shuffleLogo.path,
              ),
              SpacingFoundation.verticalSpace16,
              if (isLoading)
                const CircularProgressIndicator()
              else
                UiKitCardWrapper(
                  color: theme?.colorScheme.surface1,
                  child: Column(
                    children: [
                      if (eventTitle != null && eventTitle!.isNotEmpty)
                        Text(
                          eventTitle!,
                          style: boldTextTheme?.subHeadline,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ).paddingOnly(bottom: SpacingFoundation.verticalSpacing14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          context.userAvatar(
                            size: UserAvatarSize.x40x40,
                            type: userTileData?.type ?? UserTileType.ordinary,
                            userName: '',
                            imageUrl: userTileData?.avatarUrl,
                          ),
                          SpacingFoundation.horizontalSpace12,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AutoSizeText(
                                  userTileData?.name ?? S.of(context).NothingFound,
                                  style: boldTextTheme?.body,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (userTileData?.speciality != null && userTileData!.speciality!.isNotEmpty)
                                  Text(
                                    userTileData!.speciality!,
                                    style: boldTextTheme?.caption1Medium,
                                  ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SpacingFoundation.verticalSpace14,
                      UiKitCardWrapper(
                        width: 1.sw - EdgeInsetsFoundation.all16 * 2,
                        borderRadius: BorderRadiusFoundation.all24r,
                        child: ImageWidget(link: contentImageUrl),
                      ),
                      SpacingFoundation.verticalSpace14,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            formatDateWithCustomPattern(
                              'dd.MM.yyyy',
                              (contentDate ?? DateTime.now()).toLocal(),
                            ),
                            style: boldTextTheme?.caption2Bold,
                          ),
                          SpacingFoundation.horizontalSpace8,
                          Text(
                            formatChatMessageDate((contentDate ?? DateTime.now()).toLocal()),
                            style: boldTextTheme?.caption2Bold,
                          ),
                        ],
                      ),
                      SpacingFoundation.verticalSpace12,
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            S.of(context).Total,
                            style: boldTextTheme?.labelLarge,
                          ),
                          const Spacer(),
                          Text(
                            '${price ?? 0} ${currency ?? 'AED'}',
                            style: theme?.boldTextTheme.subHeadline,
                          ),
                        ],
                      )
                    ],
                  ).paddingAll(EdgeInsetsFoundation.all16),
                ),
              SpacingFoundation.verticalSpace24,
              CustomBarcode(
                barcodeNumber: barcodeNumber,
                width: 1.sw - SpacingFoundation.horizontalSpacing16 * 2,
              ),
              SpacingFoundation.verticalSpace24,
            ],
          ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16),
        ),
        SizedBox(
          width: 1.sw - SpacingFoundation.horizontalSpacing16 * 2,
          child: context.gradientButton(
            data: BaseUiKitButtonData(
              onPressed: () async {
                onShareTap?.call(_capturePng);
              },
              loading: isShareLoading,
              text: S.of(context).Share,
            ),
          ),
        ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16),
        SpacingFoundation.verticalSpace24,
      ],
    );
  }
}
