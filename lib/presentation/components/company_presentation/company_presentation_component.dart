import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CompanyPresentationComponent extends StatelessWidget {
  const CompanyPresentationComponent({super.key, required this.pagingController});
  final PagingController pagingController;

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final boldTextTheme = theme?.boldTextTheme;
    final regularTextTheme = theme?.regularTextTheme;
    return Scaffold(
        body: BlurredAppBarPage(
      autoImplyLeading: true,
      centerTitle: true,
      customTitle: Expanded(
        child: Text(
          'Push up your business',
          style: context.uiKitTheme?.boldTextTheme.title1,
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
      ),
      customToolbarBaseHeight: 0.13.sh,
      childrenPadding:
          EdgeInsets.symmetric(horizontal: EdgeInsetsFoundation.horizontal16),
      children: [
        SpacingFoundation.verticalSpace16,
        SizedBox(
          height: 0.17.sh,
          child: UiKitCardWrapper(
            gradient: theme?.themeMode == ThemeMode.light
                ? GradientFoundation.lightShunyGreyGradient
                : GradientFoundation.shunyGreyGradient,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfluencerAccountMark(),
                SpacingFoundation.horizontalSpace4,
                Expanded(
                  child: Text(
                    'You attract specialized text, You attract specialized text You attract specialized text You attract specialized text v You attract specialized text You attract specialized text You attract specialized text You attract specialized textv',
                    style:regularTextTheme?.caption1,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ).paddingAll(EdgeInsetsFoundation.all16),
          ),
        )
      ],
    ));
  }
}
