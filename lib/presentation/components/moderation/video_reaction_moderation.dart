import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class VideoReactionModeration extends StatelessWidget {
  final List<ReactionPreviewUiModel> reactionPreviewModelList;
  final Function() deleteFunction;
  final Function() sortFunction;

  const VideoReactionModeration({
    super.key,
    required this.deleteFunction,
    required this.sortFunction,
    required this.reactionPreviewModelList,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final textTheme = theme?.boldTextTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme?.colorScheme.surface,
        borderRadius: BorderRadiusFoundation.all24,
      ),
      child: Column(
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                S.of(context).VideoReactions,
                style: textTheme?.title1,
              ),
              const Spacer(),
              context.coloredButtonWithBorderRadius(
                data: BaseUiKitButtonData(
                  fit: ButtonFit.hugContent,
                  textColor: theme?.colorScheme.inversePrimary,
                  backgroundColor:
                      theme?.colorScheme.darkNeutral900.withOpacity(0.68),
                  text: S.of(context).ShowDeleted,
                  onPressed: deleteFunction,
                ),
              ),
              SpacingFoundation.horizontalSpace12,
              context.iconButtonNoPadding(
                data: BaseUiKitButtonData(
                  onPressed: sortFunction,
                  iconInfo: BaseUiKitButtonIconData(
                    iconData: ShuffleUiKitIcons.arrowssort,
                  ),
                ),
              )
            ],
          ).paddingAll(EdgeInsetsFoundation.all24),
          Expanded(
            child: GridView.builder(
              itemCount: reactionPreviewModelList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: SpacingFoundation.horizontalSpacing24,
                mainAxisSpacing: SpacingFoundation.horizontalSpacing24,
                crossAxisCount: 3,
                mainAxisExtent: 0.7.sh,
              ),
              itemBuilder: (context, index) {
                final reactionPreviewModelItem =
                    reactionPreviewModelList[index];

                return UiKitReactionPreview(
                  customHeight: reactionPreviewModelItem.customHeight,
                  customWidth: reactionPreviewModelItem.customWidth,
                  isEmpty: reactionPreviewModelItem.isEmpty,
                  imagePath: reactionPreviewModelItem.imagePath,
                  viewed: reactionPreviewModelItem.viewed,
                  onTap: reactionPreviewModelItem.onTap,
                );
              },
            ).paddingSymmetric(
                horizontal: SpacingFoundation.horizontalSpacing24),
          )
        ],
      ),
    );
  }
}

class ReactionPreviewUiModel {
  final String? imagePath;
  final bool viewed;
  final bool isEmpty;
  final VoidCallback? onTap;
  final double? customWidth;
  final double? customHeight;

  ReactionPreviewUiModel({
    this.imagePath,
    this.viewed = false,
    this.onTap,
    this.isEmpty = false,
    this.customWidth,
    this.customHeight,
  });
}
