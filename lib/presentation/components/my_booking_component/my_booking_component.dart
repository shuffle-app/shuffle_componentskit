import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/my_booking_component/my_booking_item.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import 'my_booking_ui_model/my_booking_ui_model.dart';

class MyBookingComponent extends StatelessWidget {
  final List<MyBookingUiModel>? myBookingUiModel;
  final ValueChanged<int?>? onAlertCircleTap;
  final ValueChanged<int?>? onBarCodeTap;
  final ValueChanged<int?>? onLeaveFeedbackTap;
  final ValueChanged<int?>? onFullRefundTap;
  final ValueChanged<int?>? onPartialRefundTap;
  late final List<MyBookingUiModel>? myBookingUiModelUpcoming;
  late final List<MyBookingUiModel>? myBookingUiModelPast;

  MyBookingComponent({
    super.key,
    this.myBookingUiModel,
    this.onAlertCircleTap,
    this.onBarCodeTap,
    this.onLeaveFeedbackTap,
    this.onFullRefundTap,
    this.onPartialRefundTap,
  }) {
    myBookingUiModelUpcoming = myBookingUiModel?.where((element) => !element.isPast).toList();
    myBookingUiModelPast = myBookingUiModel?.where((element) => element.isPast).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return Scaffold(
      body: BlurredAppBarPage(
        title: S.of(context).MyBooking,
        centerTitle: true,
        autoImplyLeading: true,
        childrenPadding: EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing16),
        children: [
          SpacingFoundation.verticalSpace16,
          Text(
            S.of(context).Upcoming,
            style: theme?.boldTextTheme.title2,
          ),
          SpacingFoundation.verticalSpace16,
          for (int index = 0; index < (myBookingUiModelUpcoming?.length ?? 0); index++)
            MyBookingItem(
              myBookingUiModel: myBookingUiModelUpcoming?[index],
              onAlertCircleTap: () => onAlertCircleTap?.call(myBookingUiModelUpcoming?[index].id),
              onBarCodeTap: onBarCodeTap,
              onFullRefundTap: onFullRefundTap,
              onLeaveFeedbackTap: onLeaveFeedbackTap,
              onPartialRefundTap: onPartialRefundTap,
            ).paddingOnly(
              bottom: myBookingUiModelUpcoming?[index] != myBookingUiModelUpcoming?.last
                  ? SpacingFoundation.verticalSpacing32
                  : 0,
            ),
          SizedBox(height: SpacingFoundation.verticalSpacing32),
          Row(
            children: [
              Text(
                S.of(context).Past,
                style: theme?.boldTextTheme.title2,
              ),
              SpacingFoundation.horizontalSpace16,
              Builder(
                builder: (context) => GestureDetector(
                  onTap: () => showUiKitPopover(
                    context,
                    customMinHeight: 30.h,
                    showButton: false,
                    title: Text(
                      S.of(context).YouCanStillRequestRefundYourComplaint,
                      style: theme?.regularTextTheme.body.copyWith(color: Colors.black87),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  child: ImageWidget(
                    iconData: ShuffleUiKitIcons.info,
                    width: 20.w,
                    color: theme?.colorScheme.darkNeutral900,
                  ),
                ),
              ),
            ],
          ),
          SpacingFoundation.verticalSpace16,
          for (int index = 0; index < (myBookingUiModelPast?.length ?? 0); index++)
            MyBookingItem(
              myBookingUiModel: myBookingUiModelPast?[index],
              onAlertCircleTap: () => onAlertCircleTap?.call(myBookingUiModelPast?[index].id),
              onBarCodeTap: onBarCodeTap,
              onFullRefundTap: onFullRefundTap,
              onLeaveFeedbackTap: onLeaveFeedbackTap,
              onPartialRefundTap: onPartialRefundTap,
            ).paddingOnly(bottom: SpacingFoundation.verticalSpacing32)
        ],
      ),
    );
  }
}
