import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class VideoCutterComponent extends StatelessWidget {
  final dynamic videoFile;
  final VoidCallback? onNextPressed;
  final VoidCallback? onBackPressed;
  final bool loading;

  const VideoCutterComponent({
    Key? key,
    required this.videoFile,
    this.onNextPressed,
    this.onBackPressed,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              context.smallOutlinedButton(
                data: BaseUiKitButtonData(
                  text: S.current.Back,
                  onPressed: () {
                    onBackPressed?.call();
                    context.pop();
                  },
                  iconInfo: BaseUiKitButtonIconData(
                    iconData: ShuffleUiKitIcons.chevronleft,
                    iconAlignment: Alignment.centerLeft,
                  ),
                ),
              ),
              context.smallButton(
                data: BaseUiKitButtonData(
                  text: S.current.Next,
                  onPressed: onNextPressed,
                  iconInfo: BaseUiKitButtonIconData(
                    iconData: ShuffleUiKitIcons.chevronright,
                  ),
                ),
              ),
            ],
          ),
          SpacingFoundation.verticalSpace16,
          Expanded(
            child: VideoCutter(
              videoFile: videoFile,
              onExportFinished: (filePath) {
                // Do something with the cutted video file
              },
            ).loadingWrap(loading, color: context.uiKitTheme?.colorScheme.inversePrimary),
          ),
          SpacingFoundation.verticalSpace24,
        ],
      ),
    );
  }
}
