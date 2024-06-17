import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/components.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class FavoritesMergeComponent extends StatelessWidget {
  const FavoritesMergeComponent({super.key, required this.contentsList});

  final List<UiModelFavoritesMergeContentList> contentsList;

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: ImageWidget(
            iconData: ShuffleUiKitIcons.cross,
            color: theme?.colorScheme.darkNeutral900,
            height: 19.h,
            fit: BoxFit.fitHeight,
          ),
        ),
        SpacingFoundation.verticalSpace16,
        SizedBox(
          height: 0.8.sh,
          child: UiKitCardWrapper(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    S.current.TheseContentIsOnYourOtherLists,
                    style: theme?.regularTextTheme.body.copyWith(
                        color: ColorsFoundation.lightHeadingTypographyColor),
                  ),
                  SpacingFoundation.verticalSpace12,
                  ...List.generate(
                    contentsList.length,
                    (index) {
                      return Column(
                        children: [
                          Text(
                            contentsList[index].title,
                            style: theme?.regularTextTheme.caption1
                                .copyWith(color: ColorsFoundation.mutedText),
                          ),
                          SpacingFoundation.verticalSpace12,
                          ...contentsList[index].contents.map((e) {
                            return UiKitExtendedInfluencerFeedbackCardWithoutBottom(
                              imageUrl: e.imageUrl,
                              title: e.title,
                              tags: e.tags,
                            ).paddingSymmetric(
                                vertical: EdgeInsetsFoundation.vertical4);
                          }),
                          SpacingFoundation.verticalSpace12,
                        ],
                      );
                    },
                  )
                ],
              ).paddingAll(EdgeInsetsFoundation.all16),
            ),
          ),
        ),
      ],
    ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16);
  }
}
