import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/profile/hall_of_fame_component/fame_item_dialog.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

showModelViewerDialog(
  BuildContext context,
  UiKitAchievementsModel uiKitAchievementsModel,
) =>
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: widget,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Dialog(
            backgroundColor: Colors.transparent,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusFoundation.all24,
            ),
            child: FameItemDialog(
              filePath: uiKitAchievementsModel.objectUrl ?? '',
              filePoster: uiKitAchievementsModel.posterUrl ?? '',
              uiRewardProgressModel: uiKitAchievementsModel.uiRewardProgressModel,
            ),
          );
        });
