import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';

class BookingPaymentTypeSelectionComponent extends StatefulWidget {
  final StripeRegistrationStatus? stripeRegistrationStatus;
  final List<BookingPaymentType> selectedPaymentTypes;
  final ValueChanged<List<BookingPaymentType>> goNext;

  const BookingPaymentTypeSelectionComponent(
      {super.key, required this.selectedPaymentTypes, required this.goNext, this.stripeRegistrationStatus});

  @override
  State<BookingPaymentTypeSelectionComponent> createState() => _BookingPaymentTypeSelectionComponentState();
}

class _BookingPaymentTypeSelectionComponentState extends State<BookingPaymentTypeSelectionComponent> {
  bool selectedMoney = false;
  bool selectedCrypto = false;
  bool selectedFree = false;
  bool selectedEntrance = false;
  bool selectedQR = false;
  bool selectedCash = false;

  @override
  void initState() {
    for (var i in widget.selectedPaymentTypes) {
      switch (i) {
        case BookingPaymentType.onlineCard:
          selectedMoney = true;
          break;
        case BookingPaymentType.onlineCrypto:
          selectedCrypto = true;
          break;
        case BookingPaymentType.free:
          selectedFree = true;
          break;
        case BookingPaymentType.offlineQR:
          selectedQR = true;
          selectedEntrance = true;
          break;
        case BookingPaymentType.offlineCash:
          selectedCash = true;
          selectedEntrance = true;
          break;
      }
    }
    super.initState();
  }

  List<BookingPaymentType> get getSelectedTypes {
    List<BookingPaymentType> types = [];
    if (selectedMoney) types.add(BookingPaymentType.onlineCard);
    if (selectedCrypto) types.add(BookingPaymentType.onlineCrypto);
    if (selectedFree) types.add(BookingPaymentType.free);
    if (selectedQR) types.add(BookingPaymentType.offlineQR);
    if (selectedCash) types.add(BookingPaymentType.offlineCash);
    return types;
  }

  bool get isNotEligibleToSelectCard =>
      selectedFree || widget.stripeRegistrationStatus == StripeRegistrationStatus.notStarted;

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final boldTextTheme = theme?.boldTextTheme;

    return Scaffold(
      body: BlurredAppBarPage(
        customTitle: Flexible(
          child: AutoSizeText(
            S.current.Booking,
            style: boldTextTheme?.title1,
            maxLines: 1,
          ),
        ),
        centerTitle: true,
        autoImplyLeading: true,
        childrenPadding: EdgeInsets.symmetric(
            vertical: SpacingFoundation.verticalSpacing4, horizontal: SpacingFoundation.horizontalSpacing16),
        children: [
          const SizedBox.shrink(),
          Text(
            S.of(context).SelectBookingType,
            style: theme?.boldTextTheme.title2,
          ),
          const SizedBox.shrink(),

          ///Stripe
          ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Transform.scale(
                  scale: 1.22,
                  child: UiKitCheckbox(
                    isActive: selectedMoney,
                    disabled: isNotEligibleToSelectCard,
                    onChanged: () {
                      setState(() {
                        selectedMoney = !selectedMoney;
                      });
                    },
                  )),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        '${S.current.ForMoney} ${S.current.Online.toLowerCase()} (Stripe)',
                        style: boldTextTheme?.labelLarge,
                      )),
                      Builder(
                        builder: (context) => GestureDetector(
                          onTap: () => showUiKitPopover(
                            context,
                            customMinHeight: 30.h,
                            showButton: false,
                            title: Text(
                              S.of(context).HintStripe,
                              style: theme?.regularTextTheme.body.copyWith(color: Colors.black87),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          child: ImageWidget(
                            iconData: ShuffleUiKitIcons.info,
                            width: 16.w,
                            color: theme?.colorScheme.darkNeutral900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (widget.stripeRegistrationStatus != null)
                    Row(children: [
                      Text(S.current.StripeRegistration,
                          style: theme?.regularTextTheme.caption4.copyWith(fontWeight: FontWeight.w400)),
                      SpacingFoundation.horizontalSpace12,
                      UiKitBadgeColored.withoutBorder(
                          title: widget.stripeRegistrationStatus!.stringValue,
                          color: widget.stripeRegistrationStatus!.colorValue,
                          borderRadius: BorderRadiusFoundation.all12,
                          customTextStyle: theme?.regularTextTheme.caption4)
                    ]),
                ],
              ),
              titleTextStyle: boldTextTheme?.labelLarge,
              horizontalTitleGap: 0),

          ///Crypto
          ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Transform.scale(
                  scale: 1.22,
                  child: UiKitCheckbox(
                    isActive: selectedCrypto,
                    disabled: selectedFree,
                    onChanged: () {
                      setState(() {
                        selectedCrypto = !selectedCrypto;
                      });
                    },
                  )),
              titleTextStyle: boldTextTheme?.labelLarge,
              horizontalTitleGap: 0,
              title: Text(S.current.ForCrypto)),

          ///Free
          ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Transform.scale(
                  scale: 1.22,
                  child: UiKitCheckbox(
                    isActive: selectedFree,
                    onChanged: () {
                      setState(() {
                        selectedFree = !selectedFree;
                        if (selectedFree) {
                          selectedMoney = false;
                          selectedCrypto = false;
                          selectedEntrance = false;
                          selectedQR = false;
                          selectedCash = false;
                        }
                      });
                    },
                  )),
              titleTextStyle: boldTextTheme?.labelLarge,
              horizontalTitleGap: 0,
              title: Text(S.current.Free)),

          ///Entrance
          ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Transform.scale(
                  scale: 1.22,
                  child: UiKitCheckbox(
                    isActive: selectedEntrance,
                    disabled: selectedFree,
                    onChanged: () {
                      setState(() {
                        selectedEntrance = !selectedEntrance;
                        if (selectedEntrance) {
                          selectedQR = true;
                          selectedCash = true;
                        } else {
                          selectedQR = false;
                          selectedCash = false;
                        }
                      });
                    },
                  )),
              titleTextStyle: boldTextTheme?.labelLarge,
              horizontalTitleGap: 0,
              title: Text(S.current.AtEntrance)),

          ///QR
          ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Transform.scale(
                      scale: 1.22,
                      child: UiKitCheckbox(
                        isActive: selectedQR,
                        disabled: selectedFree || !selectedEntrance,
                        onChanged: () {
                          setState(() {
                            selectedQR = !selectedQR;
                          });
                        },
                      )),
                  titleTextStyle: boldTextTheme?.labelLarge,
                  horizontalTitleGap: 0,
                  title: Text('QR Code'))
              .paddingOnly(left: SpacingFoundation.horizontalSpacing20),

          ///Cash
          ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Transform.scale(
                      scale: 1.22,
                      child: UiKitCheckbox(
                        isActive: selectedCash,
                        disabled: selectedFree || !selectedEntrance,
                        onChanged: () {
                          setState(() {
                            selectedCash = !selectedCash;
                          });
                        },
                      )),
                  titleTextStyle: boldTextTheme?.labelLarge,
                  horizontalTitleGap: 0,
                  title: Text(S.current.Cash))
              .paddingOnly(left: SpacingFoundation.horizontalSpacing20),
        ],
      ),
      bottomNavigationBar: SafeArea(
          child: SizedBox(
              height: kBottomNavigationBarHeight,
              child: context.button(
                data: BaseUiKitButtonData(
                    text: S.current.Next,
                    onPressed: getSelectedTypes.isEmpty ? null : () => widget.goNext(getSelectedTypes),
                    fit: ButtonFit.fitWidth),
              )).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16)),
    );
  }
}
