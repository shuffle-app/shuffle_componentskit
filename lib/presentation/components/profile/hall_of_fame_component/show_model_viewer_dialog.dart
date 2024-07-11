import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/profile/hall_of_fame_component/fame_item_dialog.dart';
import 'package:shuffle_uikit/foundation/border_radius_foundation.dart';
import 'package:shuffle_uikit/ui_kit/atoms/profile/ui_reward_progress_model.dart';

showModelViewerDialog(
  BuildContext context,
  String filePath,
  String filePoster,
  UiRewardProgressModel? uiRewardProgressModel,
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
            // child: SizedBox(
            //     height: 0.4.sh,
            //     child: UiKitBase3DViewer(
            //       localPath: filePath,
            //       poster: filePoster,
            //       autoRotate: true,
            //       // environmentImage: 'https://shuffle-app-production.s3.eu-west-2.amazonaws.com/static-files/3dmodels/environments/environment1.jpeg',
            //     )),
            child: UiKitFameItemDialog(
              filePath: filePath,
              filePoster: filePoster,
              uiRewardProgressModel: uiRewardProgressModel,
            ),
          );
        });
