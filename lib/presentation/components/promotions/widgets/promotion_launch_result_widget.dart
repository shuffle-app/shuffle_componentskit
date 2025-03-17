import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../ui_models/promotion_launch_result_ui_model.dart';

class PromotionLaunchResultWidget extends StatelessWidget {
  final PromotionLaunchResultUiModel model;

  const PromotionLaunchResultWidget({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final regularTextTheme = theme?.regularTextTheme;
    final color = ((model.toDayCount == model.yesterdayCount) || (model.title == S.current.BudgetPromo))
        ? ColorsFoundation.info
        : model.toDayCount < model.yesterdayCount
            ? ColorsFoundation.error
            : ColorsFoundation.success;

    return Row(
      children: [
        Text(
          model.title,
          style: regularTextTheme?.labelSmall,
        ),
        if (model.popOverText != null && model.popOverText!.isNotEmpty) ...[
          SpacingFoundation.horizontalSpace12,
          Builder(
            builder: (context) => GestureDetector(
              onTap: () => showUiKitPopover(
                context,
                customMinHeight: 30.h,
                showButton: false,
                title: Text(
                  model.popOverText!,
                  style: regularTextTheme?.body.copyWith(color: Colors.black87),
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
          Spacer(),
        ],
        DecoratedBox(
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.16),
            borderRadius: BorderRadiusFoundation.all12,
          ),
          child: Text(
            model.title == S.current.BudgetPromo ? '${model.toDayCount}\$' : '+${model.toDayCount.toCompactString()}',
            style: theme?.boldTextTheme.caption2Medium.copyWith(color: color),
          ).paddingSymmetric(
            horizontal: SpacingFoundation.horizontalSpacing8,
            vertical: SpacingFoundation.verticalSpacing4,
          ),
        )
      ],
    );
  }
}
