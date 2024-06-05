import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class SettingsComponent extends StatelessWidget {
  final ValueChanged<int>? onTabSwitched;
  final String? selectedContentType;
  final List<UiKitCustomTab>? tabs;
  final List<BaseUiKitButtonData> btnDataList;
  final VoidCallback? onSubmitContent;
  final List<BaseUiKitButtonData> controlExpansionTileButtons;
  final List<BaseUiKitButtonData>? proControlExpansionTileButtons;

  const SettingsComponent({
    Key? key,
    this.onTabSwitched,
    this.selectedContentType,
    this.tabs,
    this.onSubmitContent,
    required this.btnDataList,
    required this.controlExpansionTileButtons,
    this.proControlExpansionTileButtons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = GlobalConfiguration().appConfig.content['profile_settings'];
    final model = ComponentModel.fromJson(config);

    final bodyAligment = model.positionModel?.bodyAlignment;

    final textStyle = context.uiKitTheme?.boldTextTheme;
    const divider = Divider(
      height: 1,
      thickness: 1,
      color: ColorsFoundation.surface2,
    );

    return Column(
      children: [
        Text(
          S.current.Settings,
          style: textStyle?.title1,
        ),
        SpacingFoundation.verticalSpace12,
        if (tabs != null) ...[
          SpacingFoundation.verticalSpace16,
          UiKitCustomTabBar(
            selectedTab: selectedContentType,
            onTappedTab: (index) => onTabSwitched?.call(index),
            tabs: tabs!,
          ).paddingSymmetric(
              horizontal:
                  model.positionModel?.horizontalMargin?.toDouble() ?? 0),
          SpacingFoundation.verticalSpace12,
        ],
        if (onSubmitContent != null)
          UiKitShadowWrapper(
            backgroundColor: context.uiKitTheme?.colorScheme.primary,
            borderRadius: BorderRadiusFoundation.all24,
            color: ColorsFoundation.lightSurface1.withOpacity(0.6),
            child: context.outlinedButton(
              data: BaseUiKitButtonData(
                text: S.current.SubmitContent,
                onPressed: () {},
                backgroundColor: context.uiKitTheme?.colorScheme.primary,
              ),
            ),
          ).paddingSymmetric(
              horizontal: EdgeInsetsFoundation.horizontal16,
              vertical: EdgeInsetsFoundation.vertical12),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: bodyAligment.crossAxisAlignment,
          mainAxisAlignment: bodyAligment.mainAxisAlignment,
          children: btnDataList
              .map(
                (e) => [
                  UiKitInlineButton(data: e),
                  SpacingFoundation.verticalSpace16,
                  divider,
                  SpacingFoundation.verticalSpace16,
                ],
              )
              .expand((element) => element)
              .toList(),
        ).paddingSymmetric(
            horizontal: model.positionModel?.horizontalMargin?.toDouble() ?? 0),
        if (proControlExpansionTileButtons != null) ...[
          UiKitExpansionTile(
            leadingIconData:
                BaseUiKitButtonIconData(iconData: ShuffleUiKitIcons.label),
            title: S.current.ProTools.toUpperCase(),
            children: proControlExpansionTileButtons!
                .map((e) => UiKitInlineButton(
                      data: e,
                    ))
                .toList(),
          ),
          divider,
          SpacingFoundation.verticalSpace16,
        ],
        UiKitExpansionTile(
          leadingIconData:
              BaseUiKitButtonIconData(iconData: ShuffleUiKitIcons.tool),
          title: S.current.Control.toUpperCase(),
          children: controlExpansionTileButtons
              .map((e) => UiKitInlineButton(
                    data: e,
                  ))
              .toList(),
        ),
        kBottomNavigationBarHeight.heightBox
      ],
    ).paddingSymmetric(
      vertical: model.positionModel?.verticalMargin?.toDouble() ?? 0,
    );
  }
}
