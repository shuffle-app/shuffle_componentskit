import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class VideoReactionModeration extends StatelessWidget {
  final List<ReactionPreviewUiModel> reactionPreviewModelList;
  final VoidCallback? sortDateFunction;
  final bool newFirst;
  final VoidCallback? sortModeratedFunction;
  final bool moderatedFirst;

  const VideoReactionModeration({
    super.key,
    required this.reactionPreviewModelList,
    this.sortDateFunction,
    required this.newFirst,
    this.sortModeratedFunction,
    required this.moderatedFirst,
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
          Row(
            children: [
              Text(
                S.of(context).VideoReactions,
                style: textTheme?.title1,
              ),
              const Spacer(),
              if (sortDateFunction != null) ...[
                Text(
                  'Sorted from ${newFirst ? 'Newest' : 'Oldest'}',
                ),
                SpacingFoundation.horizontalSpace4,
                context.iconButtonNoPadding(
                  data: BaseUiKitButtonData(
                    onPressed: sortDateFunction,
                    iconInfo: BaseUiKitButtonIconData(
                      iconData: ShuffleUiKitIcons.arrowssort,
                    ),
                  ),
                )
              ],
              if (sortModeratedFunction != null) ...[
                SpacingFoundation.horizontalSpace16,
                Text(
                  'Sorted from ${moderatedFirst ? 'Moderated' : 'Not Moderated'}',
                ),
                SpacingFoundation.horizontalSpace4,
                context.iconButtonNoPadding(
                    data: BaseUiKitButtonData(
                  onPressed: sortModeratedFunction,
                  iconInfo: BaseUiKitButtonIconData(
                    iconData: ShuffleUiKitIcons.arrowssort,
                  ),
                ))
              ]
            ],
          ).paddingAll(EdgeInsetsFoundation.all24),
          Expanded(
            child: GridView.builder(
              addAutomaticKeepAlives: false,
              shrinkWrap: true,
              itemCount: reactionPreviewModelList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: SpacingFoundation.horizontalSpacing24,
                  mainAxisSpacing: SpacingFoundation.horizontalSpacing24,
                  crossAxisCount: 3,
                  childAspectRatio: 142 / 250),
              itemBuilder: (context, index) {
                final reactionPreviewModelItem = reactionPreviewModelList[index];
                return UiKitReactionPreview(
                  isModerated: reactionPreviewModelItem.isModerated,
                  isEmpty: reactionPreviewModelItem.isEmpty,
                  imagePath: reactionPreviewModelItem.imagePath,
                  viewed: reactionPreviewModelItem.viewed,
                  onTap: reactionPreviewModelItem.onTap,
                );
              },
            ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing32),
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
  bool isModerated;

  ReactionPreviewUiModel({
    this.imagePath,
    this.viewed = false,
    this.onTap,
    this.isEmpty = false,
    this.customWidth,
    this.customHeight,
    this.isModerated = false,
  });
}
