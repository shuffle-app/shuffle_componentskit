import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';

subInformationDialog(
  BuildContext context,
  SubsUiModel sub,
) {
  final theme = context.uiKitTheme;

  showGeneralDialog(
    barrierColor: const Color(0xff2A2A2A),
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
        insetPadding: EdgeInsets.all(EdgeInsetsFoundation.all16),
        backgroundColor: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusFoundation.all24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: context.pop,
              child: ImageWidget(
                iconData: ShuffleUiKitIcons.cross,
                color: theme?.colorScheme.darkNeutral900,
                height: 19.h,
                fit: BoxFit.fitHeight,
              ),
            ),
            SpacingFoundation.verticalSpace16,
            UiKitCardWrapper(
              padding: EdgeInsets.all(EdgeInsetsFoundation.all24),
              color: theme?.colorScheme.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                 AutoSizeText(
                    sub.title ?? '',
                    style: theme?.boldTextTheme.title2,
                  ),
                  1.sw <= 380 ? SpacingFoundation.verticalSpace12 : SpacingFoundation.verticalSpace16,
                  Center(
                    child: GradientableWidget(
                      blendMode: BlendMode.dstIn,
                      gradient: LinearGradient(
                        colors: [theme?.colorScheme.primary ?? Colors.white, Colors.transparent],
                        stops: const [0.80, 1.0],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      child: UiKitCardWrapper(
                        borderRadius: BorderRadiusFoundation.all12,
                        child: ImageWidget(
                          height: 0.4.sh,
                          link: sub.photoPath,
                        ),
                      ),
                    ),
                  ),
                  SpacingFoundation.verticalSpace24,
                  Text(
                    sub.description ?? '',
                    style: theme?.regularTextTheme.caption2,
                  ),
                ],
              ),
            )
          ],
        ),
      );
    },
  );
}
