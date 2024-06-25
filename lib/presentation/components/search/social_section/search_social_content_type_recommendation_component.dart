import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class SearchSocialContentTypeRecommendationComponent extends StatelessWidget {
  final String title;
  final ValueChanged? onContentPressed;
  final VoidCallback? onFilterPressed;

  const SearchSocialContentTypeRecommendationComponent({
    super.key,
    required this.title,
    this.onContentPressed,
    this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.uiKitTheme?.boldTextTheme;
    final colorScheme = context.uiKitTheme?.colorScheme;
    final config = GlobalConfiguration().appConfig.content['search_social_content_type_recommendation'];
    final model = ComponentModel.fromJson(config);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();

    return BlurredAppBarPage(
      centerTitle: true,
      title: title,
      autoImplyLeading: true,
      children: [
        SpacingFoundation.verticalSpace16,
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Filter',
              style: textTheme?.labelLarge,
            ),
            SpacingFoundation.horizontalSpace12,
            context.outlinedBadgeButton(
              badgeAlignment: Alignment.topRight,
              data: BaseUiKitButtonData(
                onPressed: onFilterPressed,
                iconInfo: BaseUiKitButtonIconData(
                  iconData: ShuffleUiKitIcons.filter,
                  color: colorScheme?.inverseSurface,
                ),
              ),
            ),
            SpacingFoundation.horizontalSpace16,
          ],
        ),
        SpacingFoundation.verticalSpace16,
        ...List<Widget>.generate(
          5,
          (index) => UiKitShadedContentCard(
            title: 'Lorem ipsum',
            subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            recommended: index % 2 == 0,
            availableWidth: 1.sw - (horizontalMargin * 2),
            onPressed: () => onContentPressed?.call(''),
            imageUrl: GraphicsFoundation.instance.png.mockAdBanner4.path,
          ).paddingOnly(
            bottom: SpacingFoundation.verticalSpacing16,
            left: horizontalMargin,
            right: horizontalMargin,
          ),
        ),
        SpacingFoundation.bottomNavigationBarSpacing,
      ],
    );
  }
}
