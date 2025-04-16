import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/bookings_control/users_bookings_control.dart';
import 'package:shuffle_components_kit/presentation/presentation.dart'
    show BookingsPlaceOrEventUiModel, UpsaleUiModel, UserBookingsControlUiModel;
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:auto_size_text/auto_size_text.dart';

class TicketInfoComponent extends StatelessWidget {
  final BookingsPlaceOrEventUiModel? contentUiModel;
  final UserBookingsControlUiModel user;
  final List<UpsaleUiModel>? upsale;
  final Function(String? value, int userId)? onPopupMenuSelected;

  TicketInfoComponent({
    super.key,
    this.contentUiModel,
    required this.user,
    this.upsale = const [],
    this.onPopupMenuSelected,
  });

  late final upsaleTotalPrice = upsale?.map((e) =>
          double.parse(e.price ?? '0') *
          (user.ticketUiModel?.upsales?.firstWhereOrNull((e2) => e2?.item?.id == e.id)?.count ?? 0)) ??
      [0.0];
  late final int allTicketsCount = user.ticketUiModel?.ticketsCount ?? 1;
  late final double oneTicketPrice =
      ((user.ticketUiModel?.totalAmount ?? 0) - upsaleTotalPrice.fold(0, (acc, cur) => acc + cur)) / (allTicketsCount);
  late final String? typeOfPaymentTitle;

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final boldTextTheme = theme?.boldTextTheme;
    final caption5Semibold = theme?.regularTextTheme.caption4.copyWith(fontWeight: FontWeight.w600);
    final captionStyle = boldTextTheme?.caption3Medium.copyWith(
      color: ColorsFoundation.mutedText,
    );

    TextStyle? textStyle = theme?.boldTextTheme.title1 ?? Theme.of(context).primaryTextTheme.titleMedium;
    textStyle = textStyle?.copyWith(color: theme?.colorScheme.inversePrimary);

    switch (user.paymentType) {
      case 1:
        typeOfPaymentTitle = S.current.PaymentInCrypto;
      case 2:
        typeOfPaymentTitle = S.current.OnlinePayment;
      case 3:
        typeOfPaymentTitle = S.current.OnlyQRCodePayment;
      case 4:
        typeOfPaymentTitle = S.current.AtEntranceCash;
      default:
        typeOfPaymentTitle = S.current.FreeTicket;
    }

    return BlurredAppBarPage(
      customTitle: AutoSizeText(S.of(context).TicketInfo, maxLines: 1, style: textStyle),
      centerTitle: true,
      autoImplyLeading: true,
      childrenPadding: EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing16),
      physics: AlwaysScrollableScrollPhysics(parent: const BouncingScrollPhysics()),
      children: [
        SpacingFoundation.verticalSpace16,
        UsersBookingsControl(
          element: user,
          onPopupMenuSelected: onPopupMenuSelected,
          onRequestsRefund: () {},
          popUpItemBuilder: (context) {
            return [
              PopupMenuItem(
                value: 'refund',
                child: Text(
                  S.of(context).FullRefund,
                  style: boldTextTheme?.caption2Medium.copyWith(
                    color: theme?.colorScheme.inverseBodyTypography,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 'partialrefund',
                child: Text(
                  S.of(context).PartialRefund,
                  style: boldTextTheme?.caption2Medium.copyWith(
                    color: theme?.colorScheme.inverseBodyTypography,
                  ),
                ),
              )
            ];
          },
        ),
        SpacingFoundation.verticalSpace16,
        if (contentUiModel != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              context.userAvatar(
                size: UserAvatarSize.x40x40,
                type: UserTileType.ordinary,
                userName: contentUiModel!.title ?? '',
                imageUrl: contentUiModel!.imageUrl,
              ),
              SpacingFoundation.horizontalSpace12,
              Expanded(
                child: Text(
                  contentUiModel!.title ?? S.of(context).NothingFound,
                  style: boldTextTheme?.caption1Medium,
                ),
              ),
            ],
          ),
        if (user.visitDate != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Spacer(),
              Text(
                formatDateWithCustomPattern('dd.MM.yyyy', user.visitDate!.toLocal()),
                style: captionStyle,
              ),
              SpacingFoundation.horizontalSpace8,
              Text(
                formatChatMessageDate(user.visitDate!.toLocal()),
                style: captionStyle,
              ),
            ],
          ),
        SpacingFoundation.verticalSpace16,
        if (typeOfPaymentTitle != null)
          Text(
            typeOfPaymentTitle!,
            style: boldTextTheme?.caption3Medium.copyWith(color: ColorsFoundation.mutedText),
          ).paddingOnly(bottom: SpacingFoundation.verticalSpacing4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 80.w,
              child: Text(
                S.of(context).Ticket,
                style: boldTextTheme?.caption1Medium,
              ),
            ),
            SpacingFoundation.horizontalSpace16,
            Text(
              allTicketsCount > 1 ? '1/${allTicketsCount}' : '1',
              style: boldTextTheme?.caption1Bold,
            ),
          ],
        ),
        SpacingFoundation.verticalSpace4,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 80.w),
            SpacingFoundation.horizontalSpace16,
            Text(
              '${doubleFormat(oneTicketPrice)} ${contentUiModel?.currency ?? 'AED'}',
              style: caption5Semibold,
            ),
          ],
        ),
        SpacingFoundation.verticalSpace8,
        if (user.ticketUiModel?.totalUpsalesCount != null && user.ticketUiModel?.totalUpsalesCount != 0)
          Row(
            children: [
              SizedBox(
                width: 80.w,
                child: AutoSizeText(
                  S.of(context).Product,
                  style: boldTextTheme?.caption1Medium,
                  maxLines: 1,
                ),
              ),
              SpacingFoundation.horizontalSpace16,
              Text(
                '${user.ticketUiModel?.totalUpsalesCount ?? 0}',
                style: boldTextTheme?.caption1Bold,
              ),
            ],
          ).paddingOnly(bottom: SpacingFoundation.verticalSpacing4),
        if (upsale != null &&
            upsale!.isNotEmpty &&
            user.ticketUiModel?.upsales != null &&
            user.ticketUiModel!.upsales!.isNotEmpty)
          SizedBox(
            height: 120.w,
            child: ListView.builder(
              itemCount: user.ticketUiModel!.upsales!.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final item = upsale![index];
                final upsaleCount = user.ticketUiModel?.upsales?.firstWhereOrNull((e) => e?.item?.id == item.id);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GradientableWidget(
                      blendMode: BlendMode.dstIn,
                      gradient: LinearGradient(
                        colors: [theme?.colorScheme.primary ?? Colors.white, Colors.transparent],
                        stops: const [0.80, 1.0],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      child: UiKitCardWrapper(
                        borderRadius: BorderRadiusFoundation.all12,
                        child: Stack(
                          children: [
                            ImageWidget(
                              height: 56.w,
                              width: 72.w,
                              link: item.photoPath,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              bottom: SpacingFoundation.verticalSpacing4,
                              left: SpacingFoundation.verticalSpacing4,
                              child: Text(
                                '${upsaleCount?.count ?? ''}',
                                style: caption5Semibold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ).paddingOnly(right: SpacingFoundation.horizontalSpacing16),
                    SpacingFoundation.verticalSpace4,
                    Text(
                      '${item.price ?? 0} ${item.currency ?? 'AED'}',
                      style: caption5Semibold,
                    ),
                    SpacingFoundation.verticalSpace4,
                    SizedBox(
                      width: 72.w,
                      child: Text(
                        '${item.description}',
                        style: theme?.regularTextTheme.caption4,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        SpacingFoundation.verticalSpace16,
        Row(
          children: [
            SizedBox(
              width: 80.w,
              child: Text(
                S.of(context).Total,
                style: boldTextTheme?.caption1Medium,
              ),
            ),
            SpacingFoundation.horizontalSpace16,
            Text(
              '${user.ticketUiModel?.totalAmount} ${contentUiModel?.currency ?? 'AED'}',
              style: boldTextTheme?.caption1Bold,
            ),
          ],
        ),
        if (user.paymentType == 4)
          UiKitCardWrapper(
            color: ColorsFoundation.warning.withValues(alpha: 0.16),
            child: Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorsFoundation.warning.withValues(alpha: 0.16),
                  ),
                  child: ImageWidget(
                    iconData: ShuffleUiKitIcons.coin,
                    color: ColorsFoundation.warning,
                  ).paddingAll(EdgeInsetsFoundation.all6),
                ),
                SpacingFoundation.horizontalSpace8,
                Flexible(
                  child: Text(
                    S.of(context).NeedToChargeMoneyForEntry,
                    style: boldTextTheme?.caption1Medium,
                  ),
                ),
              ],
            ).paddingAll(EdgeInsetsFoundation.all12),
          ).paddingOnly(top: SpacingFoundation.verticalSpacing16),
        SpacingFoundation.verticalSpace24,
      ],
    );
  }
}
