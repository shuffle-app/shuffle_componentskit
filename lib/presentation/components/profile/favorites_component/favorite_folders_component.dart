import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/common/place_preview.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class FavoriteFoldersComponent extends StatelessWidget {
  const FavoriteFoldersComponent({
    super.key,
    this.onShareTap,
    required this.places,
  });

  final VoidCallback? onShareTap;
  final List<PlacePreview> places;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurredAppBarPage(
        customToolbarBaseHeight: 0.13.sh,
        autoImplyLeading: true,
        centerTitle: true,
        appBarTrailing: context.iconButtonNoPadding(
          data: BaseUiKitButtonData(
            onPressed: onShareTap,
            iconInfo: BaseUiKitButtonIconData(
              iconData: ShuffleUiKitIcons.share,
              color: ColorsFoundation.mutedText,
            ),
          ),
        ),
        customTitle: Expanded(
          child: Text(
            'The best tech conf',
            style: context.uiKitTheme?.boldTextTheme.title1,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
        childrenPadding: EdgeInsets.all(EdgeInsetsFoundation.all16),
        children: places,
      ),
    );
  }
}
