import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/my_booking_component/my_booking_item.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import 'my_booking_ui_model/my_booking_ui_model.dart';

class MyBookingComponent extends StatelessWidget {
  final List<MyBookingUiModel>? myBookingUiModel;
  final VoidCallback? onAlertCircleTap;
  final ValueChanged<int?>? onBarCodeTap;
  final ValueChanged<int?>? onLeaveFeedbackTap;
  final ValueChanged<int?>? onFullRefundTap;
  final ValueChanged<int?>? onPartialRefundTap;

  const MyBookingComponent({
    super.key,
    this.myBookingUiModel,
    this.onAlertCircleTap,
    this.onBarCodeTap,
    this.onLeaveFeedbackTap,
    this.onFullRefundTap,
    this.onPartialRefundTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    final List<MyBookingUiModel>? myBookingUiModelUpcoming =
        myBookingUiModel?.where((element) => !element.isPast).toList();
    final List<MyBookingUiModel>? myBookingUiModelPast = myBookingUiModel?.where((element) => element.isPast).toList();

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
          ListView.separated(
            shrinkWrap: true,
            controller: ScrollController(),
            itemCount: myBookingUiModelUpcoming?.length ?? 0,
            padding: EdgeInsets.all(EdgeInsetsFoundation.zero),
            separatorBuilder: (_, __) => SizedBox(height: SpacingFoundation.verticalSpacing32),
            itemBuilder: (context, index) {
              return MyBookingItem(
                myBookingUiModel: myBookingUiModelUpcoming?[index],
                onAlertCircleTap: onAlertCircleTap,
                onBarCodeTap: onBarCodeTap,
                onFullRefundTap: onFullRefundTap,
                onLeaveFeedbackTap: onLeaveFeedbackTap,
                onPartialRefundTap: onPartialRefundTap,
              );
            },
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
          ListView.separated(
            shrinkWrap: true,
            controller: ScrollController(),
            itemCount: myBookingUiModelPast?.length ?? 0,
            padding: EdgeInsets.all(EdgeInsetsFoundation.zero),
            separatorBuilder: (_, __) => SizedBox(height: SpacingFoundation.verticalSpacing32),
            itemBuilder: (context, index) {
              return MyBookingItem(
                myBookingUiModel: myBookingUiModelPast?[index],
                onAlertCircleTap: onAlertCircleTap,
                onBarCodeTap: onBarCodeTap,
                onFullRefundTap: onFullRefundTap,
                onLeaveFeedbackTap: onLeaveFeedbackTap,
                onPartialRefundTap: onPartialRefundTap,
              );
            },
          ),
        ],
      ),
    );
  }
}
