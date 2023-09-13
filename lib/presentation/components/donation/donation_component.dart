import 'package:flutter/cupertino.dart';
import 'package:shuffle_components_kit/presentation/components/donation/ui_donation_user_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';

part 'donation_tab_menu.dart';

class DonationComponent extends StatelessWidget {
  const DonationComponent({
    super.key,
    this.onMapTap,
    this.onAskDonationTap,
    this.onNextButtonTap,
    required this.sum,
    required this.actualSum,
    required this.topDayUsers,
    required this.topYearUsers,
    required this.donationTitle,
    required this.topMonthUsers,
    required this.donationNumber,
  });

  final double sum;
  final double actualSum;
  final String donationTitle;
  final int donationNumber;

  final VoidCallback? onMapTap;
  final VoidCallback? onAskDonationTap;
  final VoidCallback? onNextButtonTap;

  final List<UiDonationUserModel> topDayUsers;
  final List<UiDonationUserModel> topMonthUsers;
  final List<UiDonationUserModel> topYearUsers;

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpacingFoundation.verticalSpace16,
        Text('Ask people', style: boldTextTheme?.title1),
        SpacingFoundation.verticalSpace16,
        DonationInfoIndicatorCard(
          number: donationNumber.toString(),
          title: donationTitle,
          sum: sum,
          actualSum: actualSum,
        ),
        SpacingFoundation.verticalSpace16,
        Center(
          child: context.gradientButton(
            data: BaseUiKitButtonData(
              fit: ButtonFit.fitWidth,
              text: 'Ask for donations',
              onPressed: onAskDonationTap,
            ),
          ),
        ),
        SpacingFoundation.verticalSpace16,
        Text('Support people around you', style: boldTextTheme?.title1),
        SpacingFoundation.verticalSpace16,
        UiKitCardWrapper(
          child: Column(
            children: [
              DonationMapPreview(onTap: onMapTap),
              SpacingFoundation.verticalSpace16,
              Text(
                'Top 3 donators receive x100 points',
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
