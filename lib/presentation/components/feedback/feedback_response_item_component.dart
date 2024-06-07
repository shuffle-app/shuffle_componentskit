import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/domain/data_uimodels/feedback_response_ui_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class FeedbackResponseItemComponent extends StatelessWidget {
  const FeedbackResponseItemComponent({super.key, required this.feedBacks});

  final List<FeedbackResponseUiModel> feedBacks;

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;
    const divider = Divider(
      height: 2,
      thickness: 3,
      color: ColorsFoundation.surface2,
    );
    return UiKitCardWrapper(
      child: Column(
        children: feedBacks.map(
          (e) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    context.userAvatar(
                      size: UserAvatarSize.x24x24,
                      type: UserTileType.ordinary,
                      userName: e.senderName,
                      imageUrl: e.senderImagePath,
                    ),
                    SpacingFoundation.horizontalSpace12,
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                e.senderName,
                                style: boldTextTheme?.caption1Bold,
                              ),
                            ],
                          ),
                          Text(
                            formatDifference(e.timeSent),
                            style: boldTextTheme?.caption1Medium
                                .copyWith(color: ColorsFoundation.mutedText),
                          ),
                        ],
                      ),
                    ),
                    SpacingFoundation.horizontalSpace12,
                    // if (e.senderIsMe) ...[
                    //   context.iconButtonNoPadding(
                    //     data: BaseUiKitButtonData(
                    //       onPressed: () {},
                    //       iconInfo: BaseUiKitButtonIconData(
                    //         iconData: ShuffleUiKitIcons.pencil,
                    //         color: ColorsFoundation.mutedText,
                    //         size: 16.sp
                    //       ),
                    //     ),
                    //   ),
                    //   SpacingFoundation.horizontalSpace12,
                    //   context.iconButtonNoPadding(
                    //     data: BaseUiKitButtonData(
                    //       onPressed: () {},
                    //       iconInfo: BaseUiKitButtonIconData(
                    //           iconData: ShuffleUiKitIcons.trash,
                    //           color: ColorsFoundation.mutedText,
                    //           size: 16.sp
                    //       ),
                    //     ),
                    //   ),
                    // ]
                  ],
                ),
                SpacingFoundation.verticalSpace12,
                Text(
                  e.message ?? '',
                  style: boldTextTheme?.caption1Medium,
                ),
                SpacingFoundation.verticalSpace12,
                if (!e.senderIsMe)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(ShuffleUiKitIcons.like,
                          color: ColorsFoundation.mutedText, size: 16.sp),
                      SpacingFoundation.horizontalSpace8,
                      Text(
                        '${S.current.Helpful} ${e.helpfulCount ?? 0}',
                        style: boldTextTheme?.caption1Medium
                            .copyWith(color: ColorsFoundation.mutedText),
                      ),
                    ],
                  ),
                if (e != feedBacks[feedBacks.length - 1])
                  divider.paddingSymmetric(
                      vertical: EdgeInsetsFoundation.vertical16),
              ],
            );
          },
        ).toList(),
      ).paddingAll(EdgeInsetsFoundation.all16),
    );
  }
}
