import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class DonationComponent extends StatelessWidget {
  const DonationComponent({
    super.key,
    this.onMapTap,
    this.onAskDonationTap,
  });

  final VoidCallback? onMapTap;
  final VoidCallback? onAskDonationTap;

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
          number: '1',
          title: 'Help me visit Nusr-Et restaurant',
          sum: 900,
          actualSum: 310,
           onButtonTap: (){},
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
              // const DonationTabMenu(),
              SpacingFoundation.verticalSpace16,
            ],
          ),
        ),
        SpacingFoundation.verticalSpace24,
      ],
    ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16);
  }
}
