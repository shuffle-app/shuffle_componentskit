import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/common/place_preview.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class FavoriteFoldersBottomSheetComponent extends StatelessWidget {
  const FavoriteFoldersBottomSheetComponent({
    super.key,
    this.onAddToMyFavorites,
    required this.places,
    required this.personName,
  });

  final VoidCallback? onAddToMyFavorites;
  final List<PlacePreview> places;
  final String personName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: '$personName ',
            style: context.uiKitTheme?.boldTextTheme.title2,
            children: [
              TextSpan(
                text: S.current.SharedWithYou,
                style: context.uiKitTheme?.regularTextTheme.title2,
              ),
            ],
          ),
        ),
        SpacingFoundation.verticalSpace8,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            context.smallOutlinedButton(
              data: BaseUiKitButtonData(
                text: S.current.AddToMyFavorites,
                onPressed: onAddToMyFavorites,
                backgroundColor: context.uiKitTheme?.colorScheme.primary,
              ),
            ),
          ],
        ),
        SpacingFoundation.verticalSpace16,
        Text(
          S.current.TheBestTechnologiesConf,
          style: context.uiKitTheme?.boldTextTheme.title2,
        ),
        SpacingFoundation.verticalSpace16,
        ...places.map(
          (e) => e.paddingSymmetric(vertical: EdgeInsetsFoundation.vertical8),
        ),
      ],
    ).paddingAll(EdgeInsetsFoundation.all16);
  }
}
