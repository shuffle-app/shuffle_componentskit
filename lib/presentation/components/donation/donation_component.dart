import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

part 'donation_tab_menu.dart';

class DonationComponent extends StatelessWidget {
  const DonationComponent({
    super.key,
    required this.sum,
    required this.actualSum,
    required this.topDayUsers,
    required this.topYearUsers,
    required this.donationTitle,
    required this.topMonthUsers,
    required this.donationNumber,
    required this.onMapTap,
    required this.onAskDonationTap,
    required this.onDonationIndicatorTap,
    this.onNextButtonTap,
  });

  final double sum;
  final double actualSum;
  final String donationTitle;
  final int donationNumber;

  final VoidCallback onMapTap;
  final VoidCallback onAskDonationTap;
  final VoidCallback onDonationIndicatorTap;
  final VoidCallback? onNextButtonTap;

  final List<UiDonationUserModel> topDayUsers;
  final List<UiDonationUserModel> topMonthUsers;
  final List<UiDonationUserModel> topYearUsers;

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    //TODO move to strings/config
    const hintTitle = 'You can only spend on your dream, otherwise the money will go back to the donators. One request per month.';
    final boldTextTheme = theme?.boldTextTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpacingFoundation.verticalSpace16,
        Row(children: [
        Text(S.of(context).AskPeople, style: boldTextTheme?.title1),
          const Spacer(),
          Builder(
            builder: (context) {
              return GestureDetector(
                onTap: () => showUiKitPopover(
                  context,
                  showButton: false,
                  title: Text(
                    hintTitle,
                    style: theme?.regularTextTheme.body.copyWith(
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                child: ImageWidget(
                  iconData: ShuffleUiKitIcons.info,
                  width: 16.w,
                  color: theme?.colorScheme.darkNeutral900,
                ),
              );
            },
          ),]),
        SpacingFoundation.verticalSpace16,
        DonationInfoIndicatorCard(
          number: donationNumber.toString(),
          title: donationTitle,
          sum: sum,
          actualSum: actualSum,
          onButtonTap: onDonationIndicatorTap,
        ),
        SpacingFoundation.verticalSpace16,
        Center(
          child: context.gradientButton(
            data: BaseUiKitButtonData(
              fit: ButtonFit.fitWidth,
              text: S.of(context).AskForDonations,
              onPressed: onAskDonationTap,
            ),
          ),
        ),
        SpacingFoundation.verticalSpace16,
        Text(S.of(context).SupportPeopleAroundYou, style: boldTextTheme?.title1),
        SpacingFoundation.verticalSpace16,
        UiKitCardWrapper(
          color: context.uiKitTheme?.colorScheme.surface1,
          child: Column(
            children: [
              DonationMapPreview(onTap: onMapTap),
              SpacingFoundation.verticalSpace16,
              Text(
                S.of(context).TopNDonatorsReceiveXPoints(3, 100),
                textAlign: TextAlign.center,
                style: boldTextTheme?.subHeadline,
              ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
              SpacingFoundation.verticalSpace16,
              _DonationTabMenu(
                onNextButtonTap: onNextButtonTap,
                topDayUsers: topDayUsers,
                topMonthUsers: topMonthUsers,
                topYearUsers: topYearUsers,
              ),
              SpacingFoundation.verticalSpace16,
            ],
          ),
        ),
        SpacingFoundation.verticalSpace24,
      ],
    ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16);
  }
}
